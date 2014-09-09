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
// Texture Sampler for fs_param_BuildingDistancess, using register location 1
float2 fs_param_BuildingDistancess_size;
float2 fs_param_BuildingDistancess_dxdy;

Texture fs_param_BuildingDistancess_Texture;
sampler fs_param_BuildingDistancess : register(s1) = sampler_state
{
    texture   = <fs_param_BuildingDistancess_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

float fs_param_blend;

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.
// Texture Sampler for fs_param_FarColor, using register location 2
float2 fs_param_FarColor_size;
float2 fs_param_FarColor_dxdy;

Texture fs_param_FarColor_Texture;
sampler fs_param_FarColor : register(s2) = sampler_state
{
    texture   = <fs_param_FarColor_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following methods are included because they are referenced by the fragment shader.
float2 GpuSim__SimShader__get_subcell_pos(VertexToPixel vertex, float2 grid_size)
{
    float2 coords = vertex.TexCoords * grid_size;
    float i = floor(coords.x);
    float j = floor(coords.y);
    return coords - float2(i, j);
}

float4 GpuSim__BuildingMarkerColors__Get(VertexToPixel psin, float player)
{
    if (abs(player - 0.003921569) < .001)
    {
        return tex2D(fs_param_FarColor, float2(3+.5,.5+ 1 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.007843138) < .001)
    {
        return tex2D(fs_param_FarColor, float2(3+.5,.5+ 2 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01176471) < .001)
    {
        return tex2D(fs_param_FarColor, float2(3+.5,.5+ 3 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01568628) < .001)
    {
        return tex2D(fs_param_FarColor, float2(3+.5,.5+ 4 + (int)player) * fs_param_FarColor_dxdy);
    }
    return float4(0.0, 0.0, 0.0, 0.0);
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
    float4 info = tex2D(fs_param_BuildingDistancess, psin.TexCoords + (float2(0, 0)) * fs_param_BuildingDistancess_dxdy);
    if (info.a > 0.05882353 + .001)
    {
        __FinalOutput.Color = float4(0.0, 0.0, 0.0, 0.0);
        return __FinalOutput;
    }
    float2 subcell_pos = GpuSim__SimShader__get_subcell_pos(psin, fs_param_BuildingDistancess_size);
    float2 v = 255 * (info.rg - float2(0.1568628, 0.1568628)) - (subcell_pos - float2(0.5, 0.5));
    if (length(v) < 5.5 - .001)
    {
        float4 clr = GpuSim__BuildingMarkerColors__Get(psin, info.b);
        __FinalOutput.Color = clr * fs_param_blend;
        return __FinalOutput;
    }
    __FinalOutput.Color = float4(0.0, 0.0, 0.0, 0.0);
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