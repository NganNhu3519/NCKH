%% FILE 1
clear; close all; clc;

Img = double(imread('cameraman.tif')); % 256x256
[p,q] = size(Img);

block_size = 32;
ratio = 0.5; %đo 50%

projection_matrix_file = ['projections.' num2str(block_size) '.' num2str(ratio) '.mat'];
A = BCS_SPL_GenerateProjection(block_size, ratio, projection_matrix_file); %key sensing matrix

% 1 col = 1 block 32x32, chia ảnh thành block và xếp thành ma trận cột
tic;
x_hat = im2col(Img, [block_size block_size], 'distinct'); 
y = A * x_hat;
recon = toc;
b = y(:);

save('y_img_NIST_ver1.mat', ...
     'b', 'A', 'p', 'q', 'block_size', 'ratio');

save('y_img_NIST_ver1_workspace.mat')

%%
x_vis = A' * y;
Img_vis = reshape(x_vis(:), p, q);
% Original image
figure;
imshow(mat2gray(Img));
title('Original Image');
% exportgraphics(gcf,'Original_Image.png','Resolution',300);

% Encrypted image
figure;
imshow(mat2gray(Img_vis));
title('Encrypted Image');
% exportgraphics(gcf,'Encrypted_Image.png','Resolution',300);

% CS measurements
figure;
plot(b,'k');
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Compressed Measurements');
% exportgraphics(gcf,'Compressed_Measurements.png','Resolution',300);

% Histogram original image
figure;
histogram(Img(:),100);
xlabel('Intensity'); ylabel('Count');
title('Histogram Original');
% exportgraphics(gcf,'Histogram_Original.png','Resolution',300);

% Histogram compressed measurements
figure;
histogram(b,100);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Compressed');
% exportgraphics(gcf,'Histogram_Compressed.png','Resolution',300);

%% 
close all;
Img = imread('mri.tif');
I = double(Img);

Ih = I(:,1:end-1);   Iv = I(1:end-1,:);   Id = I(1:end-1,1:end-1);
Jh = I(:,2:end);     Jv = I(2:end,:);     Jd = I(2:end,2:end);

% E = mat2gray(Img_vis);
E = Img_vis;
Eh = E(:,1:end-1);   Ev = E(1:end-1,:);   Ed = E(1:end-1,1:end-1);
Fh = E(:,2:end);     Fv = E(2:end,:);     Fd = E(2:end,2:end);

CC_H_enc = corrcoef(Eh(:), Fh(:)); CC_H_enc = CC_H_enc(1,2);
CC_V_enc = corrcoef(Ev(:), Fv(:)); CC_V_enc = CC_V_enc(1,2);
CC_D_enc = corrcoef(Ed(:), Fd(:)); CC_D_enc = CC_D_enc(1,2);
fprintf('Encrypted CC: H=%.4f, V=%.4f, D=%.4f\n', CC_H_enc, CC_V_enc, CC_D_enc);

% H-plain
figure;
scatter(Ih(:),Jh(:),30,'.');
title('H-plain');
% exportgraphics(gcf,'H_plain.png','Resolution',300);

% V-plain
figure;
scatter(Iv(:),Jv(:),30,'.');
title('V-plain');
% exportgraphics(gcf,'V_plain.png','Resolution',300);

% D-plain
figure;
scatter(Id(:),Jd(:),30,'.');
title('D-plain');
% exportgraphics(gcf,'D_plain.png','Resolution',300);

% H-encrypted
figure;
scatter(Eh(:),Fh(:),30,'.');
title('H-encrypted');
% exportgraphics(gcf,'H_CS_encrypted.png','Resolution',300);

% V-encrypted
figure;
scatter(Ev(:),Fv(:),30,'.');
title('V-encrypted');
% exportgraphics(gcf,'V_CS_encrypted.png','Resolution',300);

% D-encrypted
figure;
scatter(Ed(:),Fd(:),30,'.');
title('D-encrypted');
% exportgraphics(gcf,'D_CS_encrypted.png','Resolution',300);
