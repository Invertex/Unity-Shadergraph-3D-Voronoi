//3D Voronoi referenced from https://www.shadertoy.com/view/flSGDK
float hash(float x) { return frac(x + 1.3215 * 1.8152); }

float hash3(float3 a) { return frac((hash(a.z * 42.8883) + hash(a.y * 36.9125) + hash(a.x * 65.4321)) * 291.1257); }

float3 rehash3(float x) { return float3(hash(((x + 0.5283) * 59.3829) * 274.3487), hash(((x + 0.8192) * 83.6621) * 345.3871), hash(((x + 0.2157f) * 36.6521f) * 458.3971f)); }

float sqr(float x) {return x*x;}
float fastdist(float3 a, float3 b) { return sqr(b.x - a.x) + sqr(b.y - a.y) + sqr(b.z - a.z); }

void voronoi3D_float(float3 pos, float density, out float Out, out float Cells) {
    float4 p[27];
	pos *= density;
    float x = pos.x;
	float y = pos.y;
	float z = pos.z;
    for (int _x = -1; _x < 2; _x++) for (int _y = -1; _y < 2; _y++) for(int _z = -1; _z < 2; _z++) {
        float3 _p = float3(floor(x), floor(y), floor(z)) + float3(_x, _y, _z);
        float h = hash3(_p);
        p[(_x + 1) + ((_y + 1) * 3) + ((_z + 1) * 3 * 3)] = float4((rehash3(h) + _p).xyz, h);
    }
    float m = 9999.9999, w = 0.0;
    for (int i = 0; i < 27; i++) {
        float d = fastdist(float3(x, y, z), p[i].xyz);
        if(d < m) { m = d; w = p[i].w; }
    }
	
    Out = m;
	Cells = w;
}