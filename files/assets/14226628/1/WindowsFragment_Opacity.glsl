uniform sampler2D u_maskTex_opacity;
vec4 maskTex_opacity;

uniform float u_glassOpacity;
uniform float u_cuttingHeight;

float cuttingHeight;

void getOpacity() {
    maskTex_opacity = texture2D(u_maskTex_opacity, $UV);
    
    cuttingHeight = ceil (clamp (u_cuttingHeight - vPositionW.y, 0.0, 1.0));
    
    dAlpha = clamp(cuttingHeight, 0.0, u_glassOpacity + maskTex_opacity.r + maskTex_opacity.g + maskTex_opacity.b);
}