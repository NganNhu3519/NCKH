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

psi=dctmtx(N);
x_transform = psi*audioSignal(1:N,1);

%% Find out the minimum value of K
M = 600;
y_cs = zeros(M,L);

%% Sensing matrix construction
phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;

x1 = zeros(N,1);
for i=1:L
x1=audio_new(1+(i-1)*N:N*i,1);
y1 = phi*x1;
y_cs(:,i) = y1;
end

% for i=1:L
% x1=audio_new(1+(i-1)*N:N*i,1);
% x_transform = psi*x1;
% y1 = phi*x_transform;
% y_cs(:,i) = y1;
% end

%Save file
y_cp = y_cs(:);
save('y_Audio.mat','phi','y_cp','psi')