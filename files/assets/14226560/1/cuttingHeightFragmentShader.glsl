uniform float u_cuttingHeight;    
                        
void getOpacity() {
    
    dAlpha = ceil (clamp (u_cuttingHeight - vPositionW.y, 0.0, 1.0));
}