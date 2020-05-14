
/*
A0 point position
B0 rectangle center
R  rectangle length along each coordinate axis
*/
bool is_2d_point_in_axis_aligned_rectangle(in vec2 A0, in vec2 B0, in vec2 R)
{
    return all(lessThan(abs((A0-B0)/R), vec2(1)));
}
/*
A0 point position
B0 box center
B  box dimentsions
*/
float get_distance_of_2d_point_to_rectangle(in vec2 A0, in vec2 B0, in vec2 B)
{
  vec2 q = abs(B0) - B;
  return length(max(q,0.0)) + min(max(q.x,q.y),0.0);
}
/*
A0 point position
B0 rectangle center
R  rectangle length along each coordinate axis
*/
bool is_3d_point_in_axis_aligned_rectangle(in vec3 A0, in vec3 B0, in vec3 R)
{
    return all(lessThan(abs((A0-B0)/R), vec3(1)));
}