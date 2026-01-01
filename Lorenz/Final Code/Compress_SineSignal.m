close all;clear all; clc;

% Define parameters
N = 1000;

t = 0.01:0.01:10;
x_in = 0.3*cos(pi*t);
x_in = x_in';
psi = dctmtx(N);  

M=400;

%Sensing matrix construction
phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;

% Sensing using CS 
% y = phi*x_in;
% y_cp =y;

% save('y_sine.mat','phi','y_cp')

%% Plot
load y_sine_v1.mat
% (a) Original signal
figure;
plot(x_in,'LineWidth',1.2);
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Original Signal');
exportgraphics(gcf,'Original_Signal.png','Resolution',300);

% (b) Compressed measurements
figure;
plot(y_cp,'k','LineWidth',1);
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Compressed Measurements');
exportgraphics(gcf,'Compressed_Measurements.png','Resolution',300);

% (c) Histogram of original signal
figure;
histogram(x_in,30);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Original');
exportgraphics(gcf,'Histogram_Original.png','Resolution',300);

% (d) Histogram of compressed signal
figure;
histogram(y_cp,30);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Compressed');
exportgraphics(gcf,'Histogram_Compressed.png','Resolution',300);
