[shader("compute")]
[numthreads(4, 2, 1)]
void main(uint3 dispatchThreadID : SV_DispatchThreadID)
{
    uint value = dispatchThreadID.x + dispatchThreadID.y;
}
