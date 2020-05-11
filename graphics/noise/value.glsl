
/*
V: position
K: seed
*/
float get_2d_value_noise(
    in vec2 V,
    in vec2 K
){
    vec2 I = floor(V);
    vec2 F = smoothstep(0.f, 1.f, fract(V));
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
            a += noise1(dot(J,K)) * G.x * G.y;
        }
    }
    return clamp(a, 0.f, 1.f);
}
/*
V: position
K: seed
*/
float get_3d_value_noise(
    in vec3 V,
    in vec3 K 
){
    vec3 I = floor(V);
    vec3 F = smoothstep(0.f, 1.f, fract(V));
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
                a += noise1(dot(J,K)) * G.x * G.y * G.z;
            }
        }
    }
    return clamp(a, 0.f, 1.f);
}

/*
V: position
K: seed
*/
float get_4d_value_noise(
    in vec4 V,
    in vec4 K 
){
    vec4 I = floor(V);
    vec4 F = smoothstep(0.f, 1.f, fract(V));
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
                    a += noise1(dot(J,K)) * G.x * G.y * G.z * G.w;
                }
            }
        }
    }
    return clamp(a, 0.f, 1.f);
}
