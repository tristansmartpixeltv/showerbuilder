


uniform sampler2D u_normalTex;
uniform float u_normalScale;
uniform float u_time;
uniform vec2 u_speed1;
uniform vec2 u_speed2;
vec3 blendedNormalMap;

uniform float material_bumpiness;

vec3 blendNormals(vec3 a, vec3 b, float normalScale) {
    return normalize(mix(a, b, -normalScale));
}

void getNormal() {

    vec3 normalMap1 = unpackNormal(texture2D(u_normalTex, $UV + u_speed1 * u_time));
    vec3 normalMap2 = unpackNormal(texture2D(u_normalTex, $UV + u_speed2 * u_time));
    
    blendedNormalMap = blendNormals(normalMap1, normalMap2, 1.0);
    
    dNormalMap = blendedNormalMap;
    blendedNormalMap = normalize(mix(vec3(0.0, 0.0, 1.0), blendedNormalMap, -u_normalScale));
    dNormalW = dTBN * blendedNormalMap;
}
