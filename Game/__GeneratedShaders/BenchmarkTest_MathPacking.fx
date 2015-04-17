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
// Texture Sampler for fs_param_s, using register location 1
float2 fs_param_s_size;
float2 fs_param_s_dxdy;

Texture fs_param_s_Texture;
sampler fs_param_s : register(s1) = sampler_state
{
    texture   = <fs_param_s_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
float Game__BenchmarkTest_MathPacking__MathPacking__Single(float c)
{
    float x1 = floor(c / 4.0);
    float x2 = c - 3.2 * x1;
    return 4 * (x1 + 1) + x2;
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
    float4 output = float4(0, 0, 0, 0);
    float4 right = tex2D(fs_param_s, psin.TexCoords + (float2(1, 0)) * fs_param_s_dxdy), up = tex2D(fs_param_s, psin.TexCoords + (float2(0, 1)) * fs_param_s_dxdy), left = tex2D(fs_param_s, psin.TexCoords + (float2(-(1), 0)) * fs_param_s_dxdy), down = tex2D(fs_param_s, psin.TexCoords + (float2(0, -(1))) * fs_param_s_dxdy);
    output.r = Game__BenchmarkTest_MathPacking__MathPacking__Single(right.r) + Game__BenchmarkTest_MathPacking__MathPacking__Single(right.g) + Game__BenchmarkTest_MathPacking__MathPacking__Single(right.b) + Game__BenchmarkTest_MathPacking__MathPacking__Single(right.a);
    output.g = Game__BenchmarkTest_MathPacking__MathPacking__Single(left.r) + Game__BenchmarkTest_MathPacking__MathPacking__Single(left.g) + Game__BenchmarkTest_MathPacking__MathPacking__Single(left.b) + Game__BenchmarkTest_MathPacking__MathPacking__Single(left.a);
    output.b = Game__BenchmarkTest_MathPacking__MathPacking__Single(up.r) + Game__BenchmarkTest_MathPacking__MathPacking__Single(up.g) + Game__BenchmarkTest_MathPacking__MathPacking__Single(up.b) + Game__BenchmarkTest_MathPacking__MathPacking__Single(up.a);
    output.a = Game__BenchmarkTest_MathPacking__MathPacking__Single(down.r) + Game__BenchmarkTest_MathPacking__MathPacking__Single(down.g) + Game__BenchmarkTest_MathPacking__MathPacking__Single(down.b) + Game__BenchmarkTest_MathPacking__MathPacking__Single(down.a);
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