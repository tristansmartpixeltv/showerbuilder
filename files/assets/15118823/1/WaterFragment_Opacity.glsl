uniform sampler2D u_opacityTex;
uniform vec2 u_opacityTiling;
uniform float u_opacityScale;
uniform vec2 u_opacitySpeed1;
uniform vec2 u_opacitySpeed2;

uniform float u_fresnelPower;
uniform float u_fresnelScale;
uniform float u_fresnelBias;

uniform float u_minHeight;
uniform float u_maxHeight;
uniform float u_minHeightOpacity;

void getOpacity() {
    
    dViewDirW = normalize(view_position - vPositionW);
    
    float fresnel = clamp(pow(1.0 - max(dot(vNormalW, dViewDirW), 0.0), u_fresnelPower) * u_fresnelScale + u_fresnelBias, 0.0, 1.0);
    float heightOpacity = mix(u_minHeightOpacity, u_opacityScale, clamp((vPositionW.y - u_minHeight) / (u_maxHeight - u_minHeight), 0.0, 1.0));
    
    dAlpha = clamp((texture2D(u_opacityTex, $UV * u_opacityTiling + u_time * u_opacitySpeed1).r + texture2D(u_opacityTex, $UV * u_opacityTiling + u_time * u_opacitySpeed2).r) * heightOpacity * fresnel, 0.0, 1.0);
}
