% Author : Supakit Kriangkhajorn
% Follow : skconan

function com_getColor_green()
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    global radius;
    global center;
    radius = 0;
    center = [0,0];
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
            h_min_g = hmin(size(hmin,2));
            h_max_g = hmax(size(hmax,2));
            s_min_g = smin(size(smin,2));
            s_max_g = smax(size(smax,2));
            v_min_g = vmin(size(vmin,2));
            v_max_g = vmax(size(vmax,2));
            save inrange_g.mat h_min_g h_max_g s_min_g s_max_g v_min_g v_max_g radius -v7.3;
        elseif btn == 'l'
            load_inrange();
        elseif btn == 'u'
            undo_inrange();
        elseif btn == 'g'
            get_radius(result);
            viscircles(center,radius);
            disp(radius);
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
            
            fprintf('==========\n%d %d\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n... %.2f %.2f %.2f\nRadius : %.2f\n',col,row,h,s,v,hmax(size(hmax,2)),...
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
    inrange = matfile('inrange_g.mat');
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    disp('init_inrange');
    hmin(size(hmin,2)+1) = inrange.h_min_g;
    hmax(size(hmax,2)+1) = inrange.h_max_g;
    vmin(size(vmin,2)+1) = inrange.v_min_g;
    vmax(size(vmax,2)+1) = inrange.v_max_g;
    smin(size(smin,2)+1) = inrange.s_min_g;
    smax(size(smax,2)+1) = inrange.s_max_g;
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

function get_radius(img)
    global radius;
    global center;
    radius = 0;
    center = [0,0];
    [centers, radi, metric] = imfindcircles(img,[30 90],...
                                            'Sensitivity',0.95,...
                                            'Method','twostage',...
                                            'ObjectPolarity','bright');
    circles = [centers, radi, metric];
    check = ~isempty(circles);
    if check
        circles = sortrows(circles,3);
        [rows,cols] = size(circles);
        center = circles(rows,1:2);
        radius = circles(rows,3); 
    end
   
end