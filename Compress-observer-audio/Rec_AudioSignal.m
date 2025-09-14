% Author: Uyen L.P. Nguyen 
% Date: Sept 2024
% Reconstruct Audio signal

close all;clear all;clc;

%% Define Audio Signal again 

load gong.mat
y_audio = y(1:40000);
audioSignal=y_audio;
audio_new = zeros(40000/4,1);
for k=1:(10000)
    audio_new(k) = audioSignal(k*4);
end
%% Load WS-Inputv in
L =10; % num of block of audio signal
N = 1000;

load y_measurement.mat
load x_est.mat
y_new = x_est(4,:)';
M = length(y_new)/L;  % length of y new
Theta = phi*psi';
for i=1 : L
s21 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
s1 = l1eq_pd(s21,Theta,Theta',y_new(M*(i-1)+1: M*i),5e-3,20); % L1-magic toolbox
x1(:,i) = psi'*s1;
end
x_rec = x1(:);

%% Reconstruction
%  figure;plot(y_cp);title('linear measurement y')
%  figure;
%  plot(audio_new); hold on; 
%  plot(x_rec, 'r.'); title('Audio Signal Reconstruction');
%  legend('Original', 'Recovered');

figure;
subplot(211),plot(y_cp,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
      ylim([-15 15])
subplot(212),plot(audio_new,'LineWidth',2); hold on; plot(x_rec, 'r.','MarkerSize',10);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
sgtitle('ECG signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)
mse1 = mse(audio_new,x1);
disp('Audio signal')
fprintf('MSE of Audio: %d \n',mse1)
 
  %% Sound
% sound(audio_new,Fs);        % original audio
% pause(3)
% sound((x_est(3,:))',Fs);    % compress-encrypted audio
% pause(3)
% sound(x_rec,Fs);            % reconstructed audio