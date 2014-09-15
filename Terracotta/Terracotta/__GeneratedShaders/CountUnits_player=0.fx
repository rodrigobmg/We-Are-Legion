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

// Texture Sampler for fs_param_Units, using register location 2
float2 fs_param_Units_size;
float2 fs_param_Units_dxdy;

Texture fs_param_Units_Texture;
sampler fs_param_Units : register(s2) = sampler_state
{
    texture   = <fs_param_Units_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

bool fs_param_only_selected;

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
bool Terracotta__SimShader__Something(float4 u)
{
    return u.r > 0 + .001;
}

bool Terracotta__SimShader__selected(float4 u)
{
    float val = u.b;
    return val >= 0.5019608 - .001;
}

bool Terracotta__SimShader__IsUnit(float4 u)
{
    return abs(u.r - 0.003921569) < .001;
}

float3 Terracotta__SimShader__pack_coord_3byte(float x)
{
    float3 packed = float3(0, 0, 0);
    packed.x = floor(x / (255.0 * 255.0));
    packed.y = floor((x - packed.x * (255.0 * 255.0)) / 255.0);
    packed.z = x - packed.x * (255.0 * 255.0) - packed.y * 255.0;
    return packed / 255.0;
}

bool Terracotta__SimShader__IsCenter(float4 b)
{
    return abs(b.g - 0.003921569) < .001 && abs(b.a - 0.003921569) < .001;
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
    float4 output = float4(0, 0, 0, 0);
    if (Terracotta__SimShader__Something(data_here))
    {
        float4 unit_here = tex2D(fs_param_Units, psin.TexCoords + (float2(0, 0)) * fs_param_Units_dxdy);
        bool valid = (abs(0 - 0.0) < .001 || abs(unit_here.g - 0) < .001) && (!(fs_param_only_selected) || Terracotta__SimShader__selected(data_here));
        if (Terracotta__SimShader__IsUnit(unit_here) && valid)
        {
            output.xyz = Terracotta__SimShader__pack_coord_3byte(1);
        }
        if (abs(unit_here.r - 0.007843138) < .001 && Terracotta__SimShader__IsCenter(data_here) && valid)
        {
            output.w = 0.003921569;
        }
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