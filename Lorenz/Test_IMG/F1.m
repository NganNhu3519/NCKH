% Compress Sensing (NO DC patch)
clear; close all; clc;

N = 256;

%% Original image
Img_org = imread('cell.tif');
Img_org = Img_org(1:32, 1:32);
figure; imshow(Img_org); title('Original image (32×32)');

Img_arr = double(Img_org(:));

% Global normalization (ONLY here)
Img_arr = (Img_arr - mean(Img_arr)) / std(Img_arr);

L = length(Img_arr) / N;
psi = dctmtx(N);

%% Measurement matrix
M = 300;
phi = randi([0 1], M, N);
phi(phi==0) = -1;
phi = phi / sqrt(M);

%% Compression (NO DC removal)
y_cs = zeros(M, L);

for i = 1:L
    x_cp = Img_arr(1+(i-1)*N : i*N);
    y_cs(:,i) = phi * x_cp;
end

y_cp = reshape(y_cs.', [], 1);

save('y_32.mat', 'phi', 'psi', 'y_cp');

%% Visualization (for sanity check only)
figure;
subplot(1,2,1);
imshow(uint8(Img_org));
title('Original image (32×32)');

subplot(1,2,2);
imshow(mat2gray(reshape(y_cp, [], 20)));
title('Compressed measurements');
