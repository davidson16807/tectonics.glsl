/*
"smooth.glsl" contains a small set of smooth, integrable variants of 
common glsl utility functions
*/
float smin(float a, float b, float k)
{
    return -log(exp(-a*k)+exp(-b*k))/k;
}
float smax(float a, float b, float k)
{
    return log(exp(a*k)+exp(b*k))/k;;
}
float sfloor(float x, float w)
{
	float x_b = x-0.5;
	return x_b - sin(2.0*PI*x_b)/(2.0*PI);
}
float sceil(float x, float w)
{
	float x_b = x+0.5;
	return x_b - sin(2.0*PI*x_b)/(2.0*PI);
}