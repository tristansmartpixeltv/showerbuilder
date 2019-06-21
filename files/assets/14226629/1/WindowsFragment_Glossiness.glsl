
uniform float u_glassGloss;
uniform sampler2D u_redGlossTex;
uniform float u_greenGloss;
uniform float u_blueGloss;

void getGlossiness() {    
    dGlossiness = mix(mix(mix(u_glassGloss, texture2D(u_redGlossTex, $UV * u_redTiling).r, maskTex.r), u_greenGloss, maskTex.g), u_blueGloss, maskTex.b);
}
