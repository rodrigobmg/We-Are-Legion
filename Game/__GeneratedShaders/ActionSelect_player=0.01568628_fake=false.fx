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

// The following are variables used by the fragment shader (fragment parameters).
// Texture Sampler for fs_param_Data, using register location 1
float2 fs_param_Data_size;
float2 fs_param_Data_dxdy;

Texture fs_param_Data_Texture;
sampler fs_param_Data : register(s1) = sampler_state
{
    texture   = <fs_param_Data_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Unit, using register location 2
float2 fs_param_Unit_size;
float2 fs_param_Unit_dxdy;

Texture fs_param_Unit_Texture;
sampler fs_param_Unit : register(s2) = sampler_state
{
    texture   = <fs_param_Unit_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Select, using register location 3
float2 fs_param_Select_size;
float2 fs_param_Select_dxdy;

Texture fs_param_Select_Texture;
sampler fs_param_Select : register(s3) = sampler_state
{
    texture   = <fs_param_Select_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

bool fs_param_deselect;


// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
bool Game__SimShader__BlockingTileHere__unit(float4 u)
{
    return u.r >= 0.07843138 - .001;
}

bool Game__SimShader__selected__data(float4 u)
{
    float val = u.b;
    return val >= 0.3764706 - .001;
}

float FragSharpFramework__FragSharpStd__fint_round__Single(float v)
{
    return floor(255 * v + 0.5) * 0.003921569;
}

float Game__SimShader__prior_direction__data(float4 u)
{
    float val = u.b;
    val = fmod(val, 0.1254902);
    val = FragSharpFramework__FragSharpStd__fint_round__Single(val);
    return val;
}

void Game__SimShader__set_selected_fake__data__Boolean(inout float4 u, bool fake_selected)
{
    bool is_selected = Game__SimShader__selected__data(u);
    float prior_dir = Game__SimShader__prior_direction__data(u);
    float select_state= (float)0;
    if (fake_selected)
    {
        select_state = is_selected ? 0.3764706 : 0.2509804;
    }
    else
    {
        select_state = is_selected ? 0.627451 : 0.0;
    }
    u.b = prior_dir + select_state;
}

float Game__SimShader__select_state__data(float4 u)
{
    return u.b - Game__SimShader__prior_direction__data(u);
}

bool Game__SimShader__fake_selected__data(float4 u)
{
    float val = u.b;
    return 0.1254902 <= val + .001 && val < 0.5019608 - .001;
}

void Game__SimShader__set_selected__data__Boolean(inout float4 u, bool selected)
{
    float state = Game__SimShader__select_state__data(u);
    if (selected)
    {
        state = Game__SimShader__fake_selected__data(u) ? 0.3764706 : 0.627451;
    }
    else
    {
        state = Game__SimShader__fake_selected__data(u) ? 0.2509804 : 0.0;
    }
    u.b = Game__SimShader__prior_direction__data(u) + state;
}

// Compiled vertex shader
VertexToPixel StandardVertexShader(float2 inPos : POSITION0, float2 inTexCoords : TEXCOORD0, float4 inColor : COLOR0)
{
    VertexToPixel Output = (VertexToPixel)0;
    Output.Position.w = 1;
    Output.Position.xy = inPos.xy;
    Output.TexCoords = inTexCoords;
    return Output;
}

// Compiled fragment shader
PixelToFrame FragmentShader(VertexToPixel psin)
{
    PixelToFrame __FinalOutput = (PixelToFrame)0;
    float4 unit_here = tex2D(fs_param_Unit, psin.TexCoords + (float2(0, 0)) * fs_param_Unit_dxdy);
    float4 data_here = tex2D(fs_param_Data, psin.TexCoords + (float2(0, 0)) * fs_param_Data_dxdy);
    if (abs(unit_here.g - 0.01568628) > .001)
    {
        __FinalOutput.Color = data_here;
        return __FinalOutput;
    }
    float4 select = tex2D(fs_param_Select, psin.TexCoords + (float2(0, 0)) * fs_param_Select_dxdy);
    if (select.r > 0 + .001 && (abs(select.g - 0.0) < .001 || abs(unit_here.g - select.g) < .001) && !(Game__SimShader__BlockingTileHere__unit(unit_here)))
    {
        if (false)
        {
            Game__SimShader__set_selected_fake__data__Boolean(data_here, true);
        }
        else
        {
            Game__SimShader__set_selected__data__Boolean(data_here, true);
        }
    }
    else
    {
        if (fs_param_deselect)
        {
            if (false)
            {
                Game__SimShader__set_selected_fake__data__Boolean(data_here, false);
            }
            else
            {
                Game__SimShader__set_selected__data__Boolean(data_here, false);
            }
        }
    }
    __FinalOutput.Color = data_here;
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