%Compress Sensing
clear; close all; clc;

N = 1000;

%% Original image
Img_org = imread('tire.tif');
Img_org = Img_org([51:150],[51:150]);
figure; imshow(Img_org)
Img_arr = double(Img_org(:));
Img_arr = (Img_arr - mean(Img_arr)) / std(Img_arr); %chuẩn hóa

L = length(Img_arr)/N;
psi=dctmtx(N);

%% ___MEASUREMENT MATRIX___
M = 400; 
phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;

%% ___COMPRESSION___
x_cp = zeros(N,1);
for i=1:L
x_cp=Img_arr(1+(i-1)*N:N*i,1);
y1 = phi*x_cp;
y_cs(:,i) = y1;
end

% y_cp = y_cs(:);
y_cp = reshape(y_cs',[],1);
y_cp = smoothdata(y_cp,'movmean',5);

save('y_i.mat','phi','y_cp','psi');
