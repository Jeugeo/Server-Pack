#moj_import <eg_custom_xp/util.glsl>
#moj_import <eg_custom_xp/config/xp_orb.glsl>

bool cxp_isExperienceOrb(vec4 col) {
    vec4 col255 = col * 255;
    return 0 <= col255.r && col255.r <= 255 &&
        254.5 <= col255.g && col255.g <= 255 &&
        0 <= col255.b && col255.b <= 51 &&
        127.7 <= col255.a && col255.a <= 128.3;
}

// takes the `Color` attribute in a vertex shader, GameTime, spherical vertex distance, and the main texture coordinates, then replaces it with an xp orb animation if applicable
vec4 cxp_applyXpOrbAnimation(vec4 rawVertexColour, float time, float sphericalDistance, vec2 texCoord) {
    if(!cxp_isExperienceOrb(rawVertexColour)) {
        return rawVertexColour;
    }

    vec4 gradient = vec4(0.);
    int colourArrayLength = XP_ORB_COLOURS.length();

    float random_offset = XP_ORB_RANDOM_OFFSET ? ( floor(texCoord.x * 4.) + floor(texCoord.y * 4.) ) / 9600. : 0.;

    float gradientrender_GRADIENT_ANIM = 0.;
    float animDirection = XP_ORB_REVERSE_ANIMATION_DIRECTION ? -1. : 1.;
    float animTime = (time + random_offset) * animDirection;
    switch ( XP_ORB_ANIMATION_MODE ) {
        case 0:
        // distance based
        gradientrender_GRADIENT_ANIM = fract(mod((animTime * (XP_ORB_ANIMATION_SPEED / float(colourArrayLength)) + (sphericalDistance/ XP_ORB_ANIMATION_COLOUR_PERIOD ) ), 2.) - 1.);
        break;
        case 2:
        // colour cycle
        gradientrender_GRADIENT_ANIM = fract(mod(animTime * (XP_ORB_ANIMATION_SPEED / float(colourArrayLength)), 2.) - 1.);
        break;
        case 3:
        // loop colour cycle
        gradientrender_GRADIENT_ANIM = abs(mod((animTime * (XP_ORB_ANIMATION_SPEED / float(colourArrayLength)) * 2.), 2.) - 1.);
    }
    
    for(int i = 0; i < colourArrayLength; i++) {
        float i_f = XP_ORB_ANIMATION_MODE == 3 ? float(i) - 1. : float(i);
        float len_f = XP_ORB_ANIMATION_MODE == 3 ? float(colourArrayLength) - 1. : float(colourArrayLength);
        
        float _step = XP_ORB_SMOOTH_MIX ? i_f/len_f : (i_f+0.5)/len_f;
        float _step2 = XP_ORB_SMOOTH_MIX ? (i_f+1.)/len_f : (i_f-0.5)/len_f;
        
        gradient = mix(
            i == 0 ? XP_ORB_COLOURS[colourArrayLength-1] : gradient,
            XP_ORB_COLOURS[i],
            XP_ORB_SMOOTH_MIX ? smoothstep(_step, _step2, gradientrender_GRADIENT_ANIM) : step(_step, gradientrender_GRADIENT_ANIM)
        );
    }

    return gradient;
}

// takes the vertex colour and sampled lightmap, then applies the lightmap if applicable
vec4 cxp_getLightingColour(vec4 rawVertexColour, vec4 sampledLightColour) {
    if(XP_ORB_EMISSIVE && cxp_isExperienceOrb(rawVertexColour)) {
        return vec4(1.0);
    }
    return sampledLightColour;
}