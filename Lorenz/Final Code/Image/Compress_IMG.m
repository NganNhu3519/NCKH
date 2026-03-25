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
x_vec = Img(:);

% save('y_img_NIST_ver1.mat', ...
%      'b', 'A', 'p', 'q', 'block_size', 'ratio');
% 
% save('y_img_NIST_ver1_workspace.mat')

%%
% x_vis = A' * y;
% Img_vis = reshape(x_vis(:), p, q);
% % Original image
% figure;
% imshow(mat2gray(Img));
% title('Original Image');
% % exportgraphics(gcf,'Original_Image.png','Resolution',300);
% 
% % Encrypted image
% figure;
% imshow(mat2gray(Img_vis));
% title('Encrypted Image');
% exportgraphics(gcf,'Encrypted_Image.png','Resolution',300);

% CS measurements
figPos  = [100 100 800 900];
figure('Position',figPos);

subplot(2,1,1)
plot(x_vec,'k','LineWidth',0.8);
grid on
xlabel('Sample index');
ylabel('Amplitude');
% set(gca,'Position',[0.12 0.55 0.82 0.36],'FontSize',10)
% text(0.5,-0.18,'(a)','Units','normalized','HorizontalAlignment','center','FontWeight','normal','FontSize',11)

subplot(2,1,2)
plot(b,'k','LineWidth',0.8);
grid on
xlabel('Sample index');
ylabel('Amplitude');
% set(gca,'Position',[0.12 0.10 0.82 0.36],'FontSize',10)
% text(0.5,-0.18,'(b)','Units','normalized','HorizontalAlignment','center','FontWeight','normal','FontSize',11)

% exportgraphics(gcf,'CS_Overview.png','Resolution',300);

%% 
close all;
% x_vis = A' * y;
% Img_vis = reshape(x_vis(:), p, q);
Img = imread('cameraman.tif');
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
exportgraphics(gcf,'H_plain.png','Resolution',300);

% V-plain
figure;
scatter(Iv(:),Jv(:),30,'.');
title('V-plain');
exportgraphics(gcf,'V_plain.png','Resolution',300);

% D-plain
figure;
scatter(Id(:),Jd(:),30,'.');
title('D-plain');
exportgraphics(gcf,'D_plain.png','Resolution',300);

% H-encrypted
figure;
scatter(Eh(:),Fh(:),30,'.');
title('H-encrypted');
exportgraphics(gcf,'H_CS_encrypted.png','Resolution',300);

% V-encrypted
figure;
scatter(Ev(:),Fv(:),30,'.');
title('V-encrypted');
exportgraphics(gcf,'V_CS_encrypted.png','Resolution',300);

% D-encrypted
figure;
scatter(Ed(:),Fd(:),30,'.');
title('D-encrypted');
exportgraphics(gcf,'D_CS_encrypted.png','Resolution',300);

%%
close all
x_vis = A' * y;
Img_vis = reshape(x_vis(:), p, q);

Img = imread('cameraman.tif');
I = double(Img);

Ih = I(:,1:end-1);   Iv = I(1:end-1,:);   Id = I(1:end-1,1:end-1);
Jh = I(:,2:end);     Jv = I(2:end,:);     Jd = I(2:end,2:end);

E = Img_vis;
Eh = E(:,1:end-1);   Ev = E(1:end-1,:);   Ed = E(1:end-1,1:end-1);
Fh = E(:,2:end);     Fv = E(2:end,:);     Fd = E(2:end,2:end);

CC_H_enc = corrcoef(Eh(:), Fh(:)); CC_H_enc = CC_H_enc(1,2);
CC_V_enc = corrcoef(Ev(:), Fv(:)); CC_V_enc = CC_V_enc(1,2);
CC_D_enc = corrcoef(Ed(:), Fd(:)); CC_D_enc = CC_D_enc(1,2);
fprintf('Encrypted CC: H=%.4f, V=%.4f, D=%.4f\n', CC_H_enc, CC_V_enc, CC_D_enc);

figure('Position',[100 100 1200 700]);

subplot(2,3,1)
scatter(Id(:),Jd(:),30,'.')
set(gca,'Position',[0.08 0.55 0.26 0.38],'FontSize',10)
text(0.5,-0.12,'(a)','Units','normalized','HorizontalAlignment','center','FontSize',11)

subplot(2,3,2)
scatter(Iv(:),Jv(:),30,'.')
set(gca,'Position',[0.38 0.55 0.26 0.38],'FontSize',10)
text(0.5,-0.12,'(b)','Units','normalized','HorizontalAlignment','center','FontSize',11)

subplot(2,3,3)
scatter(Ih(:),Jh(:),30,'.')
set(gca,'Position',[0.68 0.55 0.26 0.38],'FontSize',10)
text(0.5,-0.12,'(c)','Units','normalized','HorizontalAlignment','center','FontSize',11)

subplot(2,3,4)
scatter(Ed(:),Fd(:),30,'.')
set(gca,'Position',[0.08 0.08 0.26 0.38],'FontSize',10)
text(0.5,-0.12,'(d)','Units','normalized','HorizontalAlignment','center','FontSize',11)

subplot(2,3,5)
scatter(Ev(:),Fv(:),30,'.')
set(gca,'Position',[0.38 0.08 0.26 0.38],'FontSize',10)
text(0.5,-0.12,'(e)','Units','normalized','HorizontalAlignment','center','FontSize',11)

subplot(2,3,6)
scatter(Eh(:),Fh(:),30,'.')
set(gca,'Position',[0.68 0.08 0.26 0.38],'FontSize',10)
text(0.5,-0.12,'(f)','Units','normalized','HorizontalAlignment','center','FontSize',11)

exportgraphics(gcf,'DVH_Analysis.png','Resolution',300);