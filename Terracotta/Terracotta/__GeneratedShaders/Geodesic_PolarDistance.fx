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
// Texture Sampler for fs_param_Geo, using register location 1
float2 fs_param_Geo_size;
float2 fs_param_Geo_dxdy;

Texture fs_param_Geo_Texture;
sampler fs_param_Geo : register(s1) = sampler_state
{
    texture   = <fs_param_Geo_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Info, using register location 2
float2 fs_param_Info_size;
float2 fs_param_Info_dxdy;

Texture fs_param_Info_Texture;
sampler fs_param_Info : register(s2) = sampler_state
{
    texture   = <fs_param_Info_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
float Terracotta__SimShader__unpack_val(float2 packed)
{
    float coord = 0;
    packed = floor(255.0 * packed + float2(0.5, 0.5));
    coord = 256 * packed.x + packed.y;
    return coord;
}

float Terracotta__SimShader__polar_dist(float4 info)
{
    return Terracotta__SimShader__unpack_val(info.rg);
}

float2 Terracotta__SimShader__pack_val_2byte(float x)
{
    float2 packed = float2(0, 0);
    packed.x = floor(x / 256.0);
    packed.y = x - packed.x * 256.0;
    return packed / 255.0;
}

float3 Terracotta__SimShader__pack_vec2_3byte(float2 v)
{
    float2 packed_x = Terracotta__SimShader__pack_val_2byte(v.x);
    float2 packed_y = Terracotta__SimShader__pack_val_2byte(v.y);
    return float3(packed_x.y, packed_y.y, packed_x.x + 16 * packed_y.x);
}

void Terracotta__SimShader__set_geo_pos_id(inout float4 g, float2 pos)
{
    g.gba = Terracotta__SimShader__pack_vec2_3byte(pos);
}

void Terracotta__SimShader__set_polar_dist(inout float4 info, float polar_dist)
{
    info.rg = Terracotta__SimShader__pack_val_2byte(polar_dist);
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
    float4 here = tex2D(fs_param_Geo, psin.TexCoords + (float2(0, 0)) * fs_param_Geo_dxdy), right = tex2D(fs_param_Geo, psin.TexCoords + (float2(1, 0)) * fs_param_Geo_dxdy), up = tex2D(fs_param_Geo, psin.TexCoords + (float2(0, 1)) * fs_param_Geo_dxdy), left = tex2D(fs_param_Geo, psin.TexCoords + (float2(-(1), 0)) * fs_param_Geo_dxdy), down = tex2D(fs_param_Geo, psin.TexCoords + (float2(0, -(1))) * fs_param_Geo_dxdy);
    float dist_right = Terracotta__SimShader__polar_dist(tex2D(fs_param_Info, psin.TexCoords + (float2(1, 0)) * fs_param_Info_dxdy)), dist_up = Terracotta__SimShader__polar_dist(tex2D(fs_param_Info, psin.TexCoords + (float2(0, 1)) * fs_param_Info_dxdy)), dist_left = Terracotta__SimShader__polar_dist(tex2D(fs_param_Info, psin.TexCoords + (float2(-(1), 0)) * fs_param_Info_dxdy)), dist_down = Terracotta__SimShader__polar_dist(tex2D(fs_param_Info, psin.TexCoords + (float2(0, -(1))) * fs_param_Info_dxdy));
    if (abs(here.r - 0.0) < .001)
    {
        __FinalOutput.Color = float4(0, 0, 0, 0);
        return __FinalOutput;
    }
    float dist = 0;
    float4 temp_geo = float4(0, 0, 0, 0);
    float2 pos = psin.TexCoords * fs_param_Geo_size;
    Terracotta__SimShader__set_geo_pos_id(temp_geo, pos);
    if (all(abs(here.gba - temp_geo.gba) < .001))
    {
        dist = 0;
    }
    else
    {
        if (abs(here.r - 0.01176471) < .001)
        {
            dist = max(0.0, dist_left - 1);
        }
        if (abs(here.r - 0.003921569) < .001)
        {
            dist = max(0.0, dist_right - 1);
        }
        if (abs(here.r - 0.007843138) < .001)
        {
            dist = max(0.0, dist_up - 1);
        }
        if (abs(here.r - 0.01568628) < .001)
        {
            dist = max(0.0, dist_down - 1);
        }
        if (abs(right.r - 0.01176471) < .001 && dist_right >= dist - .001)
        {
            dist = dist_right + 1;
        }
        if (abs(left.r - 0.003921569) < .001 && dist_left >= dist - .001)
        {
            dist = dist_left + 1;
        }
        if (abs(up.r - 0.01568628) < .001 && dist_up >= dist - .001)
        {
            dist = dist_up + 1;
        }
        if (abs(down.r - 0.007843138) < .001 && dist_down >= dist - .001)
        {
            dist = dist_down + 1;
        }
    }
    float4 output = float4(0, 0, 0, 0);
    Terracotta__SimShader__set_polar_dist(output, dist);
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