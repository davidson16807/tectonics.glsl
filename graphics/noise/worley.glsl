
float get_2d_worley_noise(vec2 position, mat3 position_seed)
{
    vec2 index = floor(position);
        
    float nearest_distance = 1e20;
    vec2  neighbor_index = vec2(0);
    vec2  neighbor_position = vec2(0);
    
    for (int x = -1; x <= 1; x++)
    {
        for (int y = -1; y <= 1; y++)
        {
            neighbor_index = index + vec2(x, y);
            neighbor_position = neighbor_index + noise3(position_seed * neighbor_index);
            
            nearest_distance = min(nearest_distance, distance(position, neighbor_position));
        }
    }
    
    return clamp(nearest_distance, 0.0, 1.0);
}

float get_3d_worley_noise(vec3 position, mat3 position_seed)
{
    vec3 index = floor(position);
        
    float nearest_distance = 1e20;
    vec3  neighbor_index = vec3(0);
    vec3  neighbor_position = vec3(0);
    
    for (int x = -1; x <= 1; x++)
    {
        for (int y = -1; y <= 1; y++)
        {
            for (int z = -1; z <= 1; z++)
            {   
                neighbor_index = index + vec3(x, y, z);
                neighbor_position = neighbor_index + noise3(position_seed * neighbor_index);
                
                nearest_distance = min(nearest_distance, distance(position, neighbor_position));
            }
        }
    }
    
    return clamp(nearest_distance, 0.0, 1.0);
}

float get_4d_worley_noise(vec4 position, mat4 position_seed)
{
    vec4 index = floor(position);
        
    float nearest_distance = 1e20;
    vec4  neighbor_index = vec4(0);
    vec4  neighbor_position = vec4(0);
    
    for (int x = -1; x <= 1; x++)
    {
        for (int y = -1; y <= 1; y++)
        {
            for (int z = -1; z <= 1; z++)
            {   
                for (int w = -1; w <= 1; w++)
                {   
                    neighbor_index = index + vec4(x, y, z, w);
                    neighbor_position = neighbor_index + noise4(position_seed * neighbor_index);

                    nearest_distance = min(nearest_distance, distance(position, neighbor_position));
                }
            }
        }
    }
    
    return clamp(nearest_distance, 0.0, 1.0);
}
