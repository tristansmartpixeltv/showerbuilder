#ifdef MAPCOLOR
uniform vec3 material_emissive;
#endif
#ifdef MAPFLOAT
uniform float material_emissiveIntensity;
#endif
#ifdef MAPTEXTURE
uniform sampler2D texture_emissiveMap;
#endif

uniform float u_fresnelScale;
uniform float u_fresnelPower;
uniform float u_fresnelBias;

uniform vec4 u_fogColor;

vec3 getEmission() {
    
    
    float fresnel = clamp(pow(1.0 - max(dot(dNormalW, dViewDirW), 0.0), u_fresnelPower) * u_fresnelScale + u_fresnelBias, 0.0, 1.0);
    
    
    vec3 emission = vec3(1.0);
    #ifdef MAPFLOAT
    emission *= material_emissiveIntensity;
    #endif
    #ifdef MAPCOLOR
    emission *= material_emissive;
    #endif
    #ifdef MAPTEXTURE
    emission *= $texture2DSAMPLE(texture_emissiveMap, $UV).$CH;
    #endif
    #ifdef MAPVERTEX
    emission *= gammaCorrectInput(saturate(vVertexColor.$VC));
    #endif
    
    emission += vec3(fresnel);
    
    return emission;
}
