% Author: Uyen L.P. Nguyen 
% Date: Sept 2024
% Reconstruct Img signal

% close all;clear all;clc;

%% Load Input image
%L =10; % num of block of audio signal
N = 1000;
Img_org = imread('cameraman.tif');
Img_org = Img_org([51:150],[51:150]);
figure; imshow(Img_org)
Img_arr = double(Img_org(:));      % image array
L = length(Img_arr)/N;

%% Load WS
load y_imgv1.mat
%load x_est_img.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\IMG_results_v1.mat
y_new = results.x_est(4,:)';
% y_new = x_est(4,:)';
M = length(y_new)/L;  % length of y new
Theta = phi*psi';
%%
for i=1 : L
s21 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
s1 = l1eq_pd(s21,Theta,Theta',y_new(M*(i-1)+1: M*i),5e-3,20); % L1-magic toolbox
x1(:,i) = psi'*s1;
end
x_rec = x1(:);
x_hat=vec2mat(x_rec,100)';
 % using median filter
x_hat_filt= medfilt2(x_hat, [2 2]);
% Gaussian filter
%gaussianFilter = fspecial('gaussian', 5, 2);
gaussianFilter = fspecial('gaussian', 2, 2);
deblurredImage = imfilter(x_hat, gaussianFilter, 'replicate');



% %% l1-recovery using linear program
% phi_rec=phi*psi';
% % transfering l1 minimization into linear program
% Vec_ones = ones([2 * N, 1]);
% Vec_low = zeros([2 * N, 1]);
% Vec_high = inf([2 * N, 1]);
% 
% ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');
% for i=1 : L
% z_hat=linprog(Vec_ones,[],[], [phi_rec -phi_rec], y_new(M*(i-1)+1: M*i), Vec_low, Vec_high,ssOpt);
% xp_hat(:,i)=z_hat(1:N)-z_hat(1+N:end);
% xp_hat(:,i)=psi'*xp_hat(:,i);
% end
% x_rec = xp_hat(:);
%  x_hat=vec2mat(x_rec,100)';

%% Reconstruction
%figure;plot(y_cp);title('linear measurement y')
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
% subplot(223);imshow(uint8(x_hat_filt));title('Reconstructed Image with Median filter')
% subplot(224);imshow(uint8(deblurredImage));title('Reconstructed Deblur- Image')
% x_hat= medfilt2(x_hat, [2 2])
% figure; imshow(uint8(filtered_img))
mse1 = mse(Img_arr,x_rec)
mse2 = mse(Img_arr,x_hat_filt(:))
mse3 = mse(Img_arr,deblurredImage(:))
disp('Image')
fprintf('MSE: %d \n',mse1)
 
