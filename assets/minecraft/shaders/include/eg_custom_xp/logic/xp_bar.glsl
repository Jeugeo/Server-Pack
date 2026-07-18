#moj_import <eg_custom_xp/util.glsl>
#moj_import <eg_custom_xp/config/xp_bar.glsl>

// takes the raw texture colour, and GameTime to apply the animated xp bar effect if enabled
vec4 cxp_applyXpBarAnimation(vec4 rawTextureColour, float time) {
    if(!(inrange(rawTextureColour.b, 1./255., 6./255.) && rougheq(rawTextureColour.a, 191./255.))) {
        return rawTextureColour;
    }

    float gradientBrightness = rawTextureColour.r;
    
    float animDirection = XP_BAR_REVERSE_ANIMATION_DIRECTION ? -1. : 1.;
    float animTime = time * animDirection;
    float animCoord = 0.;
    vec2 barCoord = vec2(rawTextureColour.g, rawTextureColour.b);
    
    switch (XP_BAR_ANIMATION_MODE) {
    case 0:
        animCoord = barCoord.y;
        break;
    case 1:
        animCoord = barCoord.x;
        break;
    case 2:
        animCoord = barCoord.x - barCoord.y;
        break;
    case 3:
        animCoord = barCoord.x + barCoord.y;
        break;
    case 4:
        animCoord = abs(barCoord.x - 0.5);
        break;
    default:
        break;
    }
    int colourArrayLength = XP_BAR_COLOURS.length();
    float gradientrender_GRADIENT_ANIM = fract(mod( (animTime * ( XP_BAR_ANIMATION_SPEED / float(colourArrayLength) ) + ( animCoord / ( (XP_BAR_ANIMATION_COLOUR_PERIOD / 18.) ) ) ), 2.) - 1.);
    
    vec4 gradient = vec4(0.);

    float len = float(colourArrayLength);
    for(int i = 0; i < colourArrayLength; i++){
        float _step = XP_BAR_SMOOTH_MIX ? float(i)/len : (float(i)+0.5)/len;
        float _step2 = XP_BAR_SMOOTH_MIX ? (float(i)+1.)/len : (float(i)-0.5)/len;

        gradient = mix(
            i == 0 ? XP_BAR_COLOURS[colourArrayLength-1] : gradient,
            XP_BAR_COLOURS[i],
            XP_BAR_SMOOTH_MIX ? smoothstep(_step, _step2, gradientrender_GRADIENT_ANIM) : step(_step, gradientrender_GRADIENT_ANIM)
        );
    }

    return vec4(vec3(gradientBrightness) * gradient.rgb, 1.);
}
