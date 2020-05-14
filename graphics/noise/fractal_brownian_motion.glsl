
const int MAX_OCTAVES_COUNT = 6;

/*
V: position
h: Hurst exponent
n: number of iteration
d: iteration scale (typically 2.0)
K: seed
*/
float get_2d_fractal_brownian_motion( in vec2 V, in float h, in float n, in float d, mat2 K )
{
    float g = exp2(-h);
    float f = 1.0;
    float a = 1.0;
    float t = 0.0;
    for( int i=0; i < MAX_OCTAVES_COUNT; ++i )
    {
        if (i < n) { break; }
        t += a*get_2d_simplex_noise(f*x, K);
        f *= d;
        a *= g;
    }
    return t;
}

/*
V: position
h: Hurst exponent
n: number of iteration
d: iteration scale (typically 2.0)
K: seed
*/
float get_3d_fractal_brownian_motion( in vec3 V, in float h, in float n, in float d, mat3 K )
{
    float g = exp2(-h);
    float f = 1.0;
    float a = 1.0;
    float t = 0.0;
    for( int i=0; i < MAX_OCTAVES_COUNT; ++i )
    {
        if (i < n) { break; }
        t += a*get_3d_simplex_noise(f*x, K);
        f *= d;
        a *= g;
    }
    return t;
}

/*
V: position
h: Hurst exponent
n: number of iteration
d: iteration scale (typically 2.0)
K: seed
*/
float get_4d_fractal_brownian_motion( in vec4 V, in float h, in float n, in float d, mat4 K )
{
    float g = exp2(-h);
    float f = 1.0;
    float a = 1.0;
    float t = 0.0;
    for( int i=0; i < MAX_OCTAVES_COUNT; ++i )
    {
        if (i < n) { break; }
        t += a*get_4d_simplex_noise(f*x, K);
        f *= d;
        a *= g;
    }
    return t;
}