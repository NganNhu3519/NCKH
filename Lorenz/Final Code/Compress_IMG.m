%% FILE 1
clear; close all; clc;

Img = double(imread('mri.tif')); % 128x128
[p,q] = size(Img);

block_size = 32;
ratio = 0.5; %đo 50%

projection_matrix_file = ['projections.' num2str(block_size) '.' num2str(ratio) '.mat'];
A = BCS_SPL_GenerateProjection(block_size, ratio, projection_matrix_file); %key sensing matrix

% 1 col = 1 block 32x32, chia ảnh thành block và xếp thành ma trận cột
x_hat = im2col(Img, [block_size block_size], 'distinct'); 
y = A * x_hat;
b = y(:);

% save('y_img_Rcos_ver7.mat', ...
%      'b', 'A', 'p', 'q', 'block_size', 'ratio');
% 
% save('y_img_Rcos_ver7_workspace.mat')

%%
x_vis = A' * y;
Img_vis = reshape(x_vis(:), p, q);
% Original image
figure;
imshow(mat2gray(Img));
title('Original Image');
exportgraphics(gcf,'Original_Image.png','Resolution',300);

% Encrypted image
figure;
imshow(mat2gray(Img_vis));
title('Encrypted Image');
exportgraphics(gcf,'Encrypted_Image.png','Resolution',300);

% CS measurements
figure;
plot(b,'k');
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Compressed Measurements');
exportgraphics(gcf,'Compressed_Measurements.png','Resolution',300);

% Histogram original image
figure;
histogram(Img(:),100);
xlabel('Intensity'); ylabel('Count');
title('Histogram Original');
exportgraphics(gcf,'Histogram_Original.png','Resolution',300);

% Histogram compressed measurements
figure;
histogram(b,100);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Compressed');
exportgraphics(gcf,'Histogram_Compressed.png','Resolution',300);

I = mat2gray(Img);
Ih = I(:,1:end-1);   Iv = I(1:end-1,:);   Id = I(1:end-1,1:end-1);
Jh = I(:,2:end);     Jv = I(2:end,:);     Jd = I(2:end,2:end);

E = mat2gray(Img_vis);
Eh = E(:,1:end-1);   Ev = E(1:end-1,:);   Ed = E(1:end-1,1:end-1);
Fh = E(:,2:end);     Fv = E(2:end,:);     Fd = E(2:end,2:end);

% H-plain
figure;
scatter(Ih(:),Jh(:),5,'.');
title('H-plain');
exportgraphics(gcf,'H_plain.png','Resolution',300);

% V-plain
figure;
scatter(Iv(:),Jv(:),5,'.');
title('V-plain');
exportgraphics(gcf,'V_plain.png','Resolution',300);

% D-plain
figure;
scatter(Id(:),Jd(:),5,'.');
title('D-plain');
exportgraphics(gcf,'D_plain.png','Resolution',300);

% H-encrypted
figure;
scatter(Eh(:),Fh(:),5,'.');
title('H-encrypted');
exportgraphics(gcf,'H_encrypted.png','Resolution',300);

% V-encrypted
figure;
scatter(Ev(:),Fv(:),5,'.');
title('V-encrypted');
exportgraphics(gcf,'V_encrypted.png','Resolution',300);

% D-encrypted
figure;
scatter(Ed(:),Fd(:),5,'.');
title('D-encrypted');
exportgraphics(gcf,'D_encrypted.png','Resolution',300);
