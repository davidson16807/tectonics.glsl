
float get_perimeter_of_circle(
    in float radius
) {
    return 2.*PI*radius;
}
float get_area_of_circle(
    in float radius
) {
    return PI*radius*radius;
}
/*
A0 point position
B0 sphere origin
r  radius
*/
bool is_2d_point_in_circle(in vec2 A0, in vec2 B0, in float r)
{
    return length(A0-B0) < r;
}

/*
A0 point position
B0 sphere origin
r  radius
*/
float get_distance_of_2d_point_to_circle(in vec2 A0, in vec2 B0, in float r)
{
    return length(A0-B0) - r;
}

maybe_vec2 get_distances_along_2d_line_to_circle(
    in vec2 A0,
    in vec2 A,
    in vec2 B0,
    in float r
){
    vec2 D = B0 - A0;
    float xz = dot(D, A);
    float z2 = dot(D, D) - xz * xz;
    float y2 = r * r - z2;
    float dxr = sqrt(max(y2, 1e-10));
    return maybe_vec2(vec2(xz - dxr, xz + dxr), y2 > 0.);
}

/*
A0 line reference
A  line direction, normalized
B0 circle origin
N  circle surface normal, normalized
r  circle radius
*/

maybe_float get_distance_along_3d_line_to_circle(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 N,
    in float r
){
    // intersection(plane, sphere)
    maybe_float t = get_distance_along_3d_line_to_plane(A0, A, B0, N);
    return maybe_float(t.value, is_3d_point_in_sphere(A0 + A * t.value, B0, r));
}

