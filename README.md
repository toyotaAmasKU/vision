Author : Supakit Kriangkhajorn, 2016

Follow me : skconan   


Main File :
  
    Raspberry pi : pi_send_video.slx
  
    Computer :  com_getColorPX.m
                com_detect_red_circle.slx
                
How to run program :
    
      1. Before run program
         In pi_send_video.slx and com_detect_red_circle.slx file. You need to set IP address 
    and port of UDP block then deploy pi_send_video program to raspberry pi.
         In com_getColorPX.m file. You need to change value of variable(ip, username, and password) 
    for connect your raspberry pi.
    
      2. Run com_getColorPX.m file for getting the value of color range that you want to detect. 
    The program have many commands following:
        - Click left mouse button > Getting the value of color range from mouse position in image.
        - Press right arrow button > Next frame.
        - Press s button > Save the value of color range to inrange.mat.
        - Press l button > Load the value of color range from inrange.mat.
        - Press r button > Reset the value of color range.
        - Press u button > Undo the value of color range.
    
      3. Run command "load('inrange.mat')" On workspace in MATLAB, .
      4. Run com_detect_circle.slx file for detecting circle. 
  
Thank you.
