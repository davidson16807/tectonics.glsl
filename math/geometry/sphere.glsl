
float get_surface_area_of_sphere(
    in float radius
) {
    return 4.*PI*radius*radius;
}
float get_volume_of_sphere(
    in float radius
) {
    return 4./3.*PI*radius*radius*radius;
}
/*
A0 point position
B0 sphere origin
r  radius
*/
bool is_3d_point_in_sphere(in vec3 A0, in vec3 B0, in float r)
{
    return length(A0-B0) < r;
}
/*
A0 point position
B0 sphere origin
r  radius
*/
float get_distance_of_3d_point_to_sphere(in vec3 A0, in vec3 B0, in float r)
{
    return length(A0-B0) - r;
}
/*
A0 point position
B0 sphere origin
r  radius
*/
vec3 get_surface_normal_of_point_near_sphere( in vec3 A0, in vec3 B0, in float r )
{
    return normalize( A0-B0 );
}
/*
A0 line reference
A  line direction, normalized
B0 sphere origin
R  sphere radius along each coordinate axis
*/

maybe_vec2 get_distances_along_3d_line_to_sphere(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in float r
){
    float xz = dot(B0 - A0, A);
    float z = length(A0 + A * xz - B0);
    float y2 = r * r - z * z;
    float dxr = sqrt(max(y2, 1e-10));
    return maybe_vec2(
        vec2(xz - dxr, xz + dxr), 
        y2 > 0.
    );
}
