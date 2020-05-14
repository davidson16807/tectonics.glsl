
/*
A0 point position
B0 ellipsoid center
R  radius
*/
bool is_3d_point_in_ellipsoid(in vec3 A0, in vec3 B0, in vec3 R)
{
    return length((A0-B0)/R) < 1.0;
}
/*
A0 point position
B0 ellipsoid center
R  ellipsoid radius along each coordinate axis
*/
float guess_distance_of_3d_point_to_ellipsoid(in vec3 A0, in vec3 B0, in vec3 R)
{
    vec3  V  = A0-B0;
    float u = length(V/R);
    float v = length(V/(R*R));
    return u*(u-1.0)/v;
}
/*
A0 point position
B0 ellipsoid center
R  ellipsoid radius along each coordinate axis
*/
vec3 guess_surface_normal_of_point_near_ellipsoid(in vec3 A0, in vec3 B0, in vec3 R)
{
    vec3  V  = A0-B0;
    return normalize( V/R );
}
/*
A0 line reference
A  line direction, normalized
B0 ellipsoid center
R  ellipsoid radius along each coordinate axis
*/

maybe_float get_distance_along_3d_line_to_ellipsoid(
    in vec3 A0,
    in vec3 A,
    in vec3 B0,
    in vec3 R
){
    // NOTE: shamelessly copy pasted, all credit goes to Inigo: 
    // https://www.iquilezles.org/www/articles/intersectors/intersectors.htm
    vec3 Or = (A0 - B0) / R;
    vec3 Ar = A / R;
    float ArAr = dot(Ar, Ar);
    float OrAr = dot(Or, Ar);
    float OrOr = dot(Or, Or);
    float h = OrAr * OrAr - ArAr * (OrOr - 1.0);
    return maybe_float(
        (-OrAr - sqrt(h)) / ArAr, 
        h >= 0.0
    );
}
