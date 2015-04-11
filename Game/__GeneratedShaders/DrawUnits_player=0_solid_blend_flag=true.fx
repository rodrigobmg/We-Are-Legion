// This file was auto-generated by FragSharp. It will be regenerated on the next compilation.
// Manual changes made will not persist and may cause incorrect behavior between compilations.

#define PIXEL_SHADER ps_3_0
#define VERTEX_SHADER vs_3_0

// Vertex shader data structure definition
struct VertexToPixel
{
    float4 Position   : POSITION0;
    float4 Color      : COLOR0;
    float2 TexCoords  : TEXCOORD0;
    float2 Position2D : TEXCOORD2;
};

// Fragment shader data structure definition
struct PixelToFrame
{
    float4 Color      : COLOR0;
};

// The following are variables used by the vertex shader (vertex parameters).
float4 vs_param_cameraPos;
float vs_param_cameraAspect;

// The following are variables used by the fragment shader (fragment parameters).
// Texture Sampler for fs_param_CurrentData, using register location 1
float2 fs_param_CurrentData_size;
float2 fs_param_CurrentData_dxdy;

Texture fs_param_CurrentData_Texture;
sampler fs_param_CurrentData : register(s1) = sampler_state
{
    texture   = <fs_param_CurrentData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_PreviousData, using register location 2
float2 fs_param_PreviousData_size;
float2 fs_param_PreviousData_dxdy;

Texture fs_param_PreviousData_Texture;
sampler fs_param_PreviousData : register(s2) = sampler_state
{
    texture   = <fs_param_PreviousData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_CurrentUnits, using register location 3
float2 fs_param_CurrentUnits_size;
float2 fs_param_CurrentUnits_dxdy;

Texture fs_param_CurrentUnits_Texture;
sampler fs_param_CurrentUnits : register(s3) = sampler_state
{
    texture   = <fs_param_CurrentUnits_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_PreviousUnits, using register location 4
float2 fs_param_PreviousUnits_size;
float2 fs_param_PreviousUnits_dxdy;

Texture fs_param_PreviousUnits_Texture;
sampler fs_param_PreviousUnits : register(s4) = sampler_state
{
    texture   = <fs_param_PreviousUnits_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_UnitTexture, using register location 5
float2 fs_param_UnitTexture_size;
float2 fs_param_UnitTexture_dxdy;

Texture fs_param_UnitTexture_Texture;
sampler fs_param_UnitTexture : register(s5) = sampler_state
{
    texture   = <fs_param_UnitTexture_Texture>;
    MipFilter = Linear;
    MagFilter = Linear;
    MinFilter = Linear;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

// Texture Sampler for fs_param_ShadowTexture, using register location 6
float2 fs_param_ShadowTexture_size;
float2 fs_param_ShadowTexture_dxdy;

Texture fs_param_ShadowTexture_Texture;
sampler fs_param_ShadowTexture : register(s6) = sampler_state
{
    texture   = <fs_param_ShadowTexture_Texture>;
    MipFilter = Linear;
    MagFilter = Linear;
    MinFilter = Linear;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

float fs_param_s;

float fs_param_t;

float fs_param_selection_blend;

float fs_param_selection_size;

float fs_param_solid_blend;

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.
// Texture Sampler for fs_param_FarColor, using register location 7
float2 fs_param_FarColor_size;
float2 fs_param_FarColor_dxdy;

Texture fs_param_FarColor_Texture;
sampler fs_param_FarColor : register(s7) = sampler_state
{
    texture   = <fs_param_FarColor_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following methods are included because they are referenced by the fragment shader.
float2 Game__SimShader__get_subcell_pos__FragSharpFramework_VertexOut__FragSharpFramework_vec2__FragSharpFramework_vec2(VertexToPixel vertex, float2 grid_size, float2 grid_shift)
{
    float2 coords = vertex.TexCoords * grid_size + grid_shift;
    float i = floor(coords.x);
    float j = floor(coords.y);
    return coords - float2(i, j);
}

bool Game__SimShader__IsUnit__float(float type)
{
    return type >= 0.003921569 - .001 && type < 0.02352941 - .001;
}

bool Game__SimShader__IsUnit__Game_unit(float4 u)
{
    return Game__SimShader__IsUnit__float(u.r);
}

bool Game__SimShader__Something__Game_data(float4 u)
{
    return u.r > 0 + .001;
}

bool Game__SimShader__fake_selected__Game_data(float4 u)
{
    float val = u.b;
    return 0.1254902 <= val + .001 && val < 0.5019608 - .001;
}

float4 Game__SelectedUnitColor__Get__float(VertexToPixel psin, float player)
{
    if (abs(player - 0.003921569) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 1 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.007843138) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 2 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01176471) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 3 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01568628) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 4 + (int)player) * fs_param_FarColor_dxdy);
    }
    return float4(0.0, 0.0, 0.0, 0.0);
}

float4 Game__DrawUnits__ShadowSprite__float__Game_data__Game_unit__FragSharpFramework_vec2__FragSharpFramework_TextureSampler__float__float__bool__float(VertexToPixel psin, float player, float4 d, float4 u, float2 pos, sampler Texture, float2 Texture_size, float2 Texture_dxdy, float selection_blend, float selection_size, bool solid_blend_flag, float solid_blend)
{
    if (pos.x > 1 + .001 || pos.y > 1 + .001 || pos.x < 0 - .001 || pos.y < 0 - .001)
    {
        return float4(0.0, 0.0, 0.0, 0.0);
    }
    bool draw_selected = abs(u.g - player) < .001 && Game__SimShader__fake_selected__Game_data(d);
    float4 clr = tex2D(Texture, pos);
    if (draw_selected)
    {
        if (clr.a > 0 + .001)
        {
            float a = clr.a;
            clr = Game__SelectedUnitColor__Get__float(psin, u.g);
            clr.a = a;
        }
    }
    return clr;
}

bool Game__SimShader__IsValid__float(float direction)
{
    return direction > 0 + .001;
}

float FragSharpFramework__FragSharpStd__fint_round__float(float v)
{
    return floor(255 * v + 0.5) * 0.003921569;
}

float Game__SimShader__prior_direction__Game_data(float4 u)
{
    float val = u.b;
    val = fmod(val, 0.1254902);
    val = FragSharpFramework__FragSharpStd__fint_round__float(val);
    return val;
}

float2 Game__SimShader__direction_to_vec__float(float direction)
{
    float angle = (direction * 255 - 1) * (3.141593 / 2.0);
    return Game__SimShader__IsValid__float(direction) ? float2(cos(angle), sin(angle)) : float2(0, 0);
}

float2 Game__SimShader__get_subcell_pos__FragSharpFramework_VertexOut__FragSharpFramework_vec2(VertexToPixel vertex, float2 grid_size)
{
    float2 coords = vertex.TexCoords * grid_size;
    float i = floor(coords.x);
    float j = floor(coords.y);
    return coords - float2(i, j);
}

float FragSharpFramework__FragSharpStd__Float__float(float v)
{
    return floor(255 * v + 0.5);
}

float Game__Dir__Num__Game_data(float4 d)
{
    return FragSharpFramework__FragSharpStd__Float__float(d.r) - 1;
}

float Game__Player__Num__Game_unit(float4 u)
{
    return FragSharpFramework__FragSharpStd__Float__float(u.g) - 1;
}

float Game__UnitType__UnitIndex__Game_unit(float4 u)
{
    return FragSharpFramework__FragSharpStd__Float__float(u.r - 0.003921569);
}

float4 Game__UnitColor__Get__float(VertexToPixel psin, float player)
{
    if (abs(player - 0.003921569) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 1 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.007843138) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 2 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01176471) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 3 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01568628) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 4 + (int)player) * fs_param_FarColor_dxdy);
    }
    return float4(0.0, 0.0, 0.0, 0.0);
}

float4 Game__DrawUnits__SolidColor__float__Game_data__Game_unit(VertexToPixel psin, float player, float4 data, float4 unit)
{
    return abs(unit.g - player) < .001 && Game__SimShader__fake_selected__Game_data(data) ? Game__SelectedUnitColor__Get__float(psin, unit.g) : Game__UnitColor__Get__float(psin, unit.g);
}

float4 Game__DrawUnits__Sprite__float__Game_data__Game_unit__FragSharpFramework_vec2__float__FragSharpFramework_TextureSampler__float__float__bool__float(VertexToPixel psin, float player, float4 d, float4 u, float2 pos, float frame, sampler Texture, float2 Texture_size, float2 Texture_dxdy, float selection_blend, float selection_size, bool solid_blend_flag, float solid_blend)
{
    if (pos.x > 1 + .001 || pos.y > 1 + .001 || pos.x < 0 - .001 || pos.y < 0 - .001)
    {
        return float4(0.0, 0.0, 0.0, 0.0);
    }
    bool draw_selected = abs(u.g - player) < .001 && Game__SimShader__fake_selected__Game_data(d) && pos.y > selection_size + .001;
    pos.x += floor(frame);
    pos.y += Game__Dir__Num__Game_data(d) + 4 * Game__Player__Num__Game_unit(u) + 4 * 4 * Game__UnitType__UnitIndex__Game_unit(u);
    pos *= float2(1.0 / 32, 1.0 / 96);
    float4 clr = tex2D(Texture, pos);
    if (solid_blend_flag)
    {
        clr = solid_blend * clr + (1 - solid_blend) * Game__DrawUnits__SolidColor__float__Game_data__Game_unit(psin, player, d, u);
    }
    return clr;
}

// Compiled vertex shader
VertexToPixel StandardVertexShader(float2 inPos : POSITION0, float2 inTexCoords : TEXCOORD0, float4 inColor : COLOR0)
{
    VertexToPixel Output = (VertexToPixel)0;
    Output.Position.w = 1;
    Output.Position.x = (inPos.x - vs_param_cameraPos.x) / vs_param_cameraAspect * vs_param_cameraPos.z;
    Output.Position.y = (inPos.y - vs_param_cameraPos.y) * vs_param_cameraPos.w;
    Output.TexCoords = inTexCoords;
    Output.Color = inColor;
    return Output;
}

// Compiled fragment shader
PixelToFrame FragmentShader(VertexToPixel psin)
{
    PixelToFrame __FinalOutput = (PixelToFrame)0;
    float4 shadow = float4(0.0, 0.0, 0.0, 0.0);
    float2 shadow_subcell_pos = Game__SimShader__get_subcell_pos__FragSharpFramework_VertexOut__FragSharpFramework_vec2__FragSharpFramework_vec2(psin, fs_param_CurrentData_size, float2(0.0, -(0.5)));
    float2 shadow_here = float2(0, 0) + float2(0, -(0.5));
    float4 shadow_cur = tex2D(fs_param_CurrentData, psin.TexCoords + (shadow_here) * fs_param_CurrentData_dxdy), shadow_pre = tex2D(fs_param_PreviousData, psin.TexCoords + (shadow_here) * fs_param_PreviousData_dxdy);
    float4 shadow_cur_unit = tex2D(fs_param_CurrentUnits, psin.TexCoords + (shadow_here) * fs_param_CurrentUnits_dxdy), shadow_pre_unit = tex2D(fs_param_PreviousUnits, psin.TexCoords + (shadow_here) * fs_param_PreviousUnits_dxdy);
    if (Game__SimShader__IsUnit__Game_unit(shadow_cur_unit) || Game__SimShader__IsUnit__Game_unit(shadow_pre_unit))
    {
        if (Game__SimShader__Something__Game_data(shadow_cur) && abs(shadow_cur.g - 0.003921569) < .001)
        {
            if (fs_param_s > 0.5 + .001)
            {
                shadow_pre = shadow_cur;
            }
            shadow += Game__DrawUnits__ShadowSprite__float__Game_data__Game_unit__FragSharpFramework_vec2__FragSharpFramework_TextureSampler__float__float__bool__float(psin, 0, shadow_pre, shadow_pre_unit, shadow_subcell_pos, fs_param_ShadowTexture, fs_param_ShadowTexture_size, fs_param_ShadowTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
        }
        else
        {
            if (Game__SimShader__IsValid__float(shadow_cur.r))
            {
                float prior_dir = Game__SimShader__prior_direction__Game_data(shadow_cur);
                shadow_cur.r = prior_dir;
                float2 offset = (1 - fs_param_s) * Game__SimShader__direction_to_vec__float(prior_dir);
                shadow += Game__DrawUnits__ShadowSprite__float__Game_data__Game_unit__FragSharpFramework_vec2__FragSharpFramework_TextureSampler__float__float__bool__float(psin, 0, shadow_cur, shadow_cur_unit, shadow_subcell_pos + offset, fs_param_ShadowTexture, fs_param_ShadowTexture_size, fs_param_ShadowTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
            }
            if (Game__SimShader__IsValid__float(shadow_pre.r) && shadow.a < 0.025 - .001)
            {
                float2 offset = -(fs_param_s) * Game__SimShader__direction_to_vec__float(shadow_pre.r);
                shadow += Game__DrawUnits__ShadowSprite__float__Game_data__Game_unit__FragSharpFramework_vec2__FragSharpFramework_TextureSampler__float__float__bool__float(psin, 0, shadow_pre, shadow_pre_unit, shadow_subcell_pos + offset, fs_param_ShadowTexture, fs_param_ShadowTexture_size, fs_param_ShadowTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
            }
        }
    }
    float4 output = float4(0.0, 0.0, 0.0, 0.0);
    float2 subcell_pos = Game__SimShader__get_subcell_pos__FragSharpFramework_VertexOut__FragSharpFramework_vec2(psin, fs_param_CurrentData_size);
    float4 cur = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(0, 0)) * fs_param_CurrentData_dxdy), pre = tex2D(fs_param_PreviousData, psin.TexCoords + (float2(0, 0)) * fs_param_PreviousData_dxdy);
    float4 cur_unit = tex2D(fs_param_CurrentUnits, psin.TexCoords + (float2(0, 0)) * fs_param_CurrentUnits_dxdy), pre_unit = tex2D(fs_param_PreviousUnits, psin.TexCoords + (float2(0, 0)) * fs_param_PreviousUnits_dxdy);
    if (!(Game__SimShader__IsUnit__Game_unit(cur_unit)) && !(Game__SimShader__IsUnit__Game_unit(pre_unit)))
    {
        __FinalOutput.Color = shadow;
        return __FinalOutput;
    }
    if (Game__SimShader__Something__Game_data(cur) && abs(cur.g - 0.003921569) < .001)
    {
        if (fs_param_s > 0.5 + .001)
        {
            pre = cur;
        }
        float _s = (abs(cur_unit.a - 0.0) < .001 ? fs_param_t : fs_param_s);
        if (abs(cur_unit.a - 0.2588235) < .001)
        {
            cur_unit.a = 0.07058824;
            _s = 1.0 - _s;
        }
        float frame = _s * 6 + FragSharpFramework__FragSharpStd__Float__float(cur_unit.a);
        output += Game__DrawUnits__Sprite__float__Game_data__Game_unit__FragSharpFramework_vec2__float__FragSharpFramework_TextureSampler__float__float__bool__float(psin, 0, pre, pre_unit, subcell_pos, frame, fs_param_UnitTexture, fs_param_UnitTexture_size, fs_param_UnitTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
    }
    else
    {
        float frame = fs_param_s * 6 + FragSharpFramework__FragSharpStd__Float__float(0.02352941);
        if (Game__SimShader__IsValid__float(cur.r))
        {
            float prior_dir = Game__SimShader__prior_direction__Game_data(cur);
            cur.r = prior_dir;
            float2 offset = (1 - fs_param_s) * Game__SimShader__direction_to_vec__float(prior_dir);
            output += Game__DrawUnits__Sprite__float__Game_data__Game_unit__FragSharpFramework_vec2__float__FragSharpFramework_TextureSampler__float__float__bool__float(psin, 0, cur, cur_unit, subcell_pos + offset, frame, fs_param_UnitTexture, fs_param_UnitTexture_size, fs_param_UnitTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
        }
        if (Game__SimShader__IsValid__float(pre.r) && output.a < 0.025 - .001)
        {
            float2 offset = -(fs_param_s) * Game__SimShader__direction_to_vec__float(pre.r);
            output += Game__DrawUnits__Sprite__float__Game_data__Game_unit__FragSharpFramework_vec2__float__FragSharpFramework_TextureSampler__float__float__bool__float(psin, 0, pre, pre_unit, subcell_pos + offset, frame, fs_param_UnitTexture, fs_param_UnitTexture_size, fs_param_UnitTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
        }
    }
    if (output.a < 0.025 - .001)
    {
        output = shadow;
    }
    __FinalOutput.Color = output;
    return __FinalOutput;
}

// Shader compilation
technique Simplest
{
    pass Pass0
    {
        VertexShader = compile VERTEX_SHADER StandardVertexShader();
        PixelShader = compile PIXEL_SHADER FragmentShader();
    }
}