clear; close all; clc;

%% Load dữ liệu nén
load('y_img.mat');  % chứa phi, y_cp, psi

%% Thông số
N = 1000;
M = size(phi,1);
r = M/N; % compression ratio
fprintf('Compression ratio: %.2f%%\n', r*100);

%% Reconstruction
L = length(y_cp)/M;
Theta = phi * psi';
x_rec = zeros(N, L);

for i = 1:L
    y_block = y_cp((i-1)*M+1 : i*M);
    % tái tạo bằng pseudo-inverse (cơ bản)
    x_est = l1eq_pd(zeros(N,1), Theta, Theta', y_block);
    x_rec(:,i) = psi' * x_est;
end

%% Gom lại ảnh
Img_rec = reshape(x_rec, [100, 100]);
Img_rec = uint8(Img_rec);

%% Hiển thị kết quả
figure;
subplot(1,2,1);
imshow(reshape(y_cp(1:961), [31 31]), []); % 31×31 gần sqrt(1000)
title('Compressed View (illustrative)');
subplot(1,2,2); imshow(Img_rec); title('Reconstructed Image');

%% Tính PSNR và MSE
load tire; % dùng làm tham chiếu nếu muốn
Img_org = imread('tire.tif');
Img_org = Img_org([51:150],[51:150]);
Img_org = double(Img_org);

mse_val = mean((Img_org(:)-double(Img_rec(:))).^2);
psnr_val = 10*log10(255^2/mse_val);

fprintf('MSE: %.4f\n', mse_val);
fprintf('PSNR: %.2f dB\n', psnr_val);
