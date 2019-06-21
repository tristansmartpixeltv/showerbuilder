#ifdef MAPCOLOR
uniform vec3 material_emissive;
#endif
#ifdef MAPFLOAT
uniform float material_emissiveIntensity;
#endif
#ifdef MAPTEXTURE
uniform sampler2D texture_emissiveMap;
#endif

uniform vec3 u_redColor;
uniform vec3 u_greenColor;
uniform vec3 u_blueColor;

uniform vec3 u_redPosition;
uniform vec3 u_greenPosition;
uniform vec3 u_bluePosition;

uniform float u_xyScale;
uniform float u_zScale;

uniform float u_lightIntensity;
uniform float u_colorPower;
uniform float u_colorScale;
uniform float u_ambientColor;

uniform vec3 u_color;

float lightMask_red;
float lightMask_green;
float lightMask_blue;

vec3 redColor;
vec3 greenColor;
vec3 blueColor;

vec3 getEmission() {
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
    
    lightMask_red = (1.0 - clamp(distance(vPositionW.xz, u_redPosition.xz) / u_xyScale, 0.0, 1.0)) * (1.0 - clamp(abs(vPositionW.y - u_redPosition.y) / u_zScale, 0.0, 1.0));
    lightMask_green = (1.0 - clamp(distance(vPositionW.xz, u_greenPosition.xz) / u_xyScale, 0.0, 1.0)) * (1.0 - clamp(abs(vPositionW.y - u_greenPosition.y) / u_zScale, 0.0, 1.0));
    lightMask_blue = (1.0 - clamp(distance(vPositionW.xz, u_bluePosition.xz) / u_xyScale, 0.0, 1.0)) * (1.0 - clamp(abs(vPositionW.y - u_bluePosition.y) / u_zScale, 0.0, 1.0));
    
    redColor = mix(u_redColor, vec3(1.0), clamp(pow(lightMask_red, u_colorPower) * u_colorScale, 0.0, 1.0));
    greenColor = mix(u_greenColor, vec3(1.0), clamp(pow(lightMask_green, u_colorPower) * u_colorScale, 0.0, 1.0));
    blueColor = mix(u_blueColor, vec3(1.0), clamp(pow(lightMask_blue, u_colorPower) * u_colorScale, 0.0, 1.0));
    
    emission += mix((lightMask_red * redColor * u_color.r) + (lightMask_green * greenColor * u_color.g) + (lightMask_blue * blueColor * u_color.b), u_color, u_ambientColor * (1.0 - u_color.r * u_color.g * u_color.b)) * u_lightIntensity;
    
    return emission;
    
}
