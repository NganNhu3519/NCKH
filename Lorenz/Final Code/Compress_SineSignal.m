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

%% Chia block
close all;clear all; clc;
N = 500;
t = 0.01:0.01:10;
x_in = 0.3*cos(pi*t);
x_in = x_in(:);

L = round(length(x_in)/N);

psi = dctmtx(N);  
M = 250;
y_cs = zeros(M, L);
phi=randi([0 1],M,N);
phi(phi==0)=-1;
x1 = zeros(N,1);
for i = 1:L
    x1 = x_in(1 + (i-1)*N : N*i, 1);
    y1 = phi * x1;
    y_cs(:, i) = y1;
end
% Save file
y_cp = y_cs(:);
save('y_Sine_Chiablock.mat','phi','y_cp','psi');

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
