% Author : Supakit Kriangkhajorn
% Follow : skconan

function com_getColorPX()
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
   
    [rpi,cam] = connection(ip,username,password);
    
    width = 320;
    height = 240;
    
%     cam.Rotation = 270;
    cam.HorizontalFlip = true;
    while true	
        
        img = snapshot(cam); 
        hsv = rgb2hsv(img);
        
        result = inrange_input(hsv,hmin(size(hmin,2)),hmax(size(hmax,2)),smin(size(smin,2)),smax(size(smax,2)),vmin(size(vmin,2)),vmax(size(vmax,2)));
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
            h_min = hmin(size(hmin,2));
            h_max = hmax(size(hmax,2));
            s_min = smin(size(smin,2));
            s_max = smax(size(smax,2));
            v_min = vmin(size(vmin,2));
            v_max = vmax(size(vmax,2));
            save inrange.mat h_min h_max s_min s_max v_min v_max -v7.3;
        elseif btn == 'l'
            load_inrange();
        elseif btn == 'u'
            undo_inrange();
        elseif btn == 29
            continue;
        else
            h = hsv(row, col, 1);
            s = hsv(row, col, 2);
            v = hsv(row, col, 3);
        
            if h <= hmin(size(hmin,2))
                hmin(size(hmin,2)+1) = h;
            end
            if h >= hmax(size(hmax,2))
                hmax(size(hmax,2)+1) = h;
            end
            if s <= smin(size(smin,2))
                smin(size(smin,2)+1) = s;
            end
            if s >= smax(size(smax,2))
                smax(size(smax,2)+1) = s;
            end
            if v <= vmin(size(vmin,2))
                vmin(size(vmin,2)+1) = v;
            end
            if v >= vmax(size(vmax,2))
                vmax(size(vmax,2)+1) = v;
            end
            
            fprintf('==========\n%d %d\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n',col,row,h,s,v,hmax(size(hmax,2)),...
                                                                                            smax(size(smax,2)),vmax(size(vmax,2)),...
                                                                                            hmin(size(hmin,2)),smin(size(smin,2)),...
                                                                                            vmin(size(vmin,2)));
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
    hmin(size(hmin,2)+1) = inrange.hmin;
    hmax(size(hmax,2)+1) = inrange.hmax;
    vmin(size(vmin,2)+1) = inrange.vmin;
    vmax(size(vmax,2)+1) = inrange.vmax;
    smin(size(smin,2)+1) = inrange.smin;
    smax(size(smax,2)+1) = inrange.smax;
end

function reset_inrange()
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    disp('reset_inrange');
    hmin(size(hmin,2)+1) = 1;
    hmax(size(hmax,2)+1) = 0;
    vmin(size(vmin,2)+1) = 1;
    vmax(size(vmax,2)+1) = 0;
    smin(size(smin,2)+1) = 1;
    smax(size(smax,2)+1) = 0;
end

function undo_inrange()
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    disp('undo_inrange');
    if size(hmin,2) > 1
        hmin(size(hmin,2)) = [];
        hmax(size(hmax,2)) = [];
        vmin(size(vmin,2)) = [];
        vmax(size(vmax,2)) = [];
        smin(size(smin,2)) = [];
        smax(size(smax,2)) = [];
    end
end