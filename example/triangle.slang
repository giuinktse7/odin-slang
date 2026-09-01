static const float ROTATION_SPEED = 0.35f;
static const float2 TRIANGLE_CENTER = float2(-1.0f / 6.0f, 1.0f / 6.0f);

struct FrameUniforms {
    float time;
};

[[vk::push_constant]]
ConstantBuffer<FrameUniforms> frame;

struct V2P {
    float4 pos : SV_Position;
    float3 color : COLOR0;
};

struct Vertex {
    float3 position;
    float3 color;
};

static const Vertex VERTICES[3] = {
    { { -0.5f, -0.5f,  0.0f }, { 1.0f, 0.0f, 0.0f } },
    { { -0.5f,  0.5f,  0.0f }, { 0.0f, 1.0f, 0.0f } },
    { {  0.5f,  0.5f,  0.0f }, { 0.0f, 0.0f, 1.0f } }
};

[shader("vertex")]
V2P vertexmain(uint vertex_index: SV_VertexID) {
    let vertex = VERTICES[vertex_index];
    float angle = frame.time * ROTATION_SPEED;
    float sine = sin(angle);
    float cosine = cos(angle);

    float2 position = vertex.position.xy - TRIANGLE_CENTER;
    position = float2(
        cosine * position.x - sine * position.y,
        sine * position.x + cosine * position.y
    );
    position += TRIANGLE_CENTER;
    
    V2P output;
    output.pos = float4(position, vertex.position.z, 1.0);
    output.color = vertex.color;
    
    return output;
}

struct PSOutput {
    [vk_location(0)]
    float4 frag_color : COLOR0;
};

[shader("fragment")]
PSOutput fragmentmain(V2P input) {
    PSOutput output;
    output.frag_color = float4(input.color, 1.0);
    return output;
}
