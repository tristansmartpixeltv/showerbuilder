varying vec2 v_UV;
varying vec3 v_Position;
varying vec3 v_Normal;

uniform mat3 matrix_normal;

uniform float u_height;
uniform vec3 u_lightDirection;
uniform float u_time;

uniform vec4 u_horizonColor;
uniform vec4 u_zenithColor;
uniform float u_horizonPower;

uniform vec4 u_backlitColor;
uniform float u_backlitPower;

uniform vec4 u_litColor;
uniform float u_litPower;

uniform vec4 u_fogColor;
uniform float u_fogStart;
uniform float u_fogEnd;
uniform float u_fogPower;

uniform sampler2D u_cloudsTex;
uniform vec4 u_cloudColor;
uniform vec2 u_cloudVelocity;
uniform vec2 u_cloudTiling;
uniform float u_cloudStart;
uniform float u_cloudEnd;
uniform vec2 u_secondCloudVelocity;
uniform vec2 u_secondCloudTiling;
uniform vec2 u_thirdCloudVelocity;
uniform vec2 u_thirdCloudTiling;
uniform vec2 u_coverageCloudVelocity;
uniform vec2 u_coverageCloudTiling;
uniform float u_coverageCloudPower;
uniform float u_coverageCloudScale;
uniform float u_speed;
uniform float u_sunRadius;
uniform float u_sunGlow;
uniform vec4 u_sunColor;
uniform vec4 u_cloudLightColor;
uniform float u_cloudSoftness;
uniform float u_cloudScattering;

vec3 normalDirection;
float normalLighting;
vec3 horizonGradient;
vec3 backlitGradient;
vec3 litGradient;
float scaledTime;
float cloudsMask;
float volumeCloudMask;
vec3 rimLightCloudsColor;
vec3 cloudLayer;
vec3 fogGradient;
vec3 sun;

void main() {
    
    normalDirection = normalize(matrix_normal * v_Normal);
    normalLighting = dot(normalDirection, u_lightDirection) * 0.5 + 0.5;
    
    horizonGradient = mix(u_horizonColor.rgb, u_zenithColor.rgb, pow(clamp(v_Position.z / u_height, 0.0, 10000.0), u_horizonPower));    
    backlitGradient = horizonGradient + u_backlitColor.rgb * pow((1.0 - normalLighting), u_backlitPower) * u_backlitColor.a;
    litGradient = mix(backlitGradient, u_litColor.rgb, pow(normalLighting, u_litPower) * u_litColor.a);
    
    scaledTime = u_time * u_speed;
    
    cloudsMask = texture2D(u_cloudsTex, v_UV * u_cloudTiling + scaledTime * u_cloudVelocity).r;
    cloudsMask *= texture2D(u_cloudsTex, v_UV * u_secondCloudTiling + scaledTime * u_secondCloudVelocity).r;
    cloudsMask -= pow(texture2D(u_cloudsTex, v_UV * u_coverageCloudTiling + scaledTime * u_coverageCloudVelocity).g * u_coverageCloudScale, u_coverageCloudPower);
    cloudsMask = clamp(cloudsMask, 0.0, 1.0);
    cloudsMask += texture2D(u_cloudsTex, v_UV * u_thirdCloudTiling + scaledTime * u_thirdCloudVelocity).b * 0.25;
    cloudsMask = clamp(cloudsMask, 0.0, 1.0);
    
    volumeCloudMask = clamp(cloudsMask - u_cloudSoftness, 0.0, 1.0) / (1.0 - u_cloudSoftness);
    
    rimLightCloudsColor = mix(u_cloudColor.rgb, u_cloudLightColor.rgb, 1.0 - normalLighting);
    
    cloudLayer = mix(litGradient, rimLightCloudsColor, cloudsMask * u_cloudColor.a * clamp(((v_Position.z - u_cloudStart) / (u_cloudEnd - u_cloudStart)), 0.0, 1.0));
    cloudLayer = mix(cloudLayer, u_cloudLightColor.rgb, normalLighting * u_cloudLightColor.a * volumeCloudMask);
    cloudLayer = mix(cloudLayer, u_cloudColor.rgb, clamp(volumeCloudMask * (1.0 - normalLighting) - u_cloudScattering, 0.0, 1.0));
    
    fogGradient = cloudLayer + pow((1.0 - (clamp((v_Position.z - u_fogStart) / (u_fogEnd - u_fogStart), 0.0, 1.0))), u_fogPower) * u_fogColor.a;
    
    sun = vec3(ceil((1.0 - normalLighting) - (1.0 - u_sunRadius)));
    sun += u_sunColor.rgb * clamp(pow(1.0 - normalLighting, u_sunGlow), 0.0, 1.0);
    
    
    
    gl_FragColor = vec4(fogGradient + sun, 1.0);
}