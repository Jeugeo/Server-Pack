#moj_import <eg_custom_xp/util.glsl>
#moj_import <eg_custom_xp/config/xp_text.glsl>

// takes the `Color` attribute in a vertex shader, and replaces it with an xp text colour if applicable
vec4 cxp_applyXpTextColour(vec4 rawVertexColour) {
    vec3 newCol = rawVertexColour.rgb;
    switch (toint(newCol)) {
        case 0x80ff20:
            newCol = XP_TEXT_MAIN_COLOUR;
        break;
        case 0x203f08:
            newCol = XP_TEXT_SHADOW_COLOUR;
        break;
        case 0x407f10:
            newCol = XP_TEXT_MAIN_COLOUR;
            newCol *= 0.7;
        break;
        case 0x101f04:
            newCol = XP_TEXT_SHADOW_COLOUR;
            newCol *= 0.7;
        break;
        default:
            newCol = rawVertexColour.rgb;
        break;
    }
    return vec4(newCol, rawVertexColour.a);
}