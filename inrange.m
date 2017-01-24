% Author : Supakit Kriangkhajorn
% skconan
function y = inrange(hsv,color)
    lower0 = [0,0,0];
    upper0 = [1,1,1];

    switch color
        case uint8('o')
            lower0 = [0/180,0,0];
            upper0  = [22/180,1,1];
        case uint8('y')
            lower0 = [23/180,0,0];
            upper0  = [38/180,1,1];
        case uint8('g')
            lower0 = [39/180,0,0];
            upper0  = [75/180,1,1];
        case uint8('b')
            lower0 = [76/180,0,0];
            upper0  = [130/180,1,1];
        case uint8('v')
            lower0 = [131/180,0,0];
            upper0  = [160/180,1,1];
        case uint8('r')
            lower0 = [0.88,0.5,0.5];
            upper0 = [1,1,1];

    end
  
    h = hsv(:,:,1) >= lower0(1) & hsv(:,:,1) <= upper0(1);
    s = hsv(:,:,2) >= lower0(2) & hsv(:,:,2) <= upper0(2);
    v = hsv(:,:,3) >= lower0(3) & hsv(:,:,3) <= upper0(3);
    
    result = h & s & v;
    
y = uint8(result)*255;  