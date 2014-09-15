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

bool fs_param_Deselect;

float fs_param_action;

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
bool Terracotta__SimShader__BlockingTileHere(float4 u)
{
    return u.r >= 0.07843138 - .001;
}

float FragSharpFramework__FragSharpStd__fint_round(float v)
{
    return floor(255 * v + 0.5) * 0.003921569;
}

float Terracotta__SimShader__prior_direction(float4 u)
{
    float val = u.b;
    if (val >= 0.5019608 - .001)
    {
        val -= 0.5019608;
    }
    val = FragSharpFramework__FragSharpStd__fint_round(val);
    return val;
}

void Terracotta__SimShader__set_selected(inout float4 u, bool selected)
{
    u.b = Terracotta__SimShader__prior_direction(u) + (selected ? 0.5019608 : 0.0);
}

bool Terracotta__SimShader__Something(float4 u)
{
    return u.r > 0 + .001;
}

bool Terracotta__SimShader__IsUnit(float4 u)
{
    return abs(u.r - 0.003921569) < .001;
}

bool Terracotta__SimShader__selected(float4 u)
{
    float val = u.b;
    return val >= 0.5019608 - .001;
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
    float4 data_here = tex2D(fs_param_Data, psin.TexCoords + (float2(0, 0)) * fs_param_Data_dxdy);
    float4 unit_here = tex2D(fs_param_Unit, psin.TexCoords + (float2(0, 0)) * fs_param_Unit_dxdy);
    float4 select = tex2D(fs_param_Select, psin.TexCoords + (float2(0, 0)) * fs_param_Select_dxdy);
    if (select.r > 0 + .001 && (abs(select.g - 0.0) < .001 || abs(unit_here.g - select.g) < .001) && !(Terracotta__SimShader__BlockingTileHere(unit_here)))
    {
        Terracotta__SimShader__set_selected(data_here, true);
    }
    else
    {
        if (fs_param_Deselect)
        {
            Terracotta__SimShader__set_selected(data_here, false);
        }
    }
    if (Terracotta__SimShader__Something(data_here) && Terracotta__SimShader__IsUnit(unit_here) && Terracotta__SimShader__selected(data_here) && fs_param_action < 0.04705882 - .001)
    {
        data_here.a = fs_param_action;
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