using FragSharpFramework;

namespace GpuSim
{
    public partial class Movement_Phase1 : SimShader
    {
        [FragmentShader]
        data FragmentShader(VertexOut vertex, Field<data> Current, Field<vec4> Random)
        {
            data here = Current[Here], output = data.Nothing;

            // If something is here, they have the right to stay.
            if (Something(here))
            {
                output = here;
                
                if (!IsStationary(here)) output.change = Change.Stayed;
                return output;
            }

            // Otherwise, check each direction to see if something is incoming.
            data
                right = Current[RightOne],
                up    = Current[UpOne],
                left  = Current[LeftOne],
                down  = Current[DownOne];

            float rnd = RndFint(Random[Here].x, _0, _3);
            if (rnd == _0)
            {
                if (right.action != UnitAction.Stopped && right.action != UnitAction.Guard && right.direction == Dir.Left) output = right;
                if (up.action != UnitAction.Stopped && up.action != UnitAction.Guard && up.direction == Dir.Down) output = up;
                if (left.action != UnitAction.Stopped && left.action != UnitAction.Guard && left.direction == Dir.Right) output = left;
                if (down.action != UnitAction.Stopped && down.action != UnitAction.Guard && down.direction == Dir.Up) output = down;
            }
            else if (rnd == _1)
            {
                if (down.action != UnitAction.Stopped && down.action != UnitAction.Guard && down.direction == Dir.Up) output = down;
                if (right.action != UnitAction.Stopped && right.action != UnitAction.Guard && right.direction == Dir.Left) output = right;
                if (up.action != UnitAction.Stopped && up.action != UnitAction.Guard && up.direction == Dir.Down) output = up;
                if (left.action != UnitAction.Stopped && left.action != UnitAction.Guard && left.direction == Dir.Right) output = left;
            }
            else if (rnd == _2)
            {
                if (left.action != UnitAction.Stopped && left.action != UnitAction.Guard && left.direction == Dir.Right) output = left;
                if (down.action != UnitAction.Stopped && down.action != UnitAction.Guard && down.direction == Dir.Up) output = down;
                if (right.action != UnitAction.Stopped && right.action != UnitAction.Guard && right.direction == Dir.Left) output = right;
                if (up.action != UnitAction.Stopped && up.action != UnitAction.Guard && up.direction == Dir.Down) output = up;
            }
            else if (rnd == _3)
            {
                if (up.action != UnitAction.Stopped && up.action != UnitAction.Guard && up.direction == Dir.Down) output = up;
                if (left.action != UnitAction.Stopped && left.action != UnitAction.Guard && left.direction == Dir.Right) output = left;
                if (down.action != UnitAction.Stopped && down.action != UnitAction.Guard && down.direction == Dir.Up) output = down;
                if (right.action != UnitAction.Stopped && right.action != UnitAction.Guard && right.direction == Dir.Left) output = right;
            }


            if (Something(output))
            {
                output.change = Change.Moved;
                return output;
            }
            else
            {
                output = here;
                output.change = Change.Stayed;
                return output;
            }
        }
    }

    public partial class Movement_Phase2 : SimShader
    {
        [FragmentShader]
        data FragmentShader(VertexOut vertex, Field<data> Current, Field<data> Next)
        {
            data next = Next[Here];
            data here = Current[Here];

            if (IsStationary(next)) return next;

            data ahead = Next[dir_to_vec(here.direction)];
            if (ahead.change == Change.Moved && ahead.direction == here.direction)
                next = data.Nothing;

            set_prior_direction(ref next, next.direction);

            return next;
        }
    }

    public partial class Movement_Convect : SimShader
    {
        [FragmentShader]
        vec4 FragmentShader(VertexOut vertex, Field<vec4> Data, Field<data> CurrentData)
        {
            data here = CurrentData[Here];
            vec4 output = vec4.Zero;

            if (Something(here))
            {
                if (Stayed(here))
                    output = Data[Here];
                else
                    output = Data[dir_to_vec(Reverse(prior_direction(here)))];
            }

            return output;
        }
    }

    public partial class Movement_UpdateDirection_RemoveDead : SimShader
    {
        [FragmentShader]
        data FragmentShader(VertexOut vertex, Field<vec4> TargetData, Field<unit> Unit, Field<extra> Extra, Field<data> Data, Field<data> PrevData, Field<vec4> PathToOtherTeams, Field<vec4> RandomField,
                            Field<geo> Geo, Field<geo> AntiGeo,
                            Field<dirward> DirwardRight, Field<dirward> DirwardLeft, Field<dirward> DirwardUp, Field<dirward> DirwardDown)
        {
            data  data_here  = Data[Here];

            if (Something(data_here))
            {
                data path = data.Nothing;

                // Get info for this unit
                unit  here       = Unit[Here];

                // Remove if dead unit
                if (here.anim == Anim.Dead && IsUnit(here))
                {
                    return data.Nothing;
                }

                building b = (building)(vec4)data_here;
                if (IsBuilding(here))
                {
                    // If this building is alive
                    if (data_here.direction == Dir.Stationary)
                    {
                        // If this is a building that has been hit enough times to explode
                        if (here.hit_count >= _5)
                        {
                            data_here.direction = Dir.StationaryDying;
                        }
                    }
                    else
                    {
                        // Otherwise remove it if the explosion animation is done
                        float frame = ExplosionSpriteSheet.ExplosionFrame(0, b);

                        if (frame >= ExplosionSpriteSheet.AnimLength)
                            return data.Nothing;
                    }
                }

                // Buildings can't move.
                if (IsBuilding(here))
                {
                    if (IsCenter((building)(vec4)data_here))
                    {
                        // Set the building direction toward its "target".
                        set_prior_direction(ref data_here, BuildingDirection(vertex, TargetData, (building)(vec4)data_here));
                    }
                    return data_here;
                }

                // Get nearby paths to other teams
                vec4
                    _value_right = PathToOtherTeams[RightOne],
                    _value_up    = PathToOtherTeams[UpOne],
                    _value_left  = PathToOtherTeams[LeftOne],
                    _value_down  = PathToOtherTeams[DownOne];

                // Get specific paths to enemies of this particular unit
                float value_right = 1, value_left = 1, value_up = 1, value_down = 1;
                if (here.team == Team.One)
                {
                    value_right = _value_right.x;
                    value_left  = _value_left.x;
                    value_up    = _value_up.x;
                    value_down  = _value_down.x;
                }
                else if (here.team == Team.Two)
                {
                    value_right = _value_right.y;
                    value_left  = _value_left.y;
                    value_up    = _value_up.y;
                    value_down  = _value_down.y;
                }
                else if (here.team == Team.Three)
                {
                    value_right = _value_right.z;
                    value_left  = _value_left.z;
                    value_up    = _value_up.z;
                    value_down  = _value_down.z;
                }
                else if (here.team == Team.Four)
                {
                    value_right = _value_right.w;
                    value_left  = _value_left.w;
                    value_up    = _value_up.w;
                    value_down  = _value_down.w;
                }

                const float auto_attack_cutoff = _12;

                float min = 256;
                float hold_dir = data_here.direction;
                if (data_here.action == UnitAction.Attacking || data_here.action == UnitAction.Guard)
                {
                    if (value_right < min) { data_here.direction = Dir.Right; min = value_right; }
                    if (value_up    < min) { data_here.direction = Dir.Up;    min = value_up; }
                    if (value_left  < min) { data_here.direction = Dir.Left;  min = value_left; }
                    if (value_down  < min) { data_here.direction = Dir.Down;  min = value_down; }
                }

                if (min > auto_attack_cutoff) data_here.direction = hold_dir;

                // If we are guarding and a unit is close, switch to attacking
                if (min < auto_attack_cutoff && data_here.action == UnitAction.Guard)
                {
                    data_here.action = UnitAction.Attacking;
                }

                // If we aren't attacking, or if a unit is too far away
                if (min > auto_attack_cutoff && data_here.action == UnitAction.Attacking || data_here.action == UnitAction.Moving)
                {
                    NaivePathfind(vertex, Data, PrevData, TargetData, Extra, RandomField,
                                  Geo, AntiGeo,
                                  DirwardRight, DirwardLeft, DirwardUp, DirwardDown,
                                  here, ref data_here);
                }
            }

            return data_here;
        }

        void swap(ref float a, ref float b)
        {
            float _ = a;
            a = b;
            b = _;
        }

        void swap(ref vec2 a, ref vec2 b)
        {
            vec2 _ = a;
            a = b;
            b = _;
        }

        void swap(ref bool a, ref bool b)
        {
            bool _ = a;
            a = b;
            b = _;
        }

        void swap(ref dirward a, ref dirward b)
        {
            dirward _ = a;
            a = b;
            b = _;
        }

        void NaivePathfind(VertexOut vertex, Field<data> Current, Field<data> Previous, Field<vec4> TargetData, Field<extra> Extra, Field<vec4> RandomField,
                           Field<geo> Geo, Field<geo> AntiGeo,
                           Field<dirward> DirwardRight, Field<dirward> DirwardLeft, Field<dirward> DirwardUp, Field<dirward> DirwardDown,
                           unit data, ref data here)
        {
            // Get geodesic info (of both polarities)
            geo
                geo_here     = Geo[Here],
                antigeo_here = AntiGeo[Here];

            // Unpack packed info
            vec4 target = TargetData[Here];
            vec2 CurPos = floor((vertex.TexCoords * TargetData.Size + vec(.5f, .5f)));
            vec2 Destination = floor(unpack_vec2((vec4)target));

            // Get nearby units
            data
                right = Current[RightOne],
                up    = Current[UpOne],
                left  = Current[LeftOne],
                down  = Current[DownOne];

            data
                prev_right = Previous[RightOne],
                prev_up    = Previous[UpOne],
                prev_left  = Previous[LeftOne],
                prev_down  = Previous[DownOne];

            extra extra_here = Extra[Here];

            // Calculation primary and secondary direction to travel (dir1 and dir2 respectively)
            float
                dir1 = Dir.None,
                dir2 = Dir.None;

            if (Destination.x > CurPos.x + .75f) dir1 = Dir.Right;
            if (Destination.x < CurPos.x - .75f) dir1 = Dir.Left;
            if (Destination.y > CurPos.y + .75f) dir1 = Dir.Up;
            if (Destination.y < CurPos.y - .75f) dir1 = Dir.Down;

            
            vec2 diff = Destination - CurPos;
            vec2 mag = abs(diff);

            //float prior_dir = prior_direction(here);
            float prior_dir = Dir.None;

            bool blocked1 = false;
            if (mag.x > mag.y && Destination.x > CurPos.x + 1) { dir1 = Dir.Right; blocked1 = Something(right) || Something(prev_right) && prior_dir != Dir.Left; }
            if (mag.y > mag.x && Destination.y > CurPos.y + 1) { dir1 = Dir.Up;    blocked1 = Something(up)    || Something(prev_up)    && prior_dir != Dir.Down; }
            if (mag.x > mag.y && Destination.x < CurPos.x - 1) { dir1 = Dir.Left;  blocked1 = Something(left)  || Something(prev_left)  && prior_dir != Dir.Right; }
            if (mag.y > mag.x && Destination.y < CurPos.y - 1) { dir1 = Dir.Down;  blocked1 = Something(down)  || Something(prev_down)  && prior_dir != Dir.Up; }

            bool blocked2 = false;
            if (dir1 == Dir.Right || dir1 == Dir.Left)
            {
                if      (Destination.y > CurPos.y + 0) { dir2 = Dir.Up;    blocked2 = Something(up)    || Something(prev_up)   && prior_dir != Dir.Down; }
                else if (Destination.y < CurPos.y - 0) { dir2 = Dir.Down;  blocked2 = Something(down)  || Something(prev_down) && prior_dir != Dir.Up; }
            }
            if (dir1 == Dir.Up || dir1 == Dir.Down)
            {
                if      (Destination.x > CurPos.x + 0) { dir2 = Dir.Right; blocked2 = Something(right) || Something(prev_right) && prior_dir != Dir.Left; }
                else if (Destination.x < CurPos.x - 0) { dir2 = Dir.Left;  blocked2 = Something(left)  || Something(prev_left)  && prior_dir != Dir.Right; }
            }

            // Get current coordinate
            vec2 pos_here = vertex.TexCoords * Geo.Size;

            // Get dirward extensions for each direction, as well as whether we need to cross over an obstacle to get to where we want to go in that direction.
            dirward dirward_here1 = dirward.Nothing;
            dirward dirward_here2 = dirward.Nothing;
            
            bool other_side1 = GetDirward(ref dirward_here1, dir1, ref Destination, ref pos_here, DirwardRight, DirwardLeft, DirwardUp, DirwardDown);
            bool other_side2 = GetDirward(ref dirward_here2, dir2, ref Destination, ref pos_here, DirwardRight, DirwardLeft, DirwardUp, DirwardDown);

            // Get polarity based on the dirward extensions
            float
                polarity1 = dirward_here1.polarity,
                polarity2 = dirward_here2.polarity,
                chosen_polarity = -1;

            // If this unit has already picked a polarity for this geodesic area, then we will stick with that polarity
            if (extra_here.geo_id == geo_here.geo_id && extra_here.polarity_set == _true)
            {
                polarity1 = extra_here.polarity;
                polarity2 = extra_here.polarity;
            }

            // Get geodesic info associated with primary and secondary direction (geo1 for dir1 and geo2 for dir2)
            geo
                geo1 = polarity1 == 1 ? antigeo_here : geo_here,
                geo2 = polarity2 == 1 ? antigeo_here : geo_here;

            // Check if we should follow the geodesic we are on
            vec2 geo_id = geo1.geo_id;
            bool use_simple_pathing = false;
            
            if      (geo1.dir > 0 && ValidDirward(dirward_here1) && other_side1 && dirward_here1.geo_id == geo_id && (geo1.dist == _0 || blocked1 || extra_here.polarity_set == _true && extra_here.geo_id == geo1.geo_id))
            {
                dir1 = geo1.dir;
                chosen_polarity = polarity1;
            }
            else if (geo2.dir > 0 && ValidDirward(dirward_here2) && other_side2 && dirward_here2.geo_id == geo_id && (geo2.dist == _0 || blocked2 || extra_here.polarity_set == _true && extra_here.geo_id == geo2.geo_id))
            {
                dir1 = geo2.dir;
                chosen_polarity = other_side1 && ValidDirward(dirward_here1) ? polarity1 : polarity2;
                //chosen_polarity = polarity2;
            }
            else
            {
                // If not, then use Simple Pathing
                use_simple_pathing = true;
            }

            // Prevent immediate direction reversals
            //float avoid = Reverse(prior_direction(here));
            //if (!use_simple_pathing && IsValid(dir1) && dir1 == avoid)
            //    dir1 = dir2;

            // If geodesic pathfinding has us running into something...
            if (!use_simple_pathing && (Something(Current[dir_to_vec(dir1)]) || geo1.dist > _0) && geo1.dist < 1)
            {
                // Turn inward toward the obstacles, if that direction is open
                float alt_dir;
                if (chosen_polarity == 0)
                    alt_dir = RotateLeft(dir1);
                else
                    alt_dir = RotateRight(dir1);
                if (!Something(Current[dir_to_vec(alt_dir)]) && !Something(Previous[dir_to_vec(alt_dir)]))
                    dir1 = alt_dir;

                // ... default to simple pathfinding
                //use_simple_pathing = true;
            }

            if (use_simple_pathing)
            {
                // Go toward the cardinal direction that is furthest away. If something is in your way, go perpendicularly, assuming you also need to go in that direction.
                if ((mag.x > mag.y || diff.y > 0 && Something(up)    || diff.y < 0 && Something(down)) && Destination.x > CurPos.x + 1 && !Something(right)) dir1 = Dir.Right;
                if ((mag.y > mag.x || diff.x > 0 && Something(right) || diff.x < 0 && Something(left)) && Destination.y > CurPos.y + 1 && !Something(up))    dir1 = Dir.Up;
                if ((mag.x > mag.y || diff.y > 0 && Something(up)    || diff.y < 0 && Something(down)) && Destination.x < CurPos.x - 1 && !Something(left))  dir1 = Dir.Left;
                if ((mag.y > mag.x || diff.x > 0 && Something(right) || diff.x < 0 && Something(left)) && Destination.y < CurPos.y - 1 && !Something(down))  dir1 = Dir.Down;
            }


            //if      (Something(down) && Extra[DownOne].polarity_set == _true)
            //    chosen_polarity = Extra[DownOne].polarity;
            //else if (Something(right) && Extra[RightOne].polarity_set == _true)
            //    chosen_polarity = Extra[RightOne].polarity;

            //if (dir1 == Dir.Down)
            //    chosen_polarity = Extra[DownOne].polarity;
            //chosen_polarity = 1;

            if (IsValid(dir1) && Something(Current[dir_to_vec(dir1)]))
            {
                // Resolve polarity collisions. Down/Right units have preference in spreading their polarity during collisions.
                //if (chosen_polarity >= 0 && !use_simple_pathing && (dir1 == Dir.Down || dir1 == Dir.Right))
                //{
                //    extra extra_in_our_way = Extra[dir_to_vec(dir1)];

                //    if (extra_in_our_way.polarity_set == _true)
                //        chosen_polarity = extra_in_our_way.polarity;

                //    use_simple_pathing = false;
                //}

                if (chosen_polarity >= 0 && !use_simple_pathing)
                {
                    extra
                        extra_right = Extra[RightOne],
                        extra_up    = Extra[UpOne];

                    if (extra_right.polarity_set == _true)
                        chosen_polarity = extra_right.polarity;
                    if (extra_up.polarity_set == _true)
                        chosen_polarity = extra_up.polarity;

                    use_simple_pathing = false;
                }

                // Choose random direction
                vec4 rnd = RandomField[Here];
                if (rnd.x < .1f)
                {
                    dir1 = RndFint(rnd.y, Dir.Right, Dir.Down);
                }
            }

            // Last check: is there something in the way of where we want to go? If so, use the alternative orthogonal route (which may be the same direction, but hey, at least we tried).
            //if (Something(Current[dir_to_vec(dir)])) dir = dir2;

            if (IsValid(dir1))
            {
                here.direction = dir1;

                if (chosen_polarity >= 0 && !use_simple_pathing)
                {
                    here.change += chosen_polarity == 1 ? SetPolarity.Counterclockwise : SetPolarity.Clockwise;
                }
            }
            else
            {
                if (here.action == UnitAction.Attacking)
                    here.action = UnitAction.Guard;
            }
        }

        bool GetDirward(ref dirward dirward_here, float dir, ref vec2 Destination, ref vec2 pos_here, Field<dirward> DirwardRight, Field<dirward> DirwardLeft, Field<dirward> DirwardUp, Field<dirward> DirwardDown)
        {
            if      (dir == Dir.Right) { dirward_here = DirwardRight[Here]; return Destination.x > pos_here.x + Float(dirward_here.dist_to_wall); }
            else if (dir == Dir.Left)  { dirward_here = DirwardLeft[Here];  return Destination.x < pos_here.x - Float(dirward_here.dist_to_wall); }
            else if (dir == Dir.Up)    { dirward_here = DirwardUp[Here];    return Destination.y > pos_here.y + Float(dirward_here.dist_to_wall); }
            else if (dir == Dir.Down)  { dirward_here = DirwardDown[Here];  return Destination.y < pos_here.y - Float(dirward_here.dist_to_wall); }
            
            return false;
        }

        float BuildingDirection(VertexOut vertex, Field<vec4> TargetData, building here)
        {
            float dir = Dir.Right;

            vec4 target = TargetData[Here];

            // Unpack packed info
            vec2 CurPos = vertex.TexCoords * TargetData.Size;
            vec2 Destination = unpack_vec2((vec4)target);

            vec2 diff = Destination - CurPos;
            vec2 mag = abs(diff);
            if (mag.x > mag.y && diff.x > 0) dir = Dir.Right;
            if (mag.x > mag.y && diff.x < 0) dir = Dir.Left;
            if (mag.y > mag.x && diff.y > 0) dir = Dir.Up;
            if (mag.y > mag.x && diff.y < 0) dir = Dir.Down;

            return dir;
        }
    }

    public partial class Movement_SetPolarity_Phase1 : SimShader
    {
        [FragmentShader]
        extra FragmentShader(VertexOut vertex, Field<data> Data, Field<extra> Extra, Field<geo> Geo, Field<geo> AntiGeo)
        {
            data data_here = Data[Here];
            extra extra_here = Extra[Here];
            geo geo_here = Geo[Here];

            if (data_here.change >= SetPolarity.Counterclockwise)
            {
                extra_here.geo_id = geo_here.geo_id;
                extra_here.polarity_set = _true;
                extra_here.polarity = 1;
            }
            else if (data_here.change >= SetPolarity.Clockwise)
            {
                extra_here.geo_id = geo_here.geo_id;
                extra_here.polarity_set = _true;
                extra_here.polarity = 0;
            }

            return extra_here;
        }
    }

    public partial class Movement_SetPolarity_Phase2 : SimShader
    {
        [FragmentShader]
        data FragmentShader(VertexOut vertex, Field<data> Data)
        {
            data data_here = Data[Here];

            if (data_here.change >= SetPolarity.Counterclockwise)
            {
                data_here.change -= SetPolarity.Counterclockwise;
            }
            else if (data_here.change >= SetPolarity.Clockwise)
            {
                data_here.change -= SetPolarity.Clockwise;
            }

            return data_here;
        }
    }
}
