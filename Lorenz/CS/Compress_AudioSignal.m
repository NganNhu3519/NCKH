% Audio Signal 
% Author: Uyen L.P. Nguyen 
% Date: Sept 2024

close all;clear all; clc;

%% Define parameters
N = 1000; % signal length
load gong.mat
y_audio = y(1:40000);

audioSignal=y_audio;
audio_new = zeros(40000/4,1);
for k=1:(10000)
    audio_new(k) = audioSignal(k*4);
end
L=round(length(audio_new)/N);
% sound(audioSignal,Fs); % for listening the sound 

psi=dctmtx(N); % sparsitying transform for ECG signals 
x_transform=psi*audioSignal(1:N,1);
%% Find out the minimum value of K
% K=60; % sparsity of signal
% %K=length(find(abs(x_transform)>.05));
% M=6*K; % the number of measurements 
M =400;

%% Sensing matrix construction
phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;
x1 = zeros(N,1);
for i=1:L
x1=audio_new(1+(i-1)*N:N*i,1); %% taking a block of signal 
y1 = phi*x1;
y_cs(:,i) = y1;
end

y_cp = y_cs(:);
save('y_measurement.mat','phi','y_cp','psi')