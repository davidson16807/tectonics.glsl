
/*
A0 point position
B0 cylinder reference
B  cylinder direction, normalized
*/
vec3 get_surface_normal_of_point_near_infinite_cylinder( in vec3 A0, in vec3 B0, in vec3 B )
{
    // INTUITION: equivalent to the normalized vector rejection
    vec3 D = A0-B0;
    return normalize( D - B*dot(D, B) );
}
/*
A0 point position
B1 cylinder endpoint 1
B2 cylinder endpoing 2
*/
vec3 get_surface_normal_of_point_near_cylinder( in vec3 A0, in vec3 B1, in vec3 B2 )
{
    vec3 D = A0-B1;
    vec3 B = normalize(B2-B1);
    float DB = dot(D,B);
    return 0.f < DB? -B : DB < length(D)? B : normalize( D-B*DB );
}

/*
A0 line reference
A  line direction, normalized
B0 cylinder reference
B  cylinder direction, normalized
r  cylinder radius
*/

maybe_vec2 get_distances_along_3d_line_to_infinite_cylinder(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 B,
    in float r
){
    // INTUITION: simplify the problem by using a coordinate system based around the line and the tube center
    // see closest-approach-between-line-and-cylinder-visualized.scad
    // implementation shamelessly copied from Inigo: 
    // https://www.iquilezles.org/www/articles/intersectors/intersectors.htm
    vec3 D = A0 - B0;
    float BA = dot(B, A);
    float BD = dot(B, D);
    float a = 1.0 - BA * BA;
    float b = dot(D, A) - BD * BA;
    float c = dot(D, D) - BD * BD - r * r;
    float h = sqrt(max(b * b - a * c, 0.0));
    return maybe_vec2(
        vec2((-b + h) / a, (-b - h) / a), 
        h > 0.0
    );
}

/*
A0 line reference
A  line direction, normalized
B1 cylinder endpoint 1
B2 cylinder endpoing 2
r  cylinder radius
*/

maybe_vec2 get_distances_along_3d_line_to_cylinder(
    in vec3 A0,
    in vec3 A,
    in vec3 B1,
    in vec3 B2,
    in float r
){
    vec3 B = normalize(B2 - B1);
    maybe_float a1 = get_distance_along_3d_line_to_plane(A0, A, B1, B);
    maybe_float a2 = get_distance_along_3d_line_to_plane(A0, A, B2, B);
    float a_in = min(a1.value, a2.value);
    float a_out = max(a1.value, a2.value);
    maybe_vec2 ends = maybe_vec2(vec2(a_in, a_out), a1.exists || a2.exists);
    maybe_vec2 tube = get_distances_along_3d_line_to_infinite_cylinder(A0, A, B1, B, r);
    maybe_vec2 cylinder = get_distances_along_line_to_intersection(tube, ends);
    // TODO: do we need this line?
    float entrance = max(tube.value.y,  a_in);
    float exit     = min(tube.value.x, a_out);
    return maybe_vec2( 
        vec2(entrance, exit), 
        tube.exists && entrance < exit
    );
}
/*
A0 line reference
A  line direction, normalized
B1 capsule endpoint 1
B2 capsule endpoing 2
r  capsule radius
*/

maybe_vec2 get_distances_along_3d_line_to_capsule(
    in vec3 A0,
    in vec3 A,
    in vec3 B1,
    in vec3 B2,
    in float r
){
    maybe_vec2 cylinder = get_distances_along_3d_line_to_cylinder(A0, A, B1, B2, r);
    maybe_vec2 sphere1 = get_distances_along_3d_line_to_sphere(A0, A, B1, r);
    maybe_vec2 sphere2 = get_distances_along_3d_line_to_sphere(A0, A, B2, r);
    maybe_vec2 spheres = get_distances_along_line_to_union(sphere1, sphere2);
    maybe_vec2 capsule = get_distances_along_line_to_union(spheres, cylinder);
    return capsule;
}

/*
A0 line reference
A  line direction, normalized
B1 ring endpoint 1
B2 ring endpoing 2
ro ring outer radius
ri ring inner radius
*/

maybe_vec2 get_distances_along_3d_line_to_ring(
    in vec3 A0,
    in vec3 A,
    in vec3 B1,
    in vec3 B2,
    in float ro,
    in float ri
){
    maybe_vec2 outer = get_distances_along_3d_line_to_cylinder(A0, A, B1, B2, ro);
    maybe_vec2 inner = get_distances_along_3d_line_to_cylinder(A0, A, B1, B2, ri);
    maybe_vec2 ring  = get_distances_along_line_to_negation(outer, inner);
    return ring;
}
