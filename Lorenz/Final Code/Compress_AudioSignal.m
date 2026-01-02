close all;clear ; clc;

N = 1000;
load chirp.mat
y_audio = y(1:1000);

audiosignal = y_audio;
L = round(length(audiosignal)/N); 

psi=dctmtx(N);

M = 500;
y_cs = zeros(M,L);

phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;

x1 = zeros(N,1);
for i=1:L
x1=audiosignal(1+(i-1)*N:N*i,1);
y1 = phi*x1;
y_cs(:,i) = y1;
end

%Save file

% y_cp = y_cs(:);
% save('y_Audio_ver1.mat','phi','y_cp','psi')

%% Plot
load y_Audio_v1.mat
% Original audio signal
figure;
plot(audiosignal,'LineWidth',1.2);
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Original Signal');
exportgraphics(gcf,'Original_Signal.png','Resolution',300);

% Compressed measurements
figure;
plot(y_cp,'k','LineWidth',1);
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Compressed Measurements');
exportgraphics(gcf,'Compressed_Measurements.png','Resolution',300);

% Histogram of original audio
figure;
histogram(audiosignal,30);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Original');
exportgraphics(gcf,'Histogram_Original.png','Resolution',300);

% Histogram of compressed audio
figure;
histogram(y_cp,30);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Compressed');
exportgraphics(gcf,'Histogram_Compressed.png','Resolution',300);
