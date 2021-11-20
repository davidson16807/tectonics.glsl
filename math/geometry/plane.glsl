
/*
A0 point position
B0 plane reference
N  vertex normal
*/
bool is_3d_point_in_half_space(in vec3 A0, in vec3 B0, in vec3 N)
{
    return dot(A0-B0, N) < 0.;
}
/*
A0 point position
B0 plane reference
N  vertex normal
*/
float get_distance_of_3d_point_to_half_space(in vec3 A0, in vec3 B0, in vec3 N)
{
    return dot(A0-B0, N);
}
/*
A0 line reference
A  line direction, normalized
B0 plane reference
N  plane surface normal, normalized
*/

maybe_float get_distance_along_3d_line_to_plane(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 N
){
    return maybe_float( -dot(A0 - B0, N) / dot(A, N), abs(dot(A, N)) < SMALL);
}
