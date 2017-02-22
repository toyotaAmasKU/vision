% Author : Supakit Kriangkhajorn
% Follow : skconan

function computer_getColor_red_video()
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
    n_frame = 250;
    width = 320;
    height = 240;
    
    load_inrange();
    vdo = VideoReader('newfile.avi');
 
    for i = 1:n_frame
        img = readFrame(vdo);
    end
    
    while hasFrame(vdo)
        img = readFrame(vdo);
        hsv = rgb2hsv(img);
        result = inrange_input(hsv,hmin(size(hmin,2)),hmax(size(hmax,2)),smin(size(smin,2)),smax(size(smax,2)),vmin(size(vmin,2)),vmax(size(vmax,2)));
        
        figure(1); 
        imshow(img);
        figure(2); 
        imshow(hsv);
        figure(3);
        imshow(result);      
        
        [col, row, btn] = ginput(1);
        row = int16(row);
        col = int16(col);
        
        if ~(0 <= row(1) && row(1) <= height && 0 <= col(1) && col(1) <= width) && btn == 1
            continue
        elseif btn == 'r'
            reset_inrange();
        elseif btn == 's'
            h_min_r = hmin(size(hmin,2));
            h_max_r = hmax(size(hmax,2));
            s_min_r = smin(size(smin,2));
            s_max_r = smax(size(smax,2));
            v_min_r = vmin(size(vmin,2));
            v_max_r = vmax(size(vmax,2));
            save inrange_r.mat h_min_r h_max_r s_min_r s_max_r v_min_r v_max_r radius -v7.3;            
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
            
            fprintf('==========\n%d %d\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n%.2f %.2f %.2f\nRadius : %.2f\n',col,row,h,s,v,hmax(size(hmax,2)),...
                                                                                            smax(size(smax,2)),vmax(size(vmax,2)),...
                                                                                            hmin(size(hmin,2)),smin(size(smin,2)),...
                                                                                            vmin(size(vmin,2)),radius);
        end        
    end
end
    
function load_inrange()
    global hmin;
    global hmax;
    global vmin;
    global vmax;
    global smin;
    global smax;
    
    inrange = matfile('inrange_r.mat');
    disp('init_inrange');
    hmin(size(hmin,2)+1) = inrange.h_min_r;
    hmax(size(hmax,2)+1) = inrange.h_max_r;
    vmin(size(vmin,2)+1) = inrange.v_min_r;
    vmax(size(vmax,2)+1) = inrange.v_max_r;
    smin(size(smin,2)+1) = inrange.s_min_r;
    smax(size(smax,2)+1) = inrange.s_max_r;
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

function get_radius(result)
    global radius;
    global center;
    radius = 0;
    center = [0,0];
    
    result = imclose(result,strel('line', 10, 40));
    result = imdilate(result,strel('line', 3, 35));
    [centers, radi, metric] = imfindcircles(result,[16 30],...
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