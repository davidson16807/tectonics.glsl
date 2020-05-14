
float get_surface_area_of_tetrahedron(
    in vec3 vertex1,
    in vec3 vertex2,
    in vec3 vertex3,
    in vec3 vertex4
) {
    // each face is half the magnitude of the cross product
    return 0.5f * (
        length(cross(vertex1-vertex2, vertex1-vertex3)) + 
        length(cross(vertex1-vertex2, vertex1-vertex4)) +
        length(cross(vertex1-vertex3, vertex1-vertex4)) +
        length(cross(vertex2-vertex3, vertex2-vertex4)) 
    );
}
float get_volume_of_tetrahedron(
    in vec3 vertex1,
    in vec3 vertex2,
    in vec3 vertex3,
    in vec3 vertex4
) {
    // 1/6 the volume of a parallelipiped, which is the scalar triple product of its edges
    return dot(cross(vertex1-vertex2, vertex1-vertex3), vertex1-vertex4) / 6.f;
}

/*
A0 point position
B1 vertex position 1
B2 vertex position 2
B3 vertex position 3
B4 vertex position 4
*/
bool is_3d_point_in_tetrahedron(in vec3 A0, in vec3 B1, in vec3 B2, in vec3 B3, in vec3 B4)
{
    // INTUITION: for each triangle, make sure A0 lies on the same side as the remaining vertex
    vec3 B2xB3 = cross(B2-B1, B3-B1);
    vec3 B3xB1 = cross(B3-B2, B1-B2);
    vec3 B1xB2 = cross(B1-B3, B2-B3);
   return sign(dot(A0-B1, B2xB3)) == sign(dot(B4-B1, B2xB3)) 
        && sign(dot(A0-B2, B3xB1)) == sign(dot(A0-B2, B3xB1)) 
        && sign(dot(A0-B3, B1xB2)) == sign(dot(A0-B3, B1xB2)) 
        ;
}

/*
A0 line reference
A  line direction, normalized
B1 vertex position 1
B2 vertex position 2
B3 vertex position 3
B4 vertex position 4
*/

maybe_float get_distance_along_3d_line_to_tetrahedron(
    in vec3 A0,
    in vec3 A,
    in vec3 B1,
    in vec3 B2,
    in vec3 B3,
    in vec3 B4
){
    maybe_float hit1 = get_distance_along_3d_line_to_triangle(A0, A, B1, B2, B3);
    maybe_float hit2 = get_distance_along_3d_line_to_triangle(A0, A, B2, B3, B4);
    maybe_float hit3 = get_distance_along_3d_line_to_triangle(A0, A, B3, B4, B1);
    maybe_float hit4 = get_distance_along_3d_line_to_triangle(A0, A, B4, B1, B2);
    maybe_float hit;
    hit = get_distance_along_line_to_union(hit1, hit2);
    hit = get_distance_along_line_to_union(hit,  hit3);
    hit = get_distance_along_line_to_union(hit,  hit4);
    return hit;
}
