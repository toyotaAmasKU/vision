% Author : Supakit Kriangkhajorn
% Follow me : skconan

function record()
%   declare variable 
    ip = '192.168.1.118';
    username = 'pi';
    password = 'raspberry';
    
%   main
    [rpi,cam] = connection(ip,username,password);
    initialize()
    vision()
    
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
        video = VideoWriter('vdo.avi');
        open(video);
        while ~isempty(img)
            img = snapshot(cam); 
            writeVideo(v,img);
            imshow(img);
            pause(0.01);
        end
        close(v);
    end
end