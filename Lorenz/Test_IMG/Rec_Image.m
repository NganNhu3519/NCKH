% Reconstruct Img signal

close all;clear all;clc;

%% Load Input image
% L = 10; % num of block of audio signal
% N = 1000;
N = 256;
Img_org = imread('cameraman.tif');
% Img_org = Img_org([51:150],[51:150]);
Img_org = Img_org([1:32],[1:32]);
figure; imshow(Img_org)
Img_arr = double(Img_org(:));      % image array
L = length(Img_arr)/N;

%% Load WS
load y_32.mat
%load x_est_img.mat
load i_r_32.mat
% y_new = results.x_est(4,:)';
y_new = x_est(4,:)';
M = length(y_new)/L;  % length of y new
Theta = phi*psi';
%%
tic %time
for i=1 : L
s21 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
s1 = l1eq_pd(s21,Theta,Theta',y_new(M*(i-1)+1: M*i),5e-3,20); % L1-magic toolbox
x1(:,i) = psi'*s1;
end
recon = toc;

x_rec = x1(:);
x_hat=vec2mat(x_rec,100)';
 % using median filter
x_hat_filt= medfilt2(x_hat, [2 2]);
% Gaussian filter
%gaussianFilter = fspecial('gaussian', 5, 2);
gaussianFilter = fspecial('gaussian', 2, 2);
deblurredImage = imfilter(x_hat, gaussianFilter, 'replicate');


%% Reconstruction
figure;
plot(Img_arr); hold on; 
plot(x_rec, 'r.'); title('Image Reconstruction');
legend('Original', 'Recovered');

% Compress image
figure;
y_enc_cp = y_cp(1:63^2);y_enc_cp = mod(y_enc_cp,255);imshow(uint8(vec2mat(y_enc_cp,63)'));

figure;
subplot(131);imshow(uint8(Img_org));title('Original Image','Interpreter','latex','FontSize',13)
subplot(132);imshow(uint8(vec2mat(y_enc_cp,63)'));title('Compressed \& Encrypted Image','Interpreter','latex','FontSize',13)
subplot(133);imshow(uint8(x_hat));title('Reconstructed Image','Interpreter','latex','FontSize',13)

%% MSE
x_hat = double(x_hat(:));
x_hat_filt = double(x_hat_filt(:));
deblurredImage = double(deblurredImage(:));

if size(Img_arr) ~= size(x_hat), x_hat = x_hat'; end
if size(Img_arr) ~= size(x_hat_filt), x_hat_filt = x_hat_filt'; end
if size(Img_arr) ~= size(deblurredImage), deblurredImage = deblurredImage'; end

mse1 = immse(x_hat, Img_arr);
mse2 = immse(x_hat_filt, Img_arr);
mse3 = immse(deblurredImage, Img_arr);

peak_val = max(abs(Img_arr));
[psnr1, snr1] = psnr(x_hat, Img_arr, peak_val);
[psnr2, snr2] = psnr(x_hat_filt, Img_arr, peak_val);
[psnr3, snr3] = psnr(deblurredImage, Img_arr, peak_val);

R1 = corrcoef(Img_arr, x_hat);          
CC1 = R1(1,2);
R2 = corrcoef(Img_arr, x_hat_filt);     
CC2 = R2(1,2);
R3 = corrcoef(Img_arr, deblurredImage);
CC3 = R3(1,2);

fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('Raw:   MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', mse1, psnr1, snr1, CC1);
fprintf('Median:MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', mse2, psnr2, snr2, CC2);
fprintf('Gauss: MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', mse3, psnr3, snr3, CC3);