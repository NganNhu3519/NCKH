close all;clear ; clc;

N = 1000;
load chirp.mat
y_audio = y(1:1000);

audiosignal = y_audio;
L = round(length(audiosignal)/N); 

psi=dctmtx(N);
x_transform = psi*audiosignal(1:N,1);

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
y_cp = y_cs(:);
save('y_Audio_ver1.mat','phi','y_cp','psi')