

float get_2d_simplex_perlin_noise(
    in vec2 V,
    in mat2 K 
){
    const float s = (sqrt(3.0)-1.0)/2.0;
    const mat2 S = mat2(1.0+s, s,
                        s, 1.0+s);
    const mat2 Sinv = inverse(S);
    vec2 F  = fract(S*V);
    // simplex vertex indices
    vec2 I0 = floor(S*V); 
    vec2 I1 = I0 + (F.x > F.y? vec2(1,0) : vec2(0,1));
    vec2 I2 = I0 + vec2(1,1);
    // simplex vertex positions
    vec2 V0 = Sinv*I0;
    vec2 V1 = Sinv*I1;
    vec2 V2 = Sinv*I2;
    // simplex vertex position offsets
    vec2 F0 = V-V0;
    vec2 F1 = V-V1;
    vec2 F2 = V-V2;
    float t0 = max( 0.5 - dot(F0, F0), 0.0); t0*=t0; t0*=t0; 
    float t1 = max( 0.5 - dot(F1, F1), 0.0); t1*=t1; t1*=t1; 
    float t2 = max( 0.5 - dot(F2, F2), 0.0); t2*=t2; t2*=t2; 
    return 30.0 * (
        t0 * dot(normalize(noise2(K*I0)-0.5), F0) +
        t1 * dot(normalize(noise2(K*I1)-0.5), F1) +
        t2 * dot(normalize(noise2(K*I2)-0.5), F2)
    );
}

/*
 * Efficient simplex indexing functions by Bill Licea-Kane, ATI. Thanks!
 */
void get_3d_simplex_index_offsets( 
    const in vec3 P, 
    out vec3 offset1, 
    out vec3 offset2 
){
    vec3 offset0;

    vec2 isX = step( P.yz, P.xx ); // P.x >= P.y ? 1.0 : 0.0;  P.x >= P.z ? 1.0 : 0.0;
    offset0.x  = isX.x + isX.y;    // Accumulate all P.x >= other channels in offset.x
    offset0.yz = 1.0 - isX;        // Accumulate all P.x <  other channels in offset.yz

    float isY = step( P.z, P.y );  // P.y >= P.z ? 1.0 : 0.0;
    offset0.y += isY;              // Accumulate P.y >= P.z in offset.y
    offset0.z += 1.0 - isY;        // Accumulate P.y <  P.z in offset.z

    // offset0 now contains the unique values 0,1,2 in each channel
    // 2 for the channel greater than other channels
    // 1 for the channel that is less than one but greater than another
    // 0 for the channel less than other channels
    // Equality ties are broken in favor of first x, then y
    // (z always loses ties)

    offset2 = clamp( offset0, 0.0, 1.0 );
    // offset2 contains 1 in each channel that was 1 or 2
    offset1 = clamp( offset0-1.0, 0.0, 1.0 );
    // offset1 contains 1 in the single channel that was 1
}

float get_3d_simplex_perlin_noise(
    in vec3 V,
    in mat3 K 
){
    const float s = 1.0/3.0;
    const mat3 S = mat3(1.0+s, s, s,
                        s, 1.0+s, s,
                        s, s, 1.0+s);
    const mat3 Sinv = inverse(S);
    vec3 F  = fract(S*V);
    // simplex vertex index offsets
    vec3 O1; vec3 O2; get_3d_simplex_index_offsets(F, O1, O2);
    // simplex vertex indices
    vec3 I0 = floor(S*V); 
    vec3 I1 = I0 + O1;
    vec3 I2 = I0 + O2;
    vec3 I3 = I0 + vec3(1,1,1);
    // simplex vertex positions
    vec3 V0 = Sinv*I0;
    vec3 V1 = Sinv*I1;
    vec3 V2 = Sinv*I2;
    vec3 V3 = Sinv*I3;
    // simplex vertex position offsets
    vec3 F0 = V-V0;
    vec3 F1 = V-V1;
    vec3 F2 = V-V2;
    vec3 F3 = V-V3;
    float t0 = max( 0.5 - dot(F0, F0), 0.0); t0*=t0; t0*=t0; 
    float t1 = max( 0.5 - dot(F1, F1), 0.0); t1*=t1; t1*=t1; 
    float t2 = max( 0.5 - dot(F2, F2), 0.0); t2*=t2; t2*=t2; 
    float t3 = max( 0.5 - dot(F3, F3), 0.0); t3*=t3; t3*=t3; 
    return 32.0 * (
        t0 * dot(normalize(noise3(K*I0)-0.5), F0) +
        t1 * dot(normalize(noise3(K*I1)-0.5), F1) +
        t2 * dot(normalize(noise3(K*I2)-0.5), F2) +
        t3 * dot(normalize(noise3(K*I3)-0.5), F3)
    );
}

/*
 * Efficient simplex indexing functions by Bill Licea-Kane, ATI. Thanks!
 */
void get_4d_simplex_index_offsets( 
    const in vec4 P, 
    out vec4 offset1, 
    out vec4 offset2, 
    out vec4 offset3 
){
    vec4 offset0;

    vec3 isX = step( P.yzw, P.xxx );        // See comments in 3D simplex function
    offset0.x = isX.x + isX.y + isX.z;
    offset0.yzw = 1.0 - isX;

    vec2 isY = step( P.zw, P.yy );
    offset0.y += isY.x + isY.y;
    offset0.zw += 1.0 - isY;

    float isZ = step( P.w, P.z );
    offset0.z += isZ;
    offset0.w += 1.0 - isZ;

    // offset0 now contains the unique values 0,1,2,3 in each channel

    offset3 = clamp( offset0, 0.0, 1.0 );
    offset2 = clamp( offset0-1.0, 0.0, 1.0 );
    offset1 = clamp( offset0-2.0, 0.0, 1.0 );
}

float get_4d_simplex_perlin_noise(
    in vec4 V,
    in mat4 K 
){
    const float s =  (sqrt(5.0)-1.0)/4.0;
    const mat4 S = mat4(1.0+s, s, s, s,
                        s, 1.0+s, s, s,
                        s, s, 1.0+s, s,
                        s, s, s, 1.0+s);
    const mat4 Sinv = inverse(S);
    vec4 F  = fract(S*V);
    // simplex vertex index offsets
    vec4 O1; vec4 O2; vec4 O3; get_4d_simplex_index_offsets(F, O1, O2, O3);
    // simplex vertex indices
    vec4 I0 = floor(S*V); 
    vec4 I1 = I0 + O1;
    vec4 I2 = I0 + O2;
    vec4 I3 = I0 + O3;
    vec4 I4 = I0 + vec4(1,1,1,1);
    // simplex vertex positions
    vec4 V0 = Sinv*I0;
    vec4 V1 = Sinv*I1;
    vec4 V2 = Sinv*I2;
    vec4 V3 = Sinv*I3;
    vec4 V4 = Sinv*I4;
    // simplex vertex position offsets
    vec4 F0 = V-V0;
    vec4 F1 = V-V1;
    vec4 F2 = V-V2;
    vec4 F3 = V-V3;
    vec4 F4 = V-V4;
    float t0 = max( 0.5 - dot(F0, F0), 0.0); t0*=t0; t0*=t0; 
    float t1 = max( 0.5 - dot(F1, F1), 0.0); t1*=t1; t1*=t1; 
    float t2 = max( 0.5 - dot(F2, F2), 0.0); t2*=t2; t2*=t2; 
    float t3 = max( 0.5 - dot(F3, F3), 0.0); t3*=t3; t3*=t3; 
    float t4 = max( 0.5 - dot(F4, F4), 0.0); t4*=t4; t4*=t4; 
    return 27.0 * (
        t0 * dot(normalize(noise4(K*I0)-0.5), F0) +
        t1 * dot(normalize(noise4(K*I1)-0.5), F1) +
        t2 * dot(normalize(noise4(K*I2)-0.5), F2) +
        t3 * dot(normalize(noise4(K*I3)-0.5), F3) +
        t4 * dot(normalize(noise4(K*I4)-0.5), F4)
    );
}
