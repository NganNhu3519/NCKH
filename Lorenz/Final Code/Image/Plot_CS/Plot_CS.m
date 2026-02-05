clear; close all; clc;

load data_CS.mat
Img = double(imread('cameraman.tif'));
b = y(:); % vector nén
x = Img(:); % vector gốc

figure
plot(x,'k','LineWidth',0.8)
grid on
xlabel('Sample index')
ylabel('Amplitude')

figure
plot(b,'k','LineWidth',0.8)
grid on
xlabel('Sample index')
ylabel('Amplitude')
