
float get_angular_radius_of_sphere_at_distance_alternate(
	in float sphere_radius, in float sphere_distance
){
	float r = sphere_radius;
	float h = sphere_distance;
	// "a2": squared distance to the tangent point, found using pythagorean theorem, 
	// scaled so hypoteneuse = 1
	float a2 = 1.0-r*r/(h*h);
	return r * sqrt(a2) / (h * a2);
}
float get_area_of_intersection_between_circle_and_circle(
	in float circle1_radius, in float circle2_radius, in float circle_origin_distance
){
	/*
	NOTE: see here for an explanation:
	https://www.xarg.org/2016/07/calculate-the-intersection-area-of-two-circles/
	*/
	float d = circle_origin_distance;
	float R = max(circle1_radius, circle2_radius);
	float r = min(circle1_radius, circle2_radius);
	if (d>=r+R)
	{
		return 0.0;
	}
	else if (d+r<=R)
	{
		return PI*r*r;
	}
	else 
	{
		const float EPSILON = 1e-8;
		float X = (R*R-r*r+d*d)/(2.0*d);
		float y = sqrt(R*R-X*X);
		float x = abs(d-X);//sqrt(r*r-y*y);
		float theta = asin(min(y/r, 1.0-EPSILON));
		float Theta = asin(min(y/R, 1.0-EPSILON));
		float a = r*r*theta - x*y;
		float A = R*R*Theta - X*y;
		return A + d>=X? a:PI*r*r-a;
	}
}
/*
Assumes the light source and occlusion are distant enough that they can be 
treated as circles on a 2d plane
*/
float get_fraction_of_sphere_not_occluded_by_sphere(
	in vec2 light_destination, in vec2 light_origin, in float light_radius, 
	in vec2 sphere_origin, in float sphere_radius
){
    const float EPSILON = 3e-8;
	// direction of light origin from destination
	vec2  light_direction  = normalize(light_origin-light_destination);
	float light_distance   = length(light_origin-light_destination);
	// direction of sphere origin from destination
	vec2  sphere_direction = normalize(sphere_origin-light_destination);
	float sphere_distance  = length(sphere_origin-light_destination);
	float cos_angular_separation = dot(light_direction, sphere_direction);
	// angular separation between light and sphere origins when viewed from destination
    if (light_distance < sphere_distance) return 1.0;
    if (cos_angular_separation <= 0.0) return 1.0;
    if (sphere_distance < sphere_radius) return 0.0;
	float angular_separation = acos(min(cos_angular_separation, 1.0-EPSILON));
	float angular_light_radius  = asin(min(light_radius/light_distance, 1.0-EPSILON));
	float angular_sphere_radius = asin(min(sphere_radius/sphere_distance, 1.0-EPSILON));
	// distance between light and sphere origins when viewed from destination, 
	// treating the two as circles on a 2d plane
	float angular_distance = angular_separation; //min(2.0 * tan(angular_separation / 2.0), 2.);
	float area = get_area_of_intersection_between_circle_and_circle(
		angular_light_radius, angular_sphere_radius, angular_distance
	);
	return 1.0 - area / (PI*angular_light_radius*angular_light_radius);
}
