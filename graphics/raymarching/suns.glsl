
// from Carl Hansen et al., "Stellar Interiors"
float get_temperature_of_star_at_fraction_of_radius(float fraction_of_radius, float core_temperature) 
{
    return max( core_temperature * (1.0 - fraction_of_radius*fraction_of_radius), 0.0 );
}
// TODO: support for light sources from within atmosphere
vec3 get_rgb_intensity_of_light_emitted_by_sun(
    vec3 view_origin, vec3 view_direction, float view_start_length, float view_stop_length, vec3 view_wavelengths,
    vec3 star_position, 
    float star_radius_temp0, //radius at which temperature is assumed 0
    float star_radius_beta, //radius at which beta_* values are sampled
    float star_core_temperature,
    float atmosphere_scale_height,
    vec3 beta_ray, vec3 beta_mie, vec3 beta_abs
){
    // For an excellent introduction to what we're try to do here, see Alan Zucconi: 
    //   https://www.alanzucconi.com/2017/10/10/atmospheric-scattering-3/
    // We will be using most of the same terminology and variable names.
    // GUIDE TO VARIABLE NAMES:
    //  Uppercase letters indicate vectors.
    //  Lowercase letters indicate scalars.
    //  Going for terseness because I tried longhand names and trust me, you can't read them.
    //  "*v*"    property of the view ray, the ray cast from the viewer to the object being viewed
    //  "*l*"    property of the light ray, the ray cast from the object to the light source
    //  "y*"     distance from the center of the world to the plane shared by view and light ray
    //  "z*"     distance from the center of the world to along the plane shared by the view and light ray 
    //  "r*"     a distance ("radius") from the center of the world
    //  "h*"     the atmospheric scale height, the distance at which air density reduces by a factor of e
    //  "*2"     the square of a variable
    //  "*0"     property at the start of the raymarch
    //  "*1"     property at the end of the raymarch
    //  "*i"     property during an iteration of the raymarch
    //  "d*"     the change in a property across iterations of the raymarch
    //  "beta*"  a scattering coefficient, the number of e-foldings in light intensity per unit distance
    //  "gamma*" a phase factor, the fraction of light that's scattered in a certain direction
    //  "sigma*" a column density ratio, the density of a column of air relative to surface density
    //  "F*"     fraction of source light that reaches the viewer due to scattering for each color channel
    //  "*_ray"  property of rayleigh scattering
    //  "*_mie"  property of mie scattering
    //  "*_abs"  property of absorption
    // setup variable shorthands
    // express all distances in scale heights 
    // express all positions relative to world origin
    float h = atmosphere_scale_height;
    vec3 V0 = (view_origin + view_direction * view_start_length - star_position) / h;
    vec3 V1 = (view_origin + view_direction * view_stop_length - star_position) / h;
    vec3 V = view_direction; // unit vector pointing to pixel being viewed
    float v0 = dot(V0,V);
    float v1 = dot(V1,V);
    // "beta_*" indicates the rest of the fractional loss.
    // it is dependant on wavelength, and the density ratio, which is dependant on height
    // So all together, the fraction of sunlight that scatters to a given angle is: beta(wavelength) * gamma(angle) * density_ratio(height)
    vec3 beta_sum = h*(beta_ray + beta_mie + beta_abs);
    // number of iterations within the raymarch
    const float STEP_COUNT = 32.;
    float dv = (v1 - v0) / STEP_COUNT;
    float vi = v0;
    float z2 = dot(V0,V0) - v0*v0;
    float sigma; // columnar density encountered along the entire path, relative to surface density, effectively the distance along the surface needed to obtain a similar column density
    vec3 F = vec3(0); // total intensity for each color channel, found as the sum of light intensities for each path from the light source to the camera
    for (float i = 0.; i < STEP_COUNT; ++i)
    {
        sigma = approx_air_column_density_ratio_through_atmosphere(v0, vi, z2, star_radius_beta);
        float temperature = get_temperature_of_star_at_fraction_of_radius(sqrt(vi*vi+z2) / star_radius_temp0, star_core_temperature);
        F += (
            // incoming scattered light: the intensity of light that goes towards the camera
            // I * exp(r-sqrt(vi*vi+y2+zv2)) * beta_gamma * dv 
            // newly created emitted light: the intensity of light that is generated by the parcel towards the camera
            + beta_abs * dv
              * 2.0 * PLANCK_CONSTANT * SPEED_OF_LIGHT*SPEED_OF_LIGHT / (view_wavelengths*view_wavelengths*view_wavelengths*view_wavelengths*view_wavelengths)
              * exp(star_radius_beta-sqrt(vi*vi+z2)) / (exp(PLANCK_CONSTANT * SPEED_OF_LIGHT/(view_wavelengths*BOLTZMANN_CONSTANT*temperature)) - 1.0) 
            )
            // outgoing scattered light: the fraction of light that scatters away from camera
            * exp(-beta_sum * sigma);
        vi += dv;
    }
    return F;
}
