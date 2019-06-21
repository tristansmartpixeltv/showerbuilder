uniform sampler2D u_maskTex;
vec4 maskTex;

uniform sampler2D u_glassNormalTex;
uniform float u_glassNormalScale;
uniform vec2 u_glassNormalTiling;

uniform sampler2D u_redNormalTex;
uniform float u_redNormalScale;
uniform vec2 u_redNormalTiling;

uniform float material_bumpiness;

vec3 glassNormalMap;
vec3 redNormalMap;



void getNormal() {
    
    maskTex = texture2D(u_maskTex, $UV);
    
    glassNormalMap = unpackNormal(texture2D(u_glassNormalTex, $UV * u_glassNormalTiling));
    redNormalMap = unpackNormal(texture2D(u_redNormalTex, $UV * u_redNormalTiling));
    
    glassNormalMap = normalize(mix(vec3(0.0, 0.0, 1.0), glassNormalMap, u_glassNormalScale * (1.0 - maskTex.g) * (1.0 - maskTex.b)));
    redNormalMap = normalize(mix(vec3(0.0, 0.0, 1.0), redNormalMap, u_redNormalScale));
    
    dNormalMap = mix(glassNormalMap, redNormalMap, maskTex.r);
    dNormalW = dTBN * dNormalMap;
}