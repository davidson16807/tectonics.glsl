
maybe_float get_distance_along_line_to_union(
    in maybe_float shape1,
    in maybe_float shape2
) {
    return maybe_float(
        !shape1.exists ? shape2.value : !shape2.exists ? shape1.value : min(shape1.value, shape2.value),
        shape1.exists || shape2.exists
    );
}

maybe_vec2 get_distances_along_line_to_union(
    in maybe_vec2 shape1,
    in maybe_vec2 shape2
) {
    return maybe_vec2(
        vec2(!shape1.exists ? shape2.value.x : !shape2.exists ? shape1.value.x : min(shape1.value.x, shape2.value.x),
             !shape1.exists ? shape2.value.y  : !shape2.exists ? shape1.value.y  : max(shape1.value.y,  shape2.value.y )),
        shape1.exists || shape2.exists
    );
}


maybe_vec2 get_distances_along_line_to_negation(
    in maybe_vec2 positive,
    in maybe_vec2 negative
) {
    // as long as intersection with positive exists, 
    // and negative doesn't completely surround it, there will be an intersection
    bool exists = 
        positive.exists && !(negative.value.x < positive.value.x && positive.value.y < negative.value.y);
    // find the first region of intersection
    float entrance = !negative.exists ? positive.value.x : min(negative.value.y, positive.value.x);
    float exit     = !negative.exists ? positive.value.y : min(negative.value.x, positive.value.y);
    // if the first region is behind us, find the second region
    if (exit < 0. && 0. < positive.value.y)
    {
        entrance = negative.value.y;
        exit     = positive.value.y;
    }
    return maybe_vec2( vec2(entrance, exit), exists );
}


maybe_vec2 get_distances_along_line_to_intersection(
    in maybe_vec2 shape1,
    in maybe_vec2 shape2
) {
    float x = shape1.exists && shape2.exists ? max(shape1.value.x, shape2.value.x) : 0.0;
    float y  = shape1.exists && shape2.exists ? min(shape1.value.y,  shape2.value.y ) : 0.0;
    return maybe_vec2(vec2(x,y), shape1.exists && shape2.exists && x < y);
}
