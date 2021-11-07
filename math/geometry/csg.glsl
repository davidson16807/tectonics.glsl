
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
    /*
    There are 4 values to consider, which are the entrances and exits for positive and negative space.
    In comments, we denoted these values as x+, y+, x-, and y-,
     where x variables indicate entrances, and y variables indicate exits.
    There are 4*3*2*1 = 24 ways these 4 values could be sequenced along a number line,
     however we can ignore sequences where yp<xp and yn<xn.
    We can see all possible sequences that fulfill this condition using the following code, in python:
        [A for A in itertools.permutations(['x+','y+','x-','y-']) 
         if A.index('x+') < A.index('y+') and A.index('x-') < A.index('y-')]
    Combined with flags for whether positive/negative space exists along the ray, 
    This provides us with the following possibilities along with their output:
    
        input               output
                    exists        exists
        1  2  3  4  - +     x  y  
        *  *  *  *  F F     *  *  F
        *  *  *  *  T F     *  *  F
        *  *  *  *  F T     x+ y+ T
        x+ y+ x- y- T T     x+ y+ T
        x+ x- y+ y- T T     x+ x- T
        x+ x- y- y+ T T     x+ x- T
        x- x+ y+ y- T T     *  *  F
        x- x+ y- y+ T T     y- y+ T
        x- y- x+ y+ T T     x+ y+ T
        
    (NOTE: asterisks above indicate arbitrary values)

    */

    float xp = positive.value.x;
    float yp = positive.value.y;
    float xn = negative.value.x;
    float yn = negative.value.y;

    // as long as intersection with positive exists, 
    // and negative doesn't completely surround it, there will be an intersection
    if (!positive.exists || (xn < xp && yp < yn && negative.exists)){
        return maybe_vec2( vec2(xn, xn), false);
    }
    else if (!negative.exists || yn < xp){
        return positive;
    } 
    else if (xp < xn) {
        return maybe_vec2( vec2(min(yn, xp), min(xn, yp)), true);
    }
    else /*x- x+ y- y+*/{
        return maybe_vec2( vec2(yn, yp), true);
    } 
}

maybe_vec2 get_distances_along_line_to_intersection(
    in maybe_vec2 shape1,
    in maybe_vec2 shape2
) {
    float x = shape1.exists && shape2.exists ? max(shape1.value.x, shape2.value.x) : 0.0;
    float y  = shape1.exists && shape2.exists ? min(shape1.value.y,  shape2.value.y ) : 0.0;
    return maybe_vec2(vec2(x,y), shape1.exists && shape2.exists && x < y);
}
