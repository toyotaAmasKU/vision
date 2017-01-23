% author : Supakit Kriangkhajorn
% skconan
function display()
%   declare function
    function [rpi,cam] = connection(ip,username,password)
        rpi = raspi(ip,username,password);
        cam = cameraboard(rpi, 'Resolution', '800x600');
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
    
    function render()
        cam.Rotation = 90;
        img = snapshot(cam); 
  
        while ~isempty(img)
            img = snapshot(cam);   
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
    render()
    stop()
end