% Author : Supakit Kriangkhajorn
% Follow me : skconan
% Add hh variable for range of red color

function y = inrange_input(hsv,hmin,hmax,smin,smax,vmin,vmax)
    h = hsv(:,:,1) >= 0.88 & hsv(:,:,1) <= hmax;
    hh = hsv(:,:,1) >= 0 & hsv(:,:,1) <= 0.12;
    h = hh | h;
    s = hsv(:,:,2) >= smin+0.05 & hsv(:,:,2) <= smax;
    v = hsv(:,:,3) >= vmin & hsv(:,:,3) <= vmax;
    result = h & s & v;
y = uint8(result)*255;  