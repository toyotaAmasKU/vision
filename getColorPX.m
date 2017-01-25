% Author : Supakit Kriangkhajorn
% Follow : skconan
function getColorPX()
    cam = webcam('USB2.0 VGA UVC WebCam');
    hmin = 1;
    hmax = 0;
    vmin = 1;
    vmax = 0;
    smin = 1;
    smax = 0;
    width = 640;
    height = 480;
    while true				
        img = snapshot(cam);
        hsv = rgb2hsv(img);

        figure(1); 
        imshow(hsv);

        [col, row] = ginput(1);
        disp(row(1));
        disp(col(1));
        if ~(0 <= row(1) && row(1) <= height && 0 <= col(1) && col(1) <= width)
            disp('1');
            continue
        end

        row = uint16(row);
        col = uint16(col);

        h = hsv(row, col, 1);
        s = hsv(row, col, 2);
        v = hsv(row, col, 3);

        if h <= hmin
            hmin = h;
        end
        if h >= hmax
            hmax = h;
        end
        if s <= smin
            smin = s;
        end
        if s >= smax
            smax = s;
        end
        if v <= vmin
            vmin = v;
        end
        if v >= vmax
            vmax = v;
        end

        fprintf('==========\n%d %d\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n',col,row,h,s,v,hmax,smax,vmax,hmin,smin,vmin);
        result = inrange_input(hsv,hmin,hmax,smin,smax,vmin,vmax);
        figure(2);
        imshow(result);
    end
end