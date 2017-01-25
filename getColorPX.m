clear all;
cam = webcam('USB2.0 VGA UVC WebCam');
hmin = 1;
hmax = 0;
vmin = 1;
vmax = 0;
smin = 1;
smax = 0;

while true
    % Create slider
    
				
    img = snapshot(cam);
    hsv = rgb2hsv(img);
%     subplot(1,2,1);
    figure(1); 
    imshow(hsv);
%     preview(cam);
    
    [y,x] = ginput(1);
%     disp(length(x));
%     disp(x(1));
    if x(1) < 0 || y(1) < 0
        continue
    end
%     disp('1');
   
    x = uint16(x);
    y = uint16(y);
    disp(size(hsv));
    h = hsv(x,y,1);
    s = hsv(x,y,2); 
    v = hsv(x,y,3);
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
    fprintf('==========\n%d %d\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n %.2f %.2f %.2f\n',x,y,h,s,v,hmax,smax,vmax,hmin,smin,vmin);
    result = inrange_input(hsv,hmin,hmax,smin,smax,vmin,vmax);
%     subplot(1,2,2);
    
    figure(2);
    imshow(result);

    sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',50,'Value',41,...
        'Position', [400 20 120 20],...
        'Callback', @surfzlim); 
    pause(0.01);
end

function surfzlim(source,event)
        val = 51 - source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');

        zlim(ax,[-val val]);
    end