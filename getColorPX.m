clear all;
cam = webcam('USB2.0 VGA UVC WebCam');
while true
    img = snapshot(cam);
    imshow(img);
%     preview(cam);
    [x,y] = ginput(1);
    x = uint8(x);
    y = uint8(y);
    fprintf('%d %d %d\n',img(x,y,1),img(x,y,2),img(x,y,3));
    pause(0.01);
end