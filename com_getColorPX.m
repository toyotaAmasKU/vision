% Author : Supakit Kriangkhajorn
% Follow : skconan

function pi_getColorPX()
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    load_inrange();
    ip = '192.168.1.118';
    username = 'pi';
    password = 'raspberry';
    
%   main
    [rpi,cam] = connection(ip,username,password);
    
    width = 320;
    height = 240;
    
    cam.Rotation = 270;
    cam.HorizontalFlip = true;
    while true	
        
        img = snapshot(cam); 
        hsv = rgb2hsv(img);
        
        result = inrange_input(hsv,hmin,hmax,smin,smax,vmin,vmax);
        figure(2);
        imshow(result);
        
        figure(1); 
        imshow(hsv);
        
        
        [col, row, btn] = ginput(1);
               
        if ~(0 <= row(1) && row(1) <= height && 0 <= col(1) && col(1) <= width) && btn == 1
            continue
        end

        row = int16(row);
        col = int16(col);
        
        if btn == 'r'
            reset_inrange();
        elseif btn == 's'
            save inrange.mat hmin hmax smin smax vmin vmax -v7.3;
        elseif btn == 'l'
            load_inrange();
        else
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
        end
        
        
        
    end
end

function [rpi,cam] = connection(ip,username,password)
        rpi = raspi(ip,username,password);
        cam = cameraboard(rpi, 'Resolution', '320x240');
        disp(rpi.BoardName);
        disp(cam.Name)
end
    
function load_inrange()
    inrange = matfile('inrange.mat');
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    disp('init_inrange');
    hmin = inrange.hmin;
    hmax = inrange.hmax;
    vmin = inrange.vmin;
    vmax = inrange.vmax;
    smin = inrange.smin;
    smax = inrange.smax;
end

function reset_inrange()
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    disp('init_inrange');
    hmin = 1;
    hmax = 0;
    vmin = 1;
    vmax = 0;
    smin = 1;
    smax = 0;
end