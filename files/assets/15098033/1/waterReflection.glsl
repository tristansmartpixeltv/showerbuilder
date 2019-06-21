
uniform sampler2D u_reflectionBuffer;
uniform vec2 u_screenSpaceUVTiling;
uniform vec2 u_screenSpaceUVOffset;
uniform vec3 u_cameraPosition;
uniform float u_reflectionDeformScale;

varying vec4 v_screenPosition;

void addReflection() {
    
    dReflection += vec4(texture2DSRGB(u_reflectionBuffer, v_screenPosition.xy * u_screenSpaceUVTiling * (500.0 / distance(u_cameraPosition, vPositionW)) + u_screenSpaceUVOffset + blendedNormalMap.xy * u_reflectionDeformScale).rgb, 1.0);
}

