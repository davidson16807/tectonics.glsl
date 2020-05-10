
/*
V: position
K: seed
*/
float get_2d_perlin_noise(
    in vec2 V,
    in mat2 K
){
    vec2 I = floor(V);
    vec2 F = smoothstep(0.f, 1.f, V-I);
    vec2 G = vec2(0);
    vec2 O = vec2(0);
    vec2 J = vec2(0);
    float a = 0.f;
    for (int i = 0; i <= 1; ++i)
    {
        for (int j = 0; j <= 1; ++j)
        {
            O = vec2(i,j);
            J = I + O;
            G = mix(1.0f-F, F, O);
            a += dot(normalize(noise2(K*J)-0.5), V-J) * G.x * G.y;
        }
    }
    return a;
}

/*
V: position
K: seed
*/
float get_3d_perlin_noise(
    in vec3 V,
    in mat3 K
){
    vec3 I = floor(V);
    vec3 F = smoothstep(0.f, 1.f, V-I);
    vec3 G = vec3(0);
    vec3 O = vec3(0);
    vec3 J = vec3(0);
    float a = 0.f;
    for (int i = 0; i <= 1; ++i)
    {
        for (int j = 0; j <= 1; ++j)
        {
            for (int k = 0; k <= 1; ++k)
            {
                O = vec3(i,j,k);
                J = I + O;
                G = mix(1.0f-F, F, O);
                a += dot(normalize(noise3(K*J)-0.5), V-J) * G.x * G.y * G.z;
            }
        }
    }
    return a;
}

/*
V: position
K: seed
*/
float get_4d_perlin_noise(
    in vec4 V,
    in mat4 K
){
    vec4 I = floor(V);
    vec4 F = smoothstep(0.f, 1.f, V-I);
    vec4 G = vec4(0);
    vec4 O = vec4(0);
    vec4 J = vec4(0);
    float a = 0.f;
    for (int i = 0; i <= 1; ++i)
    {
        for (int j = 0; j <= 1; ++j)
        {
            for (int k = 0; k <= 1; ++k)
            {
                for (int l = 0; l <= 1; ++l)
                {
                    O = vec4(i,j,k,l);
                    J = I + O;
                    G = mix(1.0f-F, F, O);
                    a += dot(normalize(noise4(K*J)-0.5), V-J) * G.x * G.y * G.z * G.w;
                }
            }
        }
    }
    return a;
}
