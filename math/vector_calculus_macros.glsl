#define GRADIENT(f) vec3( \
	f(x+dx*i)-f(x),       \
	f(x+dx*j)-f(x),       \
	f(x+dx*k)-f(x)        \
) / dx
#define VECTOR_GRADIENT(f) mat3(                                \
	f(x+dx*i).x-f(x).x,	f(x+dx*i).y-f(x).y,	f(x+dx*i).z-f(x).z, \
	f(x+dx*j).x-f(x).x, f(x+dx*j).y-f(x).y, f(x+dx*j).z-f(x).z, \
	f(x+dx*k).x-f(x).x, f(x+dx*k).y-f(x).y, f(x+dx*k).z-f(x).z  \
) / dx                                                           
#define DIVERGENCE(f) (    \
	(f(x+dx*i).x-f(x).x) + \
	(f(x+dx*j).y-f(x).y) + \
	(f(x+dx*k).z-f(x).z)   \
) / dx
#define MATRIX_DIVERGENCE(f) vec3(	                                                      \
	(f(x+dx*i)[0].x-f(x)[0].x) + (f(x+dx*j)[1].x-f(x)[1].x) + (f(x+dx*k)[2].x-f(x)[2].x), \
	(f(x+dx*i)[0].y-f(x)[0].y) + (f(x+dx*j)[1].y-f(x)[1].y) + (f(x+dx*k)[2].y-f(x)[2].y), \
	(f(x+dx*i)[0].z-f(x)[0].z) + (f(x+dx*j)[1].z-f(x)[1].z) + (f(x+dx*k)[2].z-f(x)[2].z)  \ 
) / dx
vec3 curl(vec3 gx, vec3 gxdxi, vec3 gxdxj, vec3 gxdxk){
  vec3 dgdx = (gxdxi-gx) / dx;
  vec3 dgdy = (gxdxj-gx) / dx;
  vec3 dgdz = (gxdxk-gx) / dx;
  return 
    vec3(
        dgdy.z - dgdz.y,
        dgdz.x - dgdx.z,
        dgdx.y - dgdy.x
      );
}
#define CURL(f) curl(f(x), f(x+dx*i), f(x+dx*j), f(x+dx*k))
