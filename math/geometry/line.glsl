//#include "precompiled/academics/math/geometry/point_intersection.glsl"

maybe_vec2 get_bounding_distances_along_ray(in maybe_vec2 distances_along_line){
    return maybe_vec2(
        vec2(
          max(min(distances_along_line.value.x, distances_along_line.value.y), 0.0),
          max(distances_along_line.value.x, distances_along_line.value.y)
        ),
        distances_along_line.exists && max(distances_along_line.value.x, distances_along_line.value.y) > 0.
      );
}
maybe_float get_nearest_distance_along_ray(in maybe_vec2 distances_along_line){
    return maybe_float(
        distances_along_line.value.x < 0.0? distances_along_line.value.y :
        distances_along_line.value.y < 0.0? distances_along_line.value.x :
        min(distances_along_line.value.x, distances_along_line.value.y),
        distances_along_line.exists && max(distances_along_line.value.x, distances_along_line.value.y) > 0.
      );
}

/*
A0 line reference
A  line direction, normalized
B0 line reference
B  line direction, normalized
*/

maybe_float get_distance_along_2d_line_to_line(
    in vec2 A0,
    in vec2 A,
    in vec2 B0,
    in vec2 B
){
    vec2 D = B0 - A0;
    // offset
    vec2 R = D - dot(D, A) * A;
    // rejection
    return maybe_float(
        length(R) / dot(B, normalize(-R)), 
        abs(abs(dot(A, B)) - 1.0) > 0.0
    );
}

/*
A0 line reference
A  line direction, normalized
B0 ray origin
B  ray direction, normalized
*/

maybe_float get_distance_along_2d_line_to_ray(
    in vec2 A0,
    in vec2 A,
    in vec2 B0,
    in vec2 B
){
    // INTUITION: same as the line-line intersection, but now results are only valid if distance > 0
    vec2 D = B0 - A0;
    // offset
    vec2 R = D - dot(D, A) * A;
    // rejection
    float xB = length(R) / dot(B, normalize(-R));
    // distance along B
    float xA = xB / dot(B, A);
    // distance along A
    return maybe_float(xB, abs(abs(dot(A, B)) - 1.0) > 0.0 && xA > 0.0);
}

/*
A0 line reference
A  line direction, normalized
B0 line segment endpoint 1
B1 line segment endpoint 2
*/

/*
A0 point position
B0 line reference
N  surface normal of region, normalized

NOTE: in this case, N only needs to indicate the direction facing outside, 
 it need not be perfectly normal to B
*/
bool is_2d_point_in_region_bounded_by_line(in vec2 A0, in vec2 B0, in vec2 N)
{
    return dot(A0-B0, N) < 0.;
}

/*
A0 point position
B0 line reference
N  surface normal of region, normalized

NOTE: in this case, N only needs to indicate the direction facing outside, 
 it need not be perfectly normal to B
*/
float get_distance_of_2d_point_to_region_bounded_by_line(in vec2 A0, in vec2 B0, in vec2 N)
{
    return dot(A0-B0, N);
}

maybe_float get_distance_along_2d_line_to_line_segment(
    in vec2 A0,
    in vec2 A,
    in vec2 B1,
    in vec2 B2
){
    // INTUITION: same as the line-line intersection, but now results are only valid if 0 < distance < |B2-B1|
    vec2 B = normalize(B2 - B1);
    vec2 D = B1 - A0;
    // offset
    vec2 R = D - dot(D, A) * A;
    // rejection
    float xB = length(R) / dot(B, normalize(-R));
    // distance along B
    float xA = xB / dot(B, A);
    // distance along A
    return maybe_float(xB, abs(abs(dot(A, B)) - 1.0) > 0.0 && 0. < xA && xA < length(B2 - B1));
}



/*
A0 line reference
A  line direction, normalized
B0 line reference
B  line direction, normalized
*/

maybe_float get_distance_along_3d_line_nearest_to_line(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 B
){
    vec3 D = B0 - A0;
    // offset
    vec3 C = normalize(cross(B, A));
    // cross
    vec3 R = D - dot(D, A) * A - dot(D, C) * C;
    // rejection
    return maybe_float(
        length(R) / -dot(B, normalize(R)), 
        abs(abs(dot(A, B)) - 1.0) > 0.0
    );
}

/*
A0 line reference
A  line direction, normalized
B0 ray origin
B  ray direction, normalized
*/

maybe_float get_distance_along_3d_line_nearest_to_ray(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 B
){
    vec3 D = B0 - A0;
    // offset
    vec3 R = D - dot(D, A) * A;
    // rejection
    float xB = length(R) / dot(B, normalize(-R));
    // distance along B
    float xA = xB / dot(B, A);
    // distance along A
    return maybe_float(xB, abs(abs(dot(A, B)) - 1.0) > 0.0 && xA > 0.0);
}

/*
A0 line reference
A  line direction, normalized
B1 line segment endpoint 1
B2 line segment endpoint 2
*/

maybe_float get_distance_along_3d_line_nearest_to_line_segment(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 B1
){
    vec3 B = normalize(B1 - B0);
    vec3 D = B0 - A0;
    // offset
    vec3 R = D - dot(D, A) * A;
    // rejection
    float xB = length(R) / dot(B, normalize(-R));
    // distance along B
    float xA = xB / dot(B, A);
    // distance along A
    return maybe_float(xB, abs(abs(dot(A, B)) - 1.0) > 0.0 && 0. < xA && xA < length(B1 - B0));
}
