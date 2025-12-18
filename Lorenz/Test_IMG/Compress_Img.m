%Compress Sensing
clear; close all; clc;

N = 1000;
% N = 256;

%% Original image
Img_org = imread('tire.tif');
Img_org = Img_org([50:149],[50:149]);
figure; imshow(Img_org)
Img_arr = double(Img_org(:));
[imgH, imgW] = size(Img_org);
Img_arr = (Img_arr - mean(Img_arr)) / std(Img_arr); %chuẩn hóa

L = length(Img_arr)/N;
psi=dctmtx(N);

%% ___MEASUREMENT MATRIX___
M = 400; 
phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;
phi = phi / sqrt(M);

%% ___COMPRESSION___
x_cp = zeros(N,1);
for i=1:L
x_cp=Img_arr(1+(i-1)*N:N*i,1);
y1 = phi*x_cp;
y_cs(:,i) = y1;
end

y_cp = y_cs(:);
x_vis = phi' * y_cs;
x_vis = x_vis(:);
Img_vis = reshape(x_vis, imgH, imgW);

figure;
subplot(1,2,1);
imshow(uint8(Img_org));
title('Original');

subplot(1,2,2);
imshow(uint8(mat2gray(Img_vis)*255));
title('CS encoded (visual)');

% save('y_32.mat','phi','y_cp','psi');