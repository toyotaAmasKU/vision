% Author : Supakit Kriangkhajorn
% Follow me : skconan

function detectTrafficLight()
%   declare function
    function [rpi,cam] = connection(ip,username,password)
        rpi = raspi(ip,username,password);
        cam = cameraboard(rpi, 'Resolution', '320x240');
        disp(rpi.BoardName);
        disp(cam.Name)
    end

    function led(n)
        for i = 1:n
            writeLED(rpi,'led0',1)
            pause(0.25);
            writeLED(rpi,'led0',0)
            pause(0.25);
        end
    end

    function initialize()
        led(4)
    end
    function vision()
        cam.Rotation = 270;
        cam.HorizontalFlip = true;
        img = snapshot(cam); 
  
        while ~isempty(img)
            img = snapshot(cam);
            hsv = rgb2hsv(img);
            red = inRange(hsv,'red');
            result = red ;
            [centers, radius, metric] = imfindcircles(result,[20 60],'ObjectPolarity','bright');
            circles = [centers, radius, metric];
            disp(circles);
            if ~isempty(circles)
                disp(circles);
                circles = sortrows(circles,3);
                [rows,cols] = size(circles);
                disp(rows);
                disp(circles);
                
                circle = circles(rows,:);
                disp(circle);
                centerMax = circle(1:2)
                radiusMax = circle(3)
                viscircles(centerMax , radiusMax+1,'Color','y');
                pause(0.01);
            end
            imshow(img);
        end
    end

    function stop()
        writeLED(rpi,'led0',0)
        clear
    end
    
%   declare variable 
    ip = '192.168.1.118';
    username = 'pi';
    password = 'raspberry';
    
%   main
    [rpi,cam] = connection(ip,username,password);
    initialize()
    vision()
    stop()
end