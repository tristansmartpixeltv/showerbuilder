#define C_PI 3.1415926535897932384626433832795

float atan2(vec2 pt) {
    if (pt.x > 0.0) {
        return atan(pt.y / pt.x);
    }
    else if (pt.x < 0.0 && pt.y >= 0.0) {
        return atan(pt.y / pt.x) + C_PI;
    }
    else if (pt.x < 0.0 && pt.y < 0.0) {
        return atan(pt.y / pt.x) - C_PI;
    }
    else if (pt.x == 0.0 && pt.y > 0.0) {
        return atan(pt.y / pt.x) + (C_PI / 2.0);
    }
    else if (pt.x == 0.0 && pt.y < 0.0) {
        return atan(pt.y / pt.x) - (C_PI / 2.0);
    }
    else {
        return -1.0;
    }
}

float findAngle(vec2 pt1, vec2 pt2) {
    return atan2(pt2 - pt1);
}

vec2 rotatePoint(vec2 pt, vec2 origin, float angle) {
    float localAngle = findAngle(origin, pt);
    return origin + vec2(cos(localAngle + angle) * (distance(pt, origin)), sin(localAngle + angle) * (distance(pt, origin)));
}

#ifdef MAPCOLOR
uniform vec3 material_diffuse;
#endif
#ifdef MAPTEXTURE
uniform sampler2D texture_diffuseMap;
#endif

uniform sampler2D texture_detailMap;
uniform vec2 detailUV;
uniform float detailScale;
uniform float detailBias;
uniform int blendingMode;
uniform float xAngle;
uniform float yAngle;
uniform float zAngle;

vec4 detailMap;
vec4 scaledDetailMap;
vec2 worldUV;

void getAlbedo() {
    
    dAlbedo = vec3(1.0);
    #ifdef MAPCOLOR
    dAlbedo *= material_diffuse.rgb;
    #endif
    #ifdef MAPTEXTURE
    dAlbedo *= texture2DSRGB(texture_diffuseMap, $UV).$CH;
    #endif
    #ifdef MAPVERTEX
    dAlbedo *= gammaCorrectInput(saturate(vVertexColor.$VC));
    #endif
    
    if (vNormalW.z > 0.5 || vNormalW.z < -0.5) {
        worldUV = vPositionW.xy;
        worldUV = rotatePoint(worldUV, vec2(0.0), zAngle);
    }
    if (vNormalW.y > 0.5 || vNormalW.y < -0.5) {
        worldUV = vPositionW.xz;
        worldUV = rotatePoint(worldUV, vec2(0.0), yAngle);
    }
    if (vNormalW.x > 0.5 || vNormalW.x < -0.5) {
        worldUV = vPositionW.yz;
        worldUV = rotatePoint(worldUV, vec2(0.0), xAngle);
    }
    worldUV *= detailUV;
    
    detailMap = texture2DSRGB(texture_detailMap, worldUV);
    scaledDetailMap = detailMap * detailScale;
    scaledDetailMap += detailBias;
    
    
    if (blendingMode == 0) {
        dAlbedo *= clamp(scaledDetailMap.rgb, 0.0, 1.0);
    }
    else if (blendingMode == 1) {
        dAlbedo += scaledDetailMap.rgb;
    }
    else
    {
        dAlbedo = mix(dAlbedo, detailMap.rgb, clamp(detailMap.a * detailScale + detailBias, 0.0, 1.0));
    }
    dAlbedo = clamp(dAlbedo, 0.0, 1.0);
}