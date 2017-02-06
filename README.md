Author : Supakit Kriangkhajorn, 2016

Follow me : skconan


Detect traffic light for AMAS-MBD 2016
  
    Send video data via udp port from raspberry pi to computer and process detect red circle program on computer.    

Main File :
  
    Raspberry pi : pi_send_video.slx
  
    Computer :  com_getColorPX.m
                com_detect_red_circle.slx
                
How to run a program :
    
      1. Before run a program
    
         In pi_send_video.slx and com_detect_red_circle.slx file. You need to setting IP address 
    and port of UDP block and deploy pi_send_video program to raspberry pi.
         In com_getColorPX.m. You need to change ip ,username and password variable value for 
    connect your raspberry pi.
    
      2. Run com_getColorPX.m file for get range color that you want to detect. The program 
    have many commands follow this:
        - click left mouse button > Get color from mouse position in only image.
        - press left arrow button > Next frame.
        - press s button > Save color range value to inrange.mat.
        - press l button > Load color range value from inrange.mat.
        - press r button > Reset color range.
        - press u button > Undo color range.
    
      3. On workspace in MATLAB, run command load('inrange.mat').
      4. Run com_detect_circle.slx file for detect circle. 
  
Thank you.
