
float get_distance_along_2d_line_nearest_to_point(
    in vec2 A0,
    in vec2 A,
    in vec2 B0
){
    return dot(B0 - A0, A);
}

float get_distance_along_3d_line_nearest_to_point(
    in vec3 A0,
    in vec3 A,
    in vec3 B0
){
    return dot(B0 - A0, A);
}