% Author : Supakit Kriangkhajorn
% Follow me : skconan

function computer_detectTrafficLight()
%   declare variable
    filename = fopen('udpsend.txt','w');
    ip = '10.213.150.118';
    username = 'pi';
    password = 'raspberry';
    
%   main
    [rpi,cam] = connection(ip,username,password);
    vision()
    
%   declare function
    function [rpi,cam] = connection(ip,username,password)
        rpi = raspi(ip,username,password);
        cam = cameraboard(rpi, 'Resolution', '320x240');
        disp(rpi.BoardName);
        disp(cam.Name);
    end

    function initialize()
        led(4);
    end

    function stop()
        writeLED(rpi,'led0',0);
        clear;
    end

    function led(n)
        for i = 1:n
            writeLED(rpi,'led0',1);
            pause(0.25);
            writeLED(rpi,'led0',0);
            pause(0.25);
        end
    end

    function vision()
        global hmin;
        global hmax;
        global vmin;
        global vmax;
        global smin;
        global smax;
        cam.Rotation = 270;
        cam.HorizontalFlip = true;
        centerMax = [0,0];
        radiusMax = 0;
        
        load_inrange();
        img = snapshot(cam);
        
        while ~isempty(img)
            img = snapshot(cam);
            hsv = rgb2hsv(img);
            result = inrange_input(hsv,hmin,hmax,smin,smax,vmin,vmax);
            result = imclose(result,strel('line', 10, 40));
            result = imdilate(result,strel('line', 3, 35));
            [centers, radius, metric] = imfindcircles(result,[17 30],...
                                            'Sensitivity',0.95,...
                                            'Method','twostage',...
                                            'ObjectPolarity','bright');
            circles = [centers, radius, metric];
            if ~isempty(circles)
                circles = sortrows(circles,3);
                [rows,cols] = size(circles);
                circle = circles(rows,:);
                centerMax = circle(1:2);
                radiusMax = circle(3);
                disp(round(radiusMax));
                for i = 1:10
                    fprintf(filename,'\n%d',1);
                    pause(0.1);
                end
            else 
                fprintf(filename,'\n%d',0);
            end
            viscircles(centerMax , radiusMax,'Color','y');
            centerMax = [0,0];
            radiusMax = 5;
            subplot(1,2,1), subimage(result);
            subplot(1,2,2), subimage(img);
            pause(0.01);
        end
        fclose(filename);
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
        hmin = inrange.h_min_r;
        hmax = inrange.h_max_r;
        vmin = inrange.v_min_r;
        vmax = inrange.v_max_r;
        smin = inrange.s_min_r;
        smax = inrange.s_max_r;
    end
end