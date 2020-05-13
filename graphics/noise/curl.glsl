

vec3 get_3d_curl_noise(
    in vec3 V,
    in mat3 K0,
    in mat3 K1,
    in mat3 K2
){
    const float e = .1;
    vec3 dx = vec3( e   , 0.0 , 0.0 );
    vec3 dy = vec3( 0.0 , e   , 0.0 );
    vec3 dz = vec3( 0.0 , 0.0 , e   );

    vec3 V_x0 = get_3d_simplex_noise_vec3( V - dx, K0, K1, K2 );
    vec3 V_x1 = get_3d_simplex_noise_vec3( V + dx, K0, K1, K2 );
    vec3 V_y0 = get_3d_simplex_noise_vec3( V - dy, K0, K1, K2 );
    vec3 V_y1 = get_3d_simplex_noise_vec3( V + dy, K0, K1, K2 );
    vec3 V_z0 = get_3d_simplex_noise_vec3( V - dz, K0, K1, K2 );
    vec3 V_z1 = get_3d_simplex_noise_vec3( V + dz, K0, K1, K2 );

    float x = V_y1.z - V_y0.z - V_z1.y + V_z0.y;
    float y = V_z1.x - V_z0.x - V_x1.z + V_x0.z;
    float z = V_x1.y - V_x0.y - V_y1.x + V_y0.x;

    const float divisor = 1.0 / ( 2.0 * e );
    return vec3( x , y , z ) * divisor;
}

vec3 get_4d_curl_noise(
    in vec4 V,
    in mat4 K0,
    in mat4 K1,
    in mat4 K2
){
    const float e = .1;
    vec4 dx = vec4( e  , 0.0, 0.0, 0.0 );
    vec4 dy = vec4( 0.0, e  , 0.0, 0.0 );
    vec4 dz = vec4( 0.0, 0.0, e  , 0.0 );

    vec3 V_x0 = get_4d_simplex_noise_vec3( V - dx, K0, K1, K2 );
    vec3 V_x1 = get_4d_simplex_noise_vec3( V + dx, K0, K1, K2 );
    vec3 V_y0 = get_4d_simplex_noise_vec3( V - dy, K0, K1, K2 );
    vec3 V_y1 = get_4d_simplex_noise_vec3( V + dy, K0, K1, K2 );
    vec3 V_z0 = get_4d_simplex_noise_vec3( V - dz, K0, K1, K2 );
    vec3 V_z1 = get_4d_simplex_noise_vec3( V + dz, K0, K1, K2 );

    float x = V_y1.z - V_y0.z - V_z1.y + V_z0.y;
    float y = V_z1.x - V_z0.x - V_x1.z + V_x0.z;
    float z = V_x1.y - V_x0.y - V_y1.x + V_y0.x;

    const float divisor = 1.0 / ( 2.0 * e );
    return vec3( x , y , z ) * divisor;
}
