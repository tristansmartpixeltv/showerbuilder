uniform vec4 u_glassColor;
uniform sampler2D u_redAlbedoTex;
uniform vec2 u_redTiling;
uniform vec4 u_greenColor;
uniform vec4 u_blueColor;

void getAlbedo() {
    dAlbedo = mix(mix(mix(u_glassColor, texture2DSRGB(u_redAlbedoTex, $UV * u_redTiling), maskTex.r), u_greenColor, maskTex.g), u_blueColor, maskTex.b).rgb;
}