%% Object Detection 1.1

% Lightweight, Filterless Object Detection Algorithm for Still Cameras

% Dependencies: 
%   Computer Vision Toolbox
%   USB Webcam Support Toolbox
%   Class 'Objects' (Objects.m)

% 1. Compares Initial Frame to Background Image, 
%       -Extracts Color, Size, and Image
% 2. Compares Each Frame to Preceeding Frame to Detect Movement
%       -Iterates Until Termination
%% Compare Current Frame to Background Image
% Initalize camera
cam = webcam(1);
% Load Background Frame
load('Insert Background Image File');
background = 'Insert Background Image';
% Capture Current Frame
frame = snapshot(cam);
% Extract Objects From Initial Frame
data = init_frame(background,frame);