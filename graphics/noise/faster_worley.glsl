
float get_faster_2d_worley_noise(
    in vec2 V,
    in mat2 K
){
    vec2 I = floor(V);
    vec2 F = fract(V);
    vec2 G = smoothstep(0.f, 1.f, F);
    vec2 R = round(V);
    
    float d = 1e20;
    float r = 0.;
    vec2  J = vec2(0.f);
    vec2  U = vec2(0.f);
    for (int i = -1; i <= 0; ++i)
    {
        for (int j = -1; j <= 0; ++j)
        {
            J = R + vec2(i,j);
            U = J + noise2(K*J);
            d = min(d, distance(V,U));
        }
    }
    return clamp(d, 0.f,1.f);
}

float get_faster_3d_worley_noise(
    in vec3 V,
    in mat3 K
){
    vec3 I = floor(V);
    vec3 F = fract(V);
    vec3 G = smoothstep(0.f, 1.f, F);
    vec3 R = round(V);
    
    float d = 1e20;
    float r = 0.;
    vec3  J = vec3(0.f);
    vec3  U = vec3(0.f);
    for (int i = -1; i <= 0; ++i)
    {
        for (int j = -1; j <= 0; ++j)
        {
            for (int k = -1; k <= 0; ++k)
            {
                J = R + vec3(i,j,k);
                U = J + noise3(K*J);
                d = min(d, distance(V,U));
            }
        }
    }
    return clamp(d, 0.f,1.f);
}

float get_faster_4d_worley_noise(
    in vec4 V,
    in mat4 K
){
    vec4 I = floor(V);
    vec4 F = fract(V);
    vec4 G = smoothstep(0.f, 1.f, F);
    vec4 R = round(V);
    
    float d = 1e20;
    float r = 0.;
    vec4  J = vec4(0.f);
    vec4  U = vec4(0.f);
    for (int i = -1; i <= 0; ++i)
    {
        for (int j = -1; j <= 0; ++j)
        {
            for (int k = -1; k <= 0; ++k)
            {
                for (int l = -1; l <= 0; ++l)
                {
                    J = R + vec4(i,j,k,l);
                    U = J + noise4(K*J);
                    d = min(d, distance(V,U));
                }
            }
        }
    }
    return clamp(d, 0.f,1.f);
}