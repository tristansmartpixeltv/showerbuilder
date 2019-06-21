uniform float u_glassMetal;
uniform float u_redMetal;
uniform float u_greenMetal;
uniform float u_blueMetal;


void processMetalness(float metalness) {
    const float dielectricF0 = 0.04;
    dSpecularity = mix(vec3(dielectricF0), dAlbedo, metalness);
    dAlbedo *= 1.0 - metalness;
}


void getSpecularity() {
    float metalness = mix(mix(mix(u_glassMetal, u_redMetal, maskTex.r), u_greenMetal, maskTex.g), u_blueMetal, maskTex.b);
    processMetalness(metalness);
}