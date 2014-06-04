using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;

using FragSharpHelper;
using FragSharpFramework;

namespace GpuSim
{
	/// <summary>
	/// This is the main type for your game
	/// </summary>
	public class M3ngineGame : Game
	{
        public static M3ngineGame Game;

		const bool UnlimitedSpeed = false;

        const bool MouseEnabled = true;

		vec2 CameraPos = vec2.Zero;
		float CameraZoom = 30;
        float CameraAspect = 1;
        vec4 camvec { get { return new vec4(CameraPos.x, CameraPos.y, CameraZoom, CameraZoom); } }

		GraphicsDeviceManager graphics;
        
        SpriteBatch MySpriteBatch;
        SpriteFont DefaultFont;

        DataGroup DataGroup;

		Texture2D
            BuildingTexture_1,
            UnitTexture_1, UnitTexture_2, UnitTexture_4, UnitTexture_8, UnitTexture_16,
            GroundTexture,
            
            Cursor, SelectCircle, SelectCircle_Data;

		public M3ngineGame()
		{
            Game = this;

			graphics = new GraphicsDeviceManager(this);

			Window.Title = "Gpu Sim Test";
            graphics.PreferredBackBufferWidth  = 1024;
            graphics.PreferredBackBufferHeight = 1024;
			//graphics.IsFullScreen = rez.Mode == WindowMode.Fullscreen;
            graphics.SynchronizeWithVerticalRetrace = !UnlimitedSpeed;
            IsFixedTimeStep = !UnlimitedSpeed;

			Content.RootDirectory = "Content";
		}

        public vec2 Screen
        {
            get
            {
                return new vec2(graphics.PreferredBackBufferWidth, graphics.PreferredBackBufferHeight);
            }
        }

        public float Restrict(float val, float a, float b)
        {
            if (val < a) return a;
            if (val > b) return b;
            return val;
        }

		void Swap<T>(ref T a, ref T b)
		{
			T temp = a;
			a = b;
			b = temp;
		}

        RectangleQuad Ground;

        Effect test;
		protected override void Initialize()
		{
            //test = Content.Load<Effect>("Shaders/__Test");
            //test = Content.Load<Effect>("Shaders/Counting");
            //return;

            MySpriteBatch = new SpriteBatch(GraphicsDevice);
            DefaultFont = Content.Load<SpriteFont>("Default");

            FragSharp.Initialize(Content, GraphicsDevice);
            GridHelper.Initialize(GraphicsDevice);

            BuildingTexture_1 = Content.Load<Texture2D>("Art\\Buildings_1");

			UnitTexture_1  = Content.Load<Texture2D>("Art\\Units_1");
			UnitTexture_2  = Content.Load<Texture2D>("Art\\Units_2");
			UnitTexture_4  = Content.Load<Texture2D>("Art\\Units_4");
			UnitTexture_8  = Content.Load<Texture2D>("Art\\Units_8");
			UnitTexture_16 = Content.Load<Texture2D>("Art\\Units_16");

			GroundTexture = Content.Load<Texture2D>("Art\\Grass");

            Cursor            = Content.Load<Texture2D>("Art\\Cursor");
            SelectCircle      = Content.Load<Texture2D>("Art\\SelectCircle");
            SelectCircle_Data = Content.Load<Texture2D>("Art\\SelectCircle_Data");

            float GroundRepeat = 100;
            Ground = new RectangleQuad(new vec2(-1, -1), new vec2(1, 1), new vec2(0, 0), new vec2(1, 1) * GroundRepeat);

            DataGroup = new DataGroup(1024, 1024);

			base.Initialize();
		}

		/// <summary>
		/// LoadContent will be called once per game and is the place to load
		/// all of your content.
		/// </summary>
		protected override void LoadContent()
		{
		}

		/// <summary>
		/// UnloadContent will be called once per game and is the place to unload
		/// all content.
		/// </summary>
		protected override void UnloadContent()
		{
			// TODO: Unload any non ContentManager content here
		}

		/// <summary>
		/// Allows the game to run logic such as updating the world,
		/// checking for collisions, gathering input, and playing audio.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Update(GameTime gameTime)
		{
            float FpsRateModifier = 1;

			// Allows the game to exit
            if (Buttons.Back.Down())
				this.Exit();

            Input.Update();

            //const float MaxZoomOut = 5.33333f, MaxZoomIn = 200;
            const float MaxZoomOut = 1, MaxZoomIn = 200;

            // Zoom all the way out
            if (Keys.Space.Pressed())
                CameraZoom = MaxZoomOut;

            // Zoom in/out, into the location of the cursor
            var world_mouse_pos = ScreenToWorldCoord(Input.CurMousePos);
            var hold_camvec = camvec;

            if (MouseEnabled)
            {
                float MouseWheelZoomRate = 1.3333f * FpsRateModifier;
                if (Input.DeltaMouseScroll < 0) CameraZoom /= MouseWheelZoomRate;
                else if (Input.DeltaMouseScroll > 0) CameraZoom *= MouseWheelZoomRate;
            }

            float KeyZoomRate = 1.125f * FpsRateModifier;
            if      (Buttons.X.Down() || Keys.X.Pressed() || Keys.E.Pressed()) CameraZoom /= KeyZoomRate;
            else if (Buttons.A.Down() || Keys.Z.Pressed() || Keys.Q.Pressed()) CameraZoom *= KeyZoomRate;

            if (CameraZoom < MaxZoomOut) CameraZoom = MaxZoomOut;
            if (CameraZoom > MaxZoomIn)  CameraZoom = MaxZoomIn;

            if (MouseEnabled && !(Buttons.A.Pressed() || Buttons.X.Pressed()))
            {
                var shifted = GetShiftedCamera(Input.CurMousePos, camvec, world_mouse_pos);
                CameraPos = shifted;
            }

            // Move the camera via: Click And Drag
            //float MoveRate_ClickAndDrag = .00165f * FpsRateModifier;
            //if (Input.LeftMouseDown)
            //    CameraPos += Input.DeltaMousPos / CameraZoom * MoveRate_ClickAndDrag * new vec2(-1, 1);

            // Move the camera via: Push Edge
            if (MouseEnabled)
            {
                float MoveRate_PushEdge = .07f * FpsRateModifier;
                var push_dir = vec2.Zero;
                float EdgeRatio = .1f;
                push_dir.x += -Restrict((EdgeRatio * Screen.x - Input.CurMousePos.x) / (EdgeRatio * Screen.x), 0, 1);
                push_dir.x += Restrict((Input.CurMousePos.x - (1 - EdgeRatio) * Screen.x) / (EdgeRatio * Screen.x), 0, 1);
                push_dir.y -= -Restrict((EdgeRatio * Screen.y - Input.CurMousePos.y) / (EdgeRatio * Screen.y), 0, 1);
                push_dir.y -= Restrict((Input.CurMousePos.y - (1 - EdgeRatio) * Screen.y) / (EdgeRatio * Screen.y), 0, 1);

                CameraPos += push_dir / CameraZoom * MoveRate_PushEdge;
            }

            // Move the camera via: Keyboard or Gamepad
            var dir = Input.Direction();

            float MoveRate_Keyboard = .07f * FpsRateModifier;
            CameraPos += dir / CameraZoom * MoveRate_Keyboard;


            // Make sure the camera doesn't go too far offscreen
            var TR = ScreenToWorldCoord(new vec2(Screen.x, 0));
            if (TR.x > 1)  CameraPos = new vec2(CameraPos.x - (TR.x - 1), CameraPos.y);
            if (TR.y > 1)  CameraPos = new vec2(CameraPos.x, CameraPos.y - (TR.y - 1));
            var BL = ScreenToWorldCoord(new vec2(0, Screen.y));
            if (BL.x < -1) CameraPos = new vec2(CameraPos.x - (BL.x + 1), CameraPos.y);
            if (BL.y < -1) CameraPos = new vec2(CameraPos.x, CameraPos.y - (BL.y + 1));


            // Switch modes
            if (Keys.B.Pressed())
            {
                CurUserMode = UserMode.PlaceBuilding;
            }

            if (Keys.Escape.Pressed() || Keys.Back.Pressed() || CurUserMode == UserMode.PlaceBuilding && Input.RightMousePressed)
            {
                CurUserMode = UserMode.Select;
            }

			base.Update(gameTime);
		}

        const double DelayBetweenUpdates = .3333;
        //const double DelayBetweenUpdates = 5;
		double SecondsSinceLastUpdate = DelayBetweenUpdates;
		public static float PercentSimStepComplete = 0;

        int DrawCount = 0;

        public enum UserMode { PlaceBuilding, Select };
        public UserMode CurUserMode = UserMode.PlaceBuilding;
        public float BuildingType = SimShader.UnitType.GoldMine;

        bool CanPlaceBuilding = false;
        bool[] CanPlace = new bool[3 * 3];

		/// <summary>
		/// This is called when the game should draw itself.
		/// </summary>
		/// <param name="gameTime">Provides a snapshot of timing values.</param>
		protected override void Draw(GameTime gameTime)
		{
            DrawCount++;

			//if (CurKeyboard.IsKeyDown(Keys.Enter))
			SecondsSinceLastUpdate += gameTime.ElapsedGameTime.TotalSeconds;

			// Render setup
			GraphicsDevice.RasterizerState = RasterizerState.CullNone;
			GraphicsDevice.BlendState = BlendState.AlphaBlend;
			GraphicsDevice.DepthStencilState = DepthStencilState.DepthRead;


            PathUpdate();
            DoGoldMineCount();
            DoGoldUpdate();

            switch (CurUserMode)
            {
                case UserMode.PlaceBuilding:
                    PlaceBuilding();
                    break;

                case UserMode.Select:
                    for (int i = 1; i <= 2; i++)
                    {
                        float player = SimShader.Player.Get(i);
                        UnitCount[i] = DoUnitCount(player, false);
                    }

                    SelectedCount = DoUnitCount(SimShader.Player.One, true);
                    Bounds();
                    SelectionUpdate();
                    break;
            }

			// Check if we need to do a simulation update
            if (UnlimitedSpeed || SecondsSinceLastUpdate > DelayBetweenUpdates)
            //if (SecondsSinceLastUpdate > DelayBetweenUpdates)
            {
                SecondsSinceLastUpdate -= DelayBetweenUpdates;

                SimulationUpdate();
            }

            //DrawPrecomputation_Pre.Apply(Current, Previous, Output: DrawPrevious);
            //DrawPrecomputation_Cur.Apply(Current, Previous, Output: DrawCurrent);

            BenchmarkTests.Run(DataGroup.CurrentData, DataGroup.PreviousData);

			// Choose units texture
            Texture2D UnitsSpriteSheet = null, BuildingsSpriteSheet = null;
            float z = 14;
            if (CameraZoom > z)
            {
                BuildingsSpriteSheet = BuildingTexture_1;
                UnitsSpriteSheet = UnitTexture_1;
            }
            else if (CameraZoom > z / 2)
            {
                BuildingsSpriteSheet = BuildingTexture_1;
                UnitsSpriteSheet = UnitTexture_2;
            }
            else if (CameraZoom > z / 4)
            {
                BuildingsSpriteSheet = BuildingTexture_1;
                UnitsSpriteSheet = UnitTexture_4;
            }
            else if (CameraZoom > z / 8)
            {
                BuildingsSpriteSheet = BuildingTexture_1;
                UnitsSpriteSheet = UnitTexture_8;
            }
            else
            {
                BuildingsSpriteSheet = BuildingTexture_1;
                UnitsSpriteSheet = UnitTexture_16;
            }

			// Draw texture to screen
			GraphicsDevice.SetRenderTarget(null);
			GraphicsDevice.Clear(Color.Black);

			PercentSimStepComplete = (float)(SecondsSinceLastUpdate / DelayBetweenUpdates);

            DrawGrass.Using(camvec, CameraAspect, GroundTexture);
            Ground.Draw(GraphicsDevice);

            DrawCorpses.Using(camvec, CameraAspect, DataGroup.Corspes, UnitsSpriteSheet);
            GridHelper.DrawGrid();

            DrawBuildings.Using(camvec, CameraAspect, DataGroup.CurrentData, DataGroup.CurrentUnits, BuildingsSpriteSheet, PercentSimStepComplete);
            GridHelper.DrawGrid();

            if (CameraZoom > z / 8)
                DrawUnits.Using(camvec, CameraAspect, DataGroup.CurrentData, DataGroup.PreviousData, DataGroup.CurrentUnits, DataGroup.PreviousUnits, UnitsSpriteSheet, PercentSimStepComplete);
            else
                DrawUnitsZoomedOut.Using(camvec, CameraAspect, DataGroup.CurrentData, DataGroup.PreviousData, UnitsSpriteSheet, PercentSimStepComplete);
            GridHelper.DrawGrid();


            CanPlaceBuilding = false;
            if (MouseEnabled)
            {
                if (CurUserMode == UserMode.PlaceBuilding)
                {
                    DrawAvailabilityGrid();
                    DrawPotentialBuilding();
                    DrawArrowCursor();
                }

                if (CurUserMode == UserMode.Select)
                {
                    DrawCircleCursor();
                }
            }

            var units_1 = string.Format("Player 1 {0:#,##0}", UnitCount[1]);
            var units_2 = string.Format("Player 2 {0:#,##0}", UnitCount[2]);
            var selected = string.Format("[{0:#,##0}]", SelectedCount);
            var gold = string.Format("Gold {0:#,##0}", Gold[1]);
            var gold_mines = string.Format("Gold Mines {0:#,##0}", GoldMines[1]);
            MySpriteBatch.Begin();
            
            MySpriteBatch.DrawString(DefaultFont, units_1, new Vector2(0, 0), Color.White);
            MySpriteBatch.DrawString(DefaultFont, units_2, new Vector2(0, 20), Color.White);
            MySpriteBatch.DrawString(DefaultFont, gold, new Vector2(0, 40), Color.White);
            MySpriteBatch.DrawString(DefaultFont, gold_mines, new Vector2(0, 60), Color.White);
            
            if (CurUserMode == UserMode.Select)
                MySpriteBatch.DrawString(DefaultFont, selected, Input.CurMousePos + new vec2(30, -130), Color.White);

            MySpriteBatch.End();

			base.Draw(gameTime);
		}

        private void DrawAvailabilityGrid()
        {
            vec2 GridCoord = ScreenToGridCoord(Input.CurMousePos) - new vec2(1, 1);

            int _w = 3, _h = 3;

            color clr = color.TransparentBlack;

            CanPlaceBuilding = true;
            for (int i = 0; i < _w; i++)
            for (int j = 0; j < _h; j++)
            {
                clr = CanPlace[i + j * _h] ? new color(.2f, .7f, .2f, .8f) : new color(.7f, .2f, .2f, .8f);
                DrawSolid.Using(camvec, CameraAspect, clr);

                vec2 gWorldCord = GridToScreenCoord(new vec2((float)Math.Floor(GridCoord.x + i), (float)Math.Floor(GridCoord.y + j)));
                vec2 size = 1 / DataGroup.GridSize;
                RectangleQuad.Draw(GraphicsDevice, gWorldCord + new vec2(size.x, -size.y), size);
            }
        }

        private void DrawPotentialBuilding()
        {
            vec2 GridCoord = ScreenToGridCoord(Input.CurMousePos) - new vec2(1, 1);

            DrawMouse.Using(camvec, CameraAspect, BuildingTexture_1);

            vec2 WorldCord = GridToScreenCoord(new vec2((float)Math.Floor(GridCoord.x), (float)Math.Floor(GridCoord.y)));
            vec2 size = 3 * 1 / DataGroup.GridSize;

            vec2 uv_size = SimShader.BuildingSpriteSheet.BuildingSize;
            vec2 uv_sheet_size = SimShader.BuildingSpriteSheet.SubsheetSize;
            vec2 uv_offset = new vec2(0, uv_sheet_size.y * ((255)*SimShader.UnitType.BuildingIndex(BuildingType)));

            var building = new RectangleQuad(WorldCord, WorldCord + 2 * new vec2(size.x, -size.y), new vec2(0, uv_size.y) + uv_offset, new vec2(uv_size.x, 0) + uv_offset);
            building.SetColor(new color(1, 1, 1, .7f));
            building.Draw(GraphicsDevice);
        }

        private void DrawCircleCursor()
        {
            vec2 WorldCord = ScreenToWorldCoord(Input.CurMousePos);
            DrawMouse.Using(camvec, CameraAspect, SelectCircle);
            RectangleQuad.Draw(GraphicsDevice, WorldCord, .2f * vec2.Ones / CameraZoom);
        }

        private void DrawArrowCursor()
        {
            vec2 WorldCord = ScreenToWorldCoord(Input.CurMousePos);
            DrawMouse.Using(camvec, CameraAspect, Cursor);

            vec2 size = .02f * Cursor.UnitSize() / CameraZoom;
            RectangleQuad.Draw(GraphicsDevice, WorldCord + new vec2(size.x, -size.y), size);
        }

        vec2 ScreenToGridCoord(vec2 pos)
        {
            var world = ScreenToWorldCoord(pos);
            world.y = -world.y;

            var grid_coord = Screen * (world + vec2.Ones) / 2;

            return grid_coord;
        }

        vec2 GridToScreenCoord(vec2 pos)
        {
            pos = 2 * pos / Screen - vec2.Ones;
            pos.y = -pos.y;
            return pos;
        }

        vec2 ScreenToWorldCoord(vec2 pos)
        {
            var screen = new vec2(Screen.x, Screen.y);
            var ScreenCord = (2 * pos - screen) / screen;
            vec2 WorldCord;
            WorldCord.x = CameraAspect * ScreenCord.x / camvec.z + camvec.x;
            WorldCord.y = -ScreenCord.y / camvec.w + camvec.y;
            return WorldCord;
        }

        vec2 GetShiftedCamera(vec2 pos, vec4 prev_camvec, vec2 prev_worldcoord)
        {
            var screen = new vec2(Screen.x, Screen.y);
            var ScreenCord = (2 * pos - screen) / screen;

            vec2 shifted_cam;
            shifted_cam.x = prev_worldcoord.x - CameraAspect * ScreenCord.x / prev_camvec.z;
            shifted_cam.y = prev_worldcoord.y + ScreenCord.y / prev_camvec.w;

            return shifted_cam;
        }

        int[] Gold      = new int[] { 0, 0, 0, 0, 0 };
        int[] GoldMines = new int[] { 0, 0, 0, 0, 0 };

        void DoGoldUpdate()
        {
            for (int player = 1; player <= 4; player++)
            {
                Gold[player] += GoldMines[player];
            }
        }

        void DoGoldMineCount()
        {
            CountGoldMines.Apply(DataGroup.CurrentData, DataGroup.CurrentUnits, Output: DataGroup.Multigrid[0]);

            color count = MultigridReduce(CountReduce_4x1byte.Apply);

            GoldMines[1] = (int)(255 * count.x + .5f);
            GoldMines[2] = (int)(255 * count.y + .5f);
            GoldMines[3] = (int)(255 * count.z + .5f);
            GoldMines[4] = (int)(255 * count.w + .5f);
        }

        int[] UnitCount = new int[] { 0, 0, 0, 0, 0 };
        int SelectedCount = 0;
        
        int DoUnitCount(float player, bool only_selected)
        {
            CountUnits.Apply(DataGroup.CurrentData, DataGroup.CurrentUnits, player, only_selected, Output: DataGroup.Multigrid[0]);

            color count = MultigridReduce(CountReduce_3byte.Apply);

            int result = (int)(SimShader.unpack_coord(count.xyz) + .5f);
            return result;
        }

        Color[] CountData = new Color[1];
        color MultigridReduce(Action<Texture2D, RenderTarget2D> ReductionShader)
        {
            int n = ((int)Screen.x);
            int level = 0;
            while (n >= 2)
            {
                ReductionShader(DataGroup.Multigrid[level], DataGroup.Multigrid[level + 1]);

                n /= 2;
                level++;
            }
            GraphicsDevice.SetRenderTarget(null);

            DataGroup.Multigrid.Last().GetData(CountData);
            return (color)CountData[0];
        }

        vec2 SelectedBound_BL, SelectedBound_TR;
        void Bounds()
        {
            Bounding.Apply(DataGroup.CurrentData, Output: DataGroup.Multigrid[1]);

            int n = ((int)Screen.x) / 2;
            int level = 1;
            while (n >= 2)
            {
                _Bounding.Apply(DataGroup.Multigrid[level], Output: DataGroup.Multigrid[level + 1]);

                n /= 2;
                level++;
            }
            GraphicsDevice.SetRenderTarget(null);

            DataGroup.Multigrid.Last().GetData(CountData);
            color bound = (color)CountData[0];

            SelectedBound_TR = bound.rg;
            SelectedBound_BL = bound.ba;

            Console.WriteLine("Bounds: ({0}), ({1})", SelectedBound_BL, SelectedBound_TR);
        }

        void PathUpdate()
        {
            Pathfinding_ToOtherTeams.Apply(DataGroup.PathToOtherTeams, DataGroup.CurrentData, DataGroup.CurrentUnits, Output: DataGroup.Temp1);
            Swap(ref DataGroup.PathToOtherTeams, ref DataGroup.Temp1);

            //Pathfinding_Right.Apply(Paths_Right, Current, Output: Temp1);
            //Swap(ref Paths_Right, ref Temp1);

            //Pathfinding_Left.Apply(Paths_Left, Current, Output: Temp1);
            //Swap(ref Paths_Left, ref Temp1);

            //Pathfinding_Up.Apply(Paths_Up, Current, Output: Temp1);
            //Swap(ref Paths_Up, ref Temp1);

            //Pathfinding_Down.Apply(Paths_Down, Current, Output: Temp1);
            //Swap(ref Paths_Down, ref Temp1);
        }

        void SelectionUpdate()
        {
            vec2 WorldCord     = ScreenToWorldCoord(Input.CurMousePos);
            vec2 WorldCordPrev = ScreenToWorldCoord(Input.PrevMousePos);

            bool Deselect  = Input.LeftMousePressed && !Keys.LeftShift.Pressed() && !Keys.RightShift.Pressed()
                || CurUserMode != UserMode.Select
                || Keys.Back.Pressed() || Keys.Escape.Pressed();
            bool Selecting = Input.LeftMouseDown;

            DataDrawMouse.Using(SelectCircle_Data, SimShader.Player.One, Output: DataGroup.SelectField, Clear: Color.Transparent);

            if (Selecting)
            {
                vec2 shift = new vec2(1 / Screen.x, -1 / Screen.y);

                for (int i = 0; i <= 10; i++)
                {
                    float t = i / 10.0f;
                    var pos = t * WorldCordPrev + (1-t) * WorldCord;
                    RectangleQuad.Draw(GraphicsDevice, pos - shift, vec2.Ones * .2f / CameraZoom);
                }
            }

            var action = Input.RightMousePressed ? SimShader.UnitAction.Attacking : SimShader.UnitAction.NoChange;
            ActionSelect.Apply(DataGroup.CurrentData, DataGroup.CurrentUnits, DataGroup.SelectField, Deselect, action, Output: DataGroup.Temp1);
            Swap(ref DataGroup.Temp1, ref DataGroup.CurrentData);

            ActionSelect.Apply(DataGroup.PreviousData, DataGroup.CurrentUnits, DataGroup.SelectField, Deselect, SimShader.UnitAction.NoChange, Output: DataGroup.Temp1);
            Swap(ref DataGroup.Temp1, ref DataGroup.PreviousData);

            if (Keys.F.Pressed() || Keys.G.Pressed())
            {
                CreateUnits();
            }

            if (Input.RightMousePressed)
            {
                AttackMove();
            }
        }

        void PlaceBuilding()
        {
            CanPlaceBuilding = false;

            if (true)
            {
                vec2 GridCoord = ScreenToGridCoord(Input.CurMousePos) - new vec2(1, 1);

                int _w = 3, _h = 3;

                GraphicsDevice.Textures[0] = null;
                GraphicsDevice.Textures[1] = null;
                GraphicsDevice.Textures[2] = null;
                GraphicsDevice.Textures[3] = null;
                GraphicsDevice.SetRenderTarget(null);

                var data = DataGroup.CurrentData.GetData(GridCoord, new vec2(_w, _h));

                color clr = color.TransparentBlack;
                if (data != null)
                {
                    CanPlaceBuilding = true;
			        for (int i = 0; i < _w; i++)
			        for (int j = 0; j < _h; j++)
                    {
                        var val = data[i + j * _w];
                        bool occupied = val.R > 0;

                        CanPlace[i + j * _w] = !occupied;
                        if (occupied) CanPlaceBuilding = false;
                    }

                    if (CanPlaceBuilding && Input.LeftMousePressed)
                    {
                        try
                        {
                            Create.PlaceBuilding(DataGroup, GridCoord, BuildingType);
                            CanPlaceBuilding = false;
                        }
                        catch
                        {
                        }
                    }
                }
            }
        }

        private void CreateUnits()
        {
            float player = Keys.F.Pressed() ? SimShader.Player.One : SimShader.Player.Two;
            float team = Keys.F.Pressed() ? SimShader.Team.One : SimShader.Team.Two;

            ActionSpawn_Unit.Apply(DataGroup.CurrentUnits, DataGroup.SelectField, player, team, Output: DataGroup.Temp1);
            Swap(ref DataGroup.Temp1, ref DataGroup.CurrentUnits);
            ActionSpawn_Data.Apply(DataGroup.CurrentData, DataGroup.SelectField, Output: DataGroup.Temp1);
            Swap(ref DataGroup.Temp1, ref DataGroup.CurrentData);
        }

        private void AttackMove()
        {
            var pos = ScreenToGridCoord(Input.CurMousePos);
            vec2 shift = new vec2(1 / Screen.x, -1 / Screen.y);
            pos -= shift;

            vec2 Selected_BL = SelectedBound_BL * Screen;
            vec2 Selected_Size = (SelectedBound_TR - SelectedBound_BL) * Screen;
            if (Selected_Size.x < 1) Selected_Size.x = 1;
            if (Selected_Size.y < 1) Selected_Size.y = 1;

            float SquareWidth = (float)Math.Sqrt(SelectedCount);
            vec2 Destination_Size = new vec2(SquareWidth, SquareWidth) * 1.25f;
            vec2 Destination_BL = pos - Destination_Size / 2;

            ActionAttackSquare.Apply(DataGroup.CurrentData, DataGroup.TargetData, Destination_BL, Destination_Size, Selected_BL, Selected_Size, Output: DataGroup.Temp1);
            //ActionAttackPoint .Apply(Current, TargetData, pos, Output: Temp1);
            Swap(ref DataGroup.TargetData, ref DataGroup.Temp1);

            ActionAttack2.Apply(DataGroup.CurrentData, DataGroup.Extra, pos, Output: DataGroup.Temp1);
            Swap(ref DataGroup.Extra, ref DataGroup.Temp1);
        }

		void SimulationUpdate()
		{
            PathUpdate();

            Building_SelectCenterIfSelected_SetDirecion.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.CurrentData, ref DataGroup.Temp1);
            BuildingDiffusion_Data.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.CurrentData, ref DataGroup.Temp1);
            BuildingDiffusion_Target.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, DataGroup.TargetData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.TargetData, ref DataGroup.Temp1);

            AddCorpses.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, DataGroup.Corspes, Output: DataGroup.Temp1);
            Swap(ref DataGroup.Corspes, ref DataGroup.Temp1);

            Movement_UpdateDirection_RemoveDead.Apply(DataGroup.TargetData, DataGroup.CurrentUnits, DataGroup.Extra, DataGroup.CurrentData, DataGroup.PathToOtherTeams, Output: DataGroup.Temp1);
            //Movement_UpdateDirection.Apply(TargetData, CurData, Current, Paths_Right, Paths_Left, Paths_Up, Paths_Down, Output: Temp1);
            Swap(ref DataGroup.CurrentData, ref DataGroup.Temp1);

            Movement_Phase1.Apply(DataGroup.CurrentData, Output: DataGroup.Temp1);
            Movement_Phase2.Apply(DataGroup.CurrentData, DataGroup.Temp1, Output: DataGroup.Temp2);

            Swap(ref DataGroup.CurrentData, ref DataGroup.PreviousData);
            Swap(ref DataGroup.Temp2, ref DataGroup.CurrentData);

            Movement_Convect.Apply(DataGroup.TargetData, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.TargetData, ref DataGroup.Temp1);
            Movement_Convect.Apply(DataGroup.Extra, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.Extra, ref DataGroup.Temp1);
            Movement_Convect.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.CurrentUnits, ref DataGroup.Temp1);
            Swap(ref DataGroup.PreviousUnits, ref DataGroup.Temp1);

            CheckForAttacking.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, DataGroup.RandomField, Output: DataGroup.Temp1);
            Swap(ref DataGroup.CurrentUnits, ref DataGroup.Temp1);

            SpawnUnits.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, DataGroup.PreviousData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.CurrentData, ref DataGroup.Temp1);
            SetSpawn_Unit.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.CurrentUnits, ref DataGroup.Temp1);
            SetSpawn_Target.Apply(DataGroup.TargetData, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.TargetData, ref DataGroup.Temp1);
            SetSpawn_Data.Apply(DataGroup.CurrentUnits, DataGroup.CurrentData, Output: DataGroup.Temp1);
            Swap(ref DataGroup.CurrentData, ref DataGroup.Temp1);

            UpdateRandomField.Apply(DataGroup.RandomField, Output: DataGroup.Temp1);
            Swap(ref DataGroup.RandomField, ref DataGroup.Temp1);
		}
	}
}
