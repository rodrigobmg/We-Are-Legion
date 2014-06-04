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
// Texture Sampler for fs_param_Unit, using register location 1
float2 fs_param_Unit_size;
float2 fs_param_Unit_dxdy;

Texture fs_param_Unit_Texture;
sampler fs_param_Unit : register(s1) = sampler_state
{
    texture   = <fs_param_Unit_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Building, using register location 2
float2 fs_param_Building_size;
float2 fs_param_Building_dxdy;

Texture fs_param_Building_Texture;
sampler fs_param_Building : register(s2) = sampler_state
{
    texture   = <fs_param_Building_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following methods are included because they are referenced by the fragment shader.
bool GpuSim__SimShader__Something(float4 u)
{
    return u.r > 0 + .001;
}

bool GpuSim__SimShader__IsBuilding(float4 u)
{
    return u.r >= 0.007843138 - .001;
}

bool GpuSim__SimShader__IsCenter(float4 b)
{
    return abs(b.g - 0.003921569) < .001 && abs(b.a - 0.003921569) < .001;
}

bool GpuSim__SimShader__selected(float4 u)
{
    float val = u.b;
    return val >= 0.03137255 - .001;
}

float GpuSim__SimShader__prior_direction(float4 u)
{
    float val = u.b;
    if (val >= 0.03137255 - .001)
    {
        val -= 0.03137255;
    }
    return val;
}

void GpuSim__SimShader__set_selected(inout float4 u, bool selected)
{
    u.b = GpuSim__SimShader__prior_direction(u) + (selected ? 0.03137255 : 0.0);
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
    float4 building_here = tex2D(fs_param_Building, psin.TexCoords + (float2(0, 0)) * fs_param_Building_dxdy);
    float4 unit_here = tex2D(fs_param_Unit, psin.TexCoords + (float2(0, 0)) * fs_param_Unit_dxdy);
    if (GpuSim__SimShader__Something(building_here) && GpuSim__SimShader__IsBuilding(unit_here) && GpuSim__SimShader__IsCenter(building_here) && !(GpuSim__SimShader__selected(building_here)))
    {
        bool is_selected = GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(1, 0)) * fs_param_Building_dxdy)) || GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(-(1), 0)) * fs_param_Building_dxdy)) || GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(0, 1)) * fs_param_Building_dxdy)) || GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(0, -(1))) * fs_param_Building_dxdy)) || GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(1, 1)) * fs_param_Building_dxdy)) || GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(-(1), 1)) * fs_param_Building_dxdy)) || GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(1, -(1))) * fs_param_Building_dxdy)) || GpuSim__SimShader__selected(tex2D(fs_param_Building, psin.TexCoords + (float2(-(1), -(1))) * fs_param_Building_dxdy));
        GpuSim__SimShader__set_selected(building_here, is_selected);
    }
    __FinalOutput.Color = building_here;
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