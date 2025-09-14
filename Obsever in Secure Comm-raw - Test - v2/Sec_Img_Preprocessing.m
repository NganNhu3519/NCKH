close all, clear all, clc

%% Original image
Img_org = imread('cameraman.tif');
Img_org = Img_org([51:150],[51:150]);
Img_org = Img_org([51:80],[51:80]);
%Img_org = Img_org([51:60],[51:60]);
figure; imshow(Img_org)
Img_arr = double(Img_org(:));      % image array
save('Img_arr.mat','Img_arr')