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
// Texture Sampler for fs_param_Current, using register location 1
float2 fs_param_Current_size;
float2 fs_param_Current_dxdy;

Texture fs_param_Current_Texture;
sampler fs_param_Current : register(s1) = sampler_state
{
    texture   = <fs_param_Current_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Previous, using register location 2
float2 fs_param_Previous_size;
float2 fs_param_Previous_dxdy;

Texture fs_param_Previous_Texture;
sampler fs_param_Previous : register(s2) = sampler_state
{
    texture   = <fs_param_Previous_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_CurData, using register location 3
float2 fs_param_CurData_size;
float2 fs_param_CurData_dxdy;

Texture fs_param_CurData_Texture;
sampler fs_param_CurData : register(s3) = sampler_state
{
    texture   = <fs_param_CurData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_PrevData, using register location 4
float2 fs_param_PrevData_size;
float2 fs_param_PrevData_dxdy;

Texture fs_param_PrevData_Texture;
sampler fs_param_PrevData : register(s4) = sampler_state
{
    texture   = <fs_param_PrevData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Texture, using register location 5
float2 fs_param_Texture_size;
float2 fs_param_Texture_dxdy;

Texture fs_param_Texture_Texture;
sampler fs_param_Texture : register(s5) = sampler_state
{
    texture   = <fs_param_Texture_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

float fs_param_s;

// The following methods are included because they are referenced by the fragment shader.
float2 GpuSim__SimShader__get_subcell_pos(VertexToPixel vertex, float2 grid_size)
{
    float2 coords = vertex.TexCoords * grid_size;
    float i = floor(coords.x);
    float j = floor(coords.y);
    return coords - float2(i, j);
}

bool GpuSim__SimShader__Something(float4 u)
{
    return u.r > 0;
}

bool GpuSim__SimShader__selected(float4 u)
{
    float val = u.b;
    return val >= 0.01960784;
}

float4 GpuSim__DrawUnit__Sprite(VertexToPixel psin, float4 u, float4 d, float2 pos, float anim, float frame, sampler Texture, float2 Texture_size, float2 Texture_dxdy)
{
    if (pos.x > 1 || pos.y > 1 || pos.x < 0 || pos.y < 0)
    {
        return float4(0.0, 0.0, 0.0, 0.0);
    }
    float selected_offset = GpuSim__SimShader__selected(u) ? 4 : 0;
    pos.x += ((int)(floor(frame)) % 5);
    pos.y += (floor(anim * 255 + 0.5) - 1 + selected_offset);
    pos *= float2(1.0 / 10.0, 1.0 / 8.0);
    float4 clr = tex2D(Texture, pos);
    if (abs(d.g - 0.003921569) < .001)
    {
    }
    else
    {
        if (abs(d.g - 0.007843138) < .001)
        {
            float r = clr.r;
            clr.r = clr.g;
            clr.g = r;
            clr.rgb *= 0.5;
        }
        else
        {
            if (abs(d.g - 0.01176471) < .001)
            {
                float b = clr.b;
                clr.b = clr.g;
                clr.g = b;
            }
            else
            {
                if (abs(d.g - 0.01568628) < .001)
                {
                    float r = clr.r;
                    clr.r = clr.b;
                    clr.b = r;
                }
            }
        }
    }
    return clr;
}

bool GpuSim__SimShader__IsValid(float direction)
{
    return direction > 0;
}

float GpuSim__SimShader__prior_direction(float4 u)
{
    float val = u.b;
    return val % 0.01960784;
}

float2 GpuSim__SimShader__direction_to_vec(float direction)
{
    float angle = (direction * 255 - 1) * (3.141593 / 2.0);
    return GpuSim__SimShader__IsValid(direction) ? float2(cos(angle), sin(angle)) : float2(0, 0);
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
    float4 output = float4(0.0, 0.0, 0.0, 0.0);
    float4 cur = tex2D(fs_param_Current, psin.TexCoords + (float2(0, 0)) * fs_param_Current_dxdy), pre = tex2D(fs_param_Previous, psin.TexCoords + (float2(0, 0)) * fs_param_Previous_dxdy);
    float4 cur_data = tex2D(fs_param_CurData, psin.TexCoords + (float2(0, 0)) * fs_param_CurData_dxdy), pre_data = tex2D(fs_param_PrevData, psin.TexCoords + (float2(0, 0)) * fs_param_PrevData_dxdy);
    float2 subcell_pos = GpuSim__SimShader__get_subcell_pos(psin, fs_param_Current_size);
    if (GpuSim__SimShader__Something(cur) && abs(cur.g - 0.003921569) < .001)
    {
        if (fs_param_s > 0.5)
        {
            pre = cur;
        }
        output += GpuSim__DrawUnit__Sprite(psin, pre, pre_data, subcell_pos, pre.r, 0, fs_param_Texture, fs_param_Texture_size, fs_param_Texture_dxdy);
    }
    else
    {
        if (GpuSim__SimShader__IsValid(cur.r))
        {
            float prior_dir = GpuSim__SimShader__prior_direction(cur);
            float2 offset = (1 - fs_param_s) * GpuSim__SimShader__direction_to_vec(prior_dir);
            output += GpuSim__DrawUnit__Sprite(psin, cur, cur_data, subcell_pos + offset, prior_dir, fs_param_s * 5, fs_param_Texture, fs_param_Texture_size, fs_param_Texture_dxdy);
        }
        if (GpuSim__SimShader__IsValid(pre.r) && output.a < 0.025)
        {
            float2 offset = -(fs_param_s) * GpuSim__SimShader__direction_to_vec(pre.r);
            output += GpuSim__DrawUnit__Sprite(psin, pre, pre_data, subcell_pos + offset, pre.r, fs_param_s * 5, fs_param_Texture, fs_param_Texture_size, fs_param_Texture_dxdy);
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