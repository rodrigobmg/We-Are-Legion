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

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
bool Terracotta__SimShader__Something__Terracotta_data(float4 u)
{
    return u.r > 0 + .001;
}

bool Terracotta__SimShader__selected__Terracotta_data(float4 u)
{
    float val = u.b;
    return val >= 0.3764706 - .001;
}

bool Terracotta__SimShader__SomethingSelected__Terracotta_data(float4 u)
{
    return Terracotta__SimShader__Something__Terracotta_data(u) && Terracotta__SimShader__selected__Terracotta_data(u);
}

float2 Terracotta__SimShader__pack_val_2byte__float(float x)
{
    float2 packed = float2(0, 0);
    packed.x = floor(x / 256.0);
    packed.y = x - packed.x * 256.0;
    return packed / 255.0;
}

float4 Terracotta__SimShader__pack_vec2__FragSharpFramework_vec2(float2 v)
{
    float2 packed_x = Terracotta__SimShader__pack_val_2byte__float(v.x);
    float2 packed_y = Terracotta__SimShader__pack_val_2byte__float(v.y);
    return float4(packed_x.x, packed_x.y, packed_y.x, packed_y.y);
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
    float2 uv = psin.TexCoords * fs_param_Data_size;
    __FinalOutput.Color = Terracotta__SimShader__SomethingSelected__Terracotta_data(tex2D(fs_param_Data, psin.TexCoords + (float2(0, 0)) * fs_param_Data_dxdy)) ? Terracotta__SimShader__pack_vec2__FragSharpFramework_vec2(uv) : float4(0, 0, 0, 0);
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