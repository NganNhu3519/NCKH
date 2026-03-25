clear; close all; clc;

load data_CS.mat
Img = double(imread('cameraman.tif'));
b = y(:);
x = Img(:);

idx  = 1:100:length(x);
idx1 = 1:100:length(b);

figure('Position',[100 100 650 700])

subplot(2,1,1)
plot(idx, x(idx), 'LineWidth', 0.6)
grid on
axis([0 idx(end) 0 250])
xlabel('Sample index')
ylabel('Amplitude')
set(gca,'FontSize',12)
text(0.5,-0.28,'(a)','Units','normalized','HorizontalAlignment','center','FontSize',12)

subplot(2,1,2)
plot(idx1, b(idx1), 'LineWidth', 0.6)
hold on
xline(idx1(end),'--k','LineWidth',1.5)
text(idx1(end)+500, -420, 'Compression ratio = 50%', ...
     'FontSize',12,'FontWeight','bold','Color','k')
grid on
axis([0 idx(end) -500 500])
xlabel('Sample index')
ylabel('Amplitude')
set(gca,'FontSize',12)
text(0.5,-0.28,'(b)','Units','normalized','HorizontalAlignment','center','FontSize',12)

exportgraphics(gcf,'CS_Overview.png','Resolution',300);
