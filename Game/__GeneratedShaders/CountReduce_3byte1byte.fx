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
// Texture Sampler for fs_param_PreviousLevel, using register location 1
float2 fs_param_PreviousLevel_size;
float2 fs_param_PreviousLevel_dxdy;

Texture fs_param_PreviousLevel_Texture;
sampler fs_param_PreviousLevel : register(s1) = sampler_state
{
    texture   = <fs_param_PreviousLevel_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
float Game__SimShader__unpack_val__vec3(float3 packed)
{
    float coord = 0;
    coord = (255 * 255 * packed.x + 255 * packed.y + packed.z) * 255;
    return coord;
}

float3 Game__SimShader__pack_coord_3byte__Single(float x)
{
    float3 packed = float3(0, 0, 0);
    packed.x = floor(x / (255.0 * 255.0));
    packed.y = floor((x - packed.x * (255.0 * 255.0)) / 255.0);
    packed.z = x - packed.x * (255.0 * 255.0) - packed.y * 255.0;
    return packed / 255.0;
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
    float4 TL = tex2D(fs_param_PreviousLevel, psin.TexCoords + (-float2(0.25,0.25) + float2(0, 0)) * fs_param_PreviousLevel_dxdy), TR = tex2D(fs_param_PreviousLevel, psin.TexCoords + (-float2(0.25,0.25) + float2(1, 0)) * fs_param_PreviousLevel_dxdy), BL = tex2D(fs_param_PreviousLevel, psin.TexCoords + (-float2(0.25,0.25) + float2(0, 1)) * fs_param_PreviousLevel_dxdy), BR = tex2D(fs_param_PreviousLevel, psin.TexCoords + (-float2(0.25,0.25) + float2(1, 1)) * fs_param_PreviousLevel_dxdy);
    float count_3byte = Game__SimShader__unpack_val__vec3(TL.xyz) + Game__SimShader__unpack_val__vec3(TR.xyz) + Game__SimShader__unpack_val__vec3(BL.xyz) + Game__SimShader__unpack_val__vec3(BR.xyz);
    float count_1byte = TL.w + TR.w + BL.w + BR.w;
    float4 output = float4(0, 0, 0, 0);
    output.xyz = Game__SimShader__pack_coord_3byte__Single(count_3byte);
    output.w = count_1byte;
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