%% Object Detection 1.0

% Lightweight, Filterless Object Detection Algorithm for Still Cameras

% Dependencies: 
%   Computer Vision Toolbox
%   USB Webcam Support Toolbox
%   Class 'Objects' (Objects.m)

% 1. Compares Initial Frame to Background Image, 
%       -Extracts Color, Size, and Image
% 2. Compares Each Frame to Preceeding Frame to Detect Movement
%       -Iterates Until Termination

clc; clear; close;
%% Compare Current Frame to Background Image
% Initalize camera
cam = webcam(1);
% Load background image
load('Insert Background Image File');
background = 'Insert Background Image';
% Convert to HSV
background_hsv = rgb2hsv(background);
% Capture Current Frame
frame = snapshot(cam);
% Convert to HSV
frame_hsv = rgb2hsv(background);
% Subtract Images
diff = bitxor(background_hsv,frame_hsv);
% Convert to Grayscale
diff_gray = rgb2gray(diff);
% Binarize Image
bin_img = imbinarize(diff_gray,0.4); % 40 percent threshold
% Find Differences
[L_img num] = bwlabel(bin_img);
% Calculate Object Areas & Centroids
img_data = regionprops(bin_img,'centroid','area');
% Select Minimum Area of Interest (pixels)
min_area = 100;
% Extract Relevant Objects
for i = 1:num
    if bin_img(i).Area > min_area
        centroids(count,:) = cat(1,img_data(i).Centroid);
        area(count,:) = cat(1,img_data.Area);
        count = count+1;
    end
end
% Show Image
imshow(binary_img);
hold on;
% Identify objects by color
red = imsubtract(frame(:,:,1), rgb2gray(frame));
green = imsubtract(frame(:,:,2),rgb2gray(frame));
blue = imsubtract(frame(:,:,3),rgb2gray(frame));
% Binarize Colored Images
red_bin = imbinarize(red);
green_bin = imbinarize(green);
blue_bin = imbinarize(blue);
% Find Differences 
[L_red num_red] = bwlabel(red_bin);
[L_green num_green] = bwlabel(green_bin);
[L_blue num_blue] = bwlabel(blue_bin);
% Label Objects
[B_red L_red N_red A_red] = bwboundaries(L_red);
[B_green L_green N_green A_green] = bwboundaries(L_green);
[B_blue L_blue N_blue A_blue] = bwboundaries(L_blue);
% Find Area and Location of Each Object
c_red = regionprops(red_bin,'centroid','area');
c_green = regionprops(green_bin,'centroid','area');
c_blue = regionprops(blue_bin,'centroid','area');
count = 1;
% Identify and Locate Relevant Objects
min_area = 100;
for i = 1:num_red
    if c_red(i).Area > min_area
        red_centroids(count,:) = cat(1,c_red(i).Centroid);
        red_area(count,:) = cat(1,c_red(i).Area);
        count = count+1;
    end
end
count = 1;
for i = 1:num_blue
    if c_blue(i).Area > min_area
        blue_centroids(count,:) = cat(1,c_blue(i).Centroid);
        blue_area(count,:) = cat(1,c_blue(i).Area);
        count = count+1;
    end
end
count = 1;
for i = 1:num_green
    if c_green(i).Area > min_area
        green_centroids(count,:) = cat(1,c_green(i).Centroid);
        green_area(count,:) = cat(1,c_green(i).Area);
        count = count+1;
    end
end
% Validate Objects 
E_t = [5 5]; %Error Threshold
for i = 1:size(centroids,1)
    for j = 1:size(blue_centroids,1)
        if abs(centroids(i,:)-blue_centroids(1,:)) <= E_t
           object(i) = Object;
           object(i).Size = area(i);
           object(i).Location = centroids(i);
           object(i).Color = 'Blue';
        end
    end
    for j = 1:size(red_centroids,1)
        if abs(centroids(i,:)-red_centroids(1,:)) <= E_t
            object(i) = Object;
            object(i).Size = area(i);
            object(i).Location = centroids(i);
            object(i).Color = 'Red';
        end
    end
    for j = 1:size(green_centroids,1)
        if abs(centroids(i,:)-green_centroids(1,:)) <= E_t
            object(i) = Object;
            object(i).Size = area(i);
            object(i).Location = centroids(i);
            object(i).Color = 'Green';
        end
    end
end
%% Compare Current Frame to Previous Frame
run = 'true';
while run == 'true'
    frame_old_hsv = frame_hsv;
    frame = snapshot(cam);
    % Perform Color Conversion and Background Subtraction
    frame_hsv = rgb2hsv(frame);
    diff = bitxor(frame_old_hsv,frame_hsv);
    diff_gray = rgb2gray(diff);
    bin_img = imbinarize(diff_gray,0.4);
    % Find objects that have moved
    [L_img num] = bwlabel(bin_img);
    img_data = regionprops(bin_img,'centroid','area');
    min_area = 100;
    for i = 1:num
        if bin_img(i).Area > min_area
            centroids(count,:) = cat(1,img_data(i).Centroid);
            area(count,:) = cat(1,img_data.Area);
            count = count+1;
        end
    end
    % NEED TO FIGURE OUT HOW TO IDENTIFY WHICH OBJECT MOVED
    % Shouldn't there be two gaps? One where the object was, and one where
    % it is now? we can use the relationship between the sizes and
    % locations of the objects to figure out which one moved.
end
