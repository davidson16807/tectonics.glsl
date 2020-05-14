
float get_perimeter_of_triangle(
    in vec2 vertex1,
    in vec2 vertex2,
    in vec2 vertex3
) {
    return length(vertex1-vertex2) + length(vertex2-vertex3) + length(vertex3-vertex1);
}
float get_area_of_triangle(
    in vec2 A,
    in vec2 B,
    in vec2 C
) {
    // half the magnitude of the cross product
    vec2 C = B-A;
    vec2 D = C-A;
    return 0.5f * abs(C.x*D.y - C.y*D.x);
}
/*
A0 point position
B1 vertex position 1
B2 vertex position 2
B3 vertex position 3
*/
bool is_2d_point_in_triangle(in vec2 A0, in vec2 B1, in vec2 B2, in vec2 B3)
{
    // INTUITION: if A falls within a triangle,
    //  the angle between A and any side will always be less than the angle
    //  between that side and the side adjacent to it
    vec2 B2B1hat = normalize(B2-B1);
    vec2 B3B2hat = normalize(B3-B2);
    vec2 B1B3hat = normalize(B1-B3);
    return dot(normalize(A0-B1), B2B1hat) > dot(-B1B3hat, B2B1hat)
        && dot(normalize(A0-B2), B3B2hat) > dot(-B2B1hat, B3B2hat)
        && dot(normalize(A0-B3), B1B3hat) > dot(-B3B2hat, B1B3hat);
}

/*
A0 line reference
A  line direction, normalized
B1 vertex position 1
B2 vertex position 2
*/

maybe_vec2 get_distances_along_2d_line_to_triangle(
    in vec2 A0,
    in vec2 A,
    in vec2 B1,
    in vec2 B2,
    in vec2 B3
){
    maybe_float line1 = get_distance_along_2d_line_to_line_segment(A0, A, B1, B2);
    maybe_float line2 = get_distance_along_2d_line_to_line_segment(A0, A, B2, B3);
    maybe_float line3 = get_distance_along_2d_line_to_line_segment(A0, A, B3, B1);
    return maybe_vec2(
        vec2(min(line1.value, min(line2.value, line3.value)), 
             max(line1.value, max(line2.value, line3.value))), 
        line1.exists || line2.exists || line3.exists
    );
}

/*
A1 vertex 1 position
A2 vertex 2 position
A3 vertex 3 position
*/
vec3 get_surface_normal_of_triangle( in vec3 A1, in vec3 A2, in vec3 A3 )
{
    return normalize( cross(A2-A1, A3-A1) );
}

/*
A0 line reference
A  line direction, normalized
B1 vertex position 1
B2 vertex position 2
B3 vertex position 3
*/

maybe_float get_distance_along_3d_line_to_triangle(
    in vec3 A0,
    in vec3 A,
    in vec3 B1,
    in vec3 B2,
    in vec3 B3
){
    // intersection(face plane, edge plane, edge plane, edge plane)
    vec3 B0 = (B1 + B2 + B3) / 3.;
    vec3 N = normalize(cross(B1 - B2, B2 - B3));
    maybe_float t = get_distance_along_3d_line_to_plane(A0, A, B0, N);
    vec3 At = A0 + A * t.value;
    vec3 B2B1hat = normalize(B2 - B1);
    vec3 B3B2hat = normalize(B3 - B2);
    vec3 B1B3hat = normalize(B1 - B3);
    return maybe_float(t.value, 
        dot(normalize(At - B1), B2B1hat) > dot(-B1B3hat, B2B1hat) && 
        dot(normalize(At - B2), B3B2hat) > dot(-B2B1hat, B3B2hat) && 
        dot(normalize(At - B3), B1B3hat) > dot(-B3B2hat, B1B3hat)
    );
}

