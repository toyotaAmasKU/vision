% Author : Supakit Kriangkhajorn
% Follow me : skconan
function y = inrange_input(hsv,hmin,hmax,smin,smax,vmin,vmax)
    
    h = hsv(:,:,1) >= hmin & hsv(:,:,1) <= hmax;
    s = hsv(:,:,2) >= smin & hsv(:,:,2) <= smax;
    v = hsv(:,:,3) >= vmin & hsv(:,:,3) <= vmax;
    
    result = h & s & v;
    
y = uint8(result)*255;  