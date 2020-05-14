
/*
A0 point position
B0 ellipsis center
R  ellipsis radius along each coordinate axis
*/
bool is_2d_point_in_ellipsis(in vec2 A0, in vec2 B0, in vec2 R)
{
    return length((A0-B0)/R) < 1.0;
}
/*
A0 point position
B0 ellipsis center
R  ellipsis radius along each coordinate axis
*/
float guess_distance_of_2d_point_to_ellipsis(in vec2 A0, in vec2 B0, in vec2 R)
{
    float u = length((A0-B0)/R);
    float v = length((A0-B0)/(R*R));
    return u*(u-1.0)/v;
}