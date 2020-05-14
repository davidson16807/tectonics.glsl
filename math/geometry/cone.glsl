
/*
A0 line reference
A  line direction, normalized
B0 cone vertex
B  cone direction, normalized
cosb cosine of cone half angle
*/

maybe_float get_distance_along_3d_line_to_infinite_cone(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 B,
    in float cosb
){
    vec3 D = A0 - B0;
    float a = dot(A, B) * dot(A, B) - cosb * cosb;
    float b = 2. * (dot(A, B) * dot(D, B) - dot(A, D) * cosb * cosb);
    float c = dot(D, B) * dot(D, B) - dot(D, D) * cosb * cosb;
    float det = b * b - 4. * a * c;
    if (det < 0.)
    {
        return maybe_float(0.0, false);
    }

    det = sqrt(det);
    float t1 = (-b - det) / (2. * a);
    float t2 = (-b + det) / (2. * a);
    // This is a bit messy; there ought to be a more elegant solution.
    float t = t1;
    if (t < 0. || t2 > 0. && t2 < t)
    {
        t = t2;
    }
    else {
        t = t1;
    }

    vec3 cp = A0 + t * A - B0;
    float h = dot(cp, B);
    return maybe_float(t, t > 0. && h > 0.);
}

/*
A0 line reference
A  line direction, normalized
B0 cone vertex
B  cone direction, normalized
r  cone radius
h  cone height
*/

maybe_float get_distance_along_3d_line_to_cone(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 B,
    in float r,
    in float h
){
    maybe_float end = get_distance_along_3d_line_to_circle(A0, A, B0 + B * h, B, r);
    maybe_float cone = get_distance_along_3d_line_to_infinite_cone(A0, A, B0, B, cos(atan(r / h)));
    cone.exists = cone.exists && dot(A0 +cone.value * A - B0, B) <= h;
    cone = get_distance_along_line_to_union(end, cone);
    return cone;
}

/*
A0 line reference
A  line direction, normalized
B1 cone endpoint 1
B2 cone endpoint 2
r1 cone endpoint 1 radius
r2 cone endpoint 2 radius
*/

maybe_float get_distance_along_3d_line_to_capped_cone(
    in vec3 A0,
    in vec3 A,
    in vec3 B1,
    in vec3 B2,
    in float r1,
    in float r2
){
    float dh = length(B2 - B1);
    float dr = r2 - r1;
    float rmax = max(r2, r1);
    float rmin = min(r2, r1);
    float hmax = rmax * dr / dh;
    float hmin = rmin * dr / dh;
    vec3 B = sign(dr) * normalize(B2 - B1);
    vec3 Bmax = (r2 > r1? B2 : B1);
    vec3 B0 = Bmax - B * hmax;
    vec3 Bmin = Bmax - B * hmin;
    maybe_float end1 = get_distance_along_3d_line_to_circle(A0, A, Bmax, B, rmax);
    maybe_float end2 = get_distance_along_3d_line_to_circle(A0, A, Bmin, B, rmin);
    maybe_float cone = get_distance_along_3d_line_to_infinite_cone(A0, A, B0, B, cos(atan(rmax / hmax)));
    float c_h = dot(A0 + cone.value * A - B0, B);
    cone.exists = cone.exists && hmin <= c_h && c_h <= hmax;
    cone = get_distance_along_line_to_union(cone, end1);
    cone = get_distance_along_line_to_union(cone, end2);
    return cone;
}
