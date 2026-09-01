struct SceneConstants
{
    float4 tint;
    float4 ambient;
};

struct PushConstants
{
    uint outputIndex;
    float scale;
};

[[vk::binding(0, 0)]]
Texture2D<float4> albedoTexture;

[[vk::binding(1, 0)]]
SamplerState linearSampler;

[[vk::binding(2, 0)]]
ConstantBuffer<SceneConstants> scene;

[[vk::binding(3, 0)]]
RWStructuredBuffer<float4> outputBuffer;

[[vk::push_constant]]
ConstantBuffer<PushConstants> pushData;

uniform float exposure;

[shader("compute")]
[numthreads(8, 4, 1)]
void main(uint3 dispatchThreadID : SV_DispatchThreadID)
{
    float4 sampled = albedoTexture.SampleLevel(linearSampler, float2(0.5), 0.0);
    outputBuffer[pushData.outputIndex + dispatchThreadID.x] =
        sampled * scene.tint * scene.ambient * exposure * pushData.scale;
}
