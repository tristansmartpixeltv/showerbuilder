varying vec2 v_UV;
varying vec3 v_Position;
varying vec3 v_Normal;

uniform mat3 matrix_normal;

uniform vec3 u_lightDirection;
uniform float u_time;

uniform sampler2D u_poolColorTex;
uniform vec2 u_poolColorTiling;
uniform vec4 u_lightColor;
uniform vec4 u_ambientColor;

uniform sampler2D u_causticsTex;
uniform vec2 u_causticsTiling;
uniform vec2 u_causticsVelocity1;
uniform vec2 u_causticsVelocity2;
uniform float u_causticsPower;
uniform vec4 u_causticsColor;

uniform sampler2D u_refractionTex;
uniform vec2 u_refractionTiling;
uniform vec2 u_refractionVelocity;
uniform float u_refraction;
uniform float u_normalRefraction;

vec3 normalDirection;
float normalLighting;
vec4 poolColorTex;
vec4 poolColor;
float causticsMask;
vec2 refractedUV;
vec2 refractionMap;

void main() {
    
    refractionMap = texture2D(u_refractionTex, v_UV * u_refractionTiling + u_time * u_refractionVelocity).rg;
    refractedUV = v_UV + refractionMap * u_refraction;
    
    normalDirection = normalize(matrix_normal * v_Normal + vec3(refractionMap.r, refractionMap.g, refractionMap.r) - vec3(0.5) * u_normalRefraction);
    normalLighting = clamp(dot(normalDirection, u_lightDirection), 0.0, 0.5);
    
    poolColorTex = texture2D(u_poolColorTex, refractedUV * u_poolColorTiling);
    poolColor = poolColorTex * u_ambientColor + vec4(normalLighting) * poolColorTex * u_lightColor;
    
    causticsMask = texture2D(u_causticsTex, refractedUV * u_causticsTiling + u_time * u_causticsVelocity1).r + texture2D(u_causticsTex, refractedUV * u_causticsTiling + u_time * u_causticsVelocity2).r;
    causticsMask = pow(causticsMask, u_causticsPower);
    
    poolColor += (vec4(causticsMask) * u_causticsColor);
    
    gl_FragColor = poolColor;
}
