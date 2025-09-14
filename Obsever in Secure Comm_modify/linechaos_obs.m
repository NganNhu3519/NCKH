function [dxdt,y,xhat,s]= linechaos_obs(t,x)
global R N L M
global a a1 a2 a3
global C

% tspan = 0:0.01:100;  
% n = length (t);
%s= 0.3*cos(pi*t);
%s=3;
% s_trans = s_trans';
load orig_sig
% psi=dctmtx(n); % sparsitying transform for ECG signals 
% 
% s_trans_transform=psi*s_trans;
% 
% %% Find out the minimum value of K
%  K=60; % sparsity of signal
% %K=length(find(abs(x_transform)>.05));
% m=6*K; % the number of measurements 
% 
% %% Sensing matrix construction
% phi1=randi([0 1],n,n); %bernoulli
% phi1(phi1==0)=-1;
% 
% %% Sensing using CS 
% s = phi1*s_trans;
% % load ECGsignal.mat
% s=ecgsig(1:1000,1)
% s=x1;
% master system
dxdt1 = [x(2,:).*x(3,:)+a1*s(1+100*t); x(1,:).*abs(x(1,:))-x(2,:).*abs(x(2,:))+a2*s(1+100*t); abs(x(1,:))-a*x(1,:).*x(2,:)+a3*s(1+100*t)];
y=C*[x(1,:);x(2,:);x(3,:);s(1+100*t)];

% observer system
xhat=[x(4,:);x(5,:);x(6,:);x(7,:)]+M*y;

dxdt2=N*[x(4,:);x(5,:);x(6,:);x(7,:)]+R*[xhat(2,:).*xhat(3,:);xhat(1,:).*abs(xhat(1,:))-xhat(2,:).*abs(xhat(2,:));abs(xhat(1,:))-a*xhat(1,:).*xhat(2,:)]+L*y;

dxdt =[dxdt1;dxdt2];
end