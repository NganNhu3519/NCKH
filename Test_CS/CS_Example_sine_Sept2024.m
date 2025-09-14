% Author: Uyen L.P. Nguyen 
% Date: Sept 2024

close all;clear all; clc;

%% Define parameters
N = 1000; % signal length

%% finding the K value of an approximately sparse signal
% load ecgsig.mat
% x=ecgsig(1:N,1);
t = 0.01:0.01:10;
x = 0.3*cos(pi*t);
x = x';
psi = dctmtx(N); % sparsitying transform for ECG signals 
x_transform = psi*x;
%% Find out the minimum value of K
K = 60; % sparsity of signal
%K=length(find(abs(x_transform)>.05));
M=6*K; % the number of measurements 

%% Sensing matrix construction
phi1=randi([0 1],400,N); %bernoulli
phi1(phi1==0)=-1;

%% Sensing using CS 
y1 = phi1*x;
Theta1 = phi1*psi';
s21 = pinv(Theta1)*y1;
s1 = l1eq_pd(s21,Theta1,Theta1',y1,5e-3,20); % L1-magic toolbox
x1 = psi'*s1;
%% Reconstruction with 
figure;plot(y1);title('linear measurement y')
figure;plot(x); hold on; plot(x1, 'r.'); title('bernoulli'); legend('Original', 'Recovered');
mse1 = mse(x,x1);
disp('ECG signal')
fprintf('MSE of Ber: %d \n',mse1)





%================================================================================
% %% FUNCTION
% %% Generate Mixing Sequence by Comparing 2 Logistic Map
% function [ output_args ] = LogisticMap2BitGen(r1, x0, r2, y0,N)
% % x0 - initial of first Logistic Map
% % y0 - initial of second Logistic Map
% % N - number of iteration - time series
% % r1 r2 - r value for chaos
% 
% % First Logistic Map
% x=zeros(N,1);                           % allocate memory
% x(1) = x0;                                 % initial condition (can be anything from 0 to 1)
%     for i = 2 : N  % iterate
%         x(i) = r1 * x(i-1) * (1-x(i-1));
%     end
%     
%  % Second Logistic Map
% y=zeros(N,1);                             % allocate memory
% y(1) = y0;                                   % initial condition (can be anything from 0 to 1)
%     for i = 2:(N) % iterate
%         y(i) = r2 * y(i-1) * (1-y(i-1));
%     end
%     
% %Comparing bw xy and then generating the sequence contained +-1 binary
% %value
%   output_args=zeros(N,1); 
%     for i = 1 : N % iterate
%          if x(i) > y(i)
%         output_args(i) = 1;
%    else  output_args(i) = -1;
%          end
%     end
% end
% %% Generate Mixing Sequence 
% % Quadratic Sequence Xi+1=a*Xi^2+b*Xi+c mod m 
% function x = QuadCongruentialSeq(a,b,c,m,x0,M,numChannel)
% % Entry
% % a,b,c,m belong to sequence
% % x0- seed or intial point
% % M - L subbands
% %NumChannel: number input channel 
% 
% % First Quad. Sequence
% x = zeros(1,numChannel*M); %create a matrix with 4 rows and Niter col => use for sensing matrix later
% x(1)=x0;
% 
% for i=1:(numChannel*M-1)
%     x(i+1) = mod(a*x(i)^2 + b*x(i) + c,m);
% end
% end
%     
% %% Funct 
% function [output_args] = GeneratorBasedCongr(x,y,numChannel, M )
%     
% %Comparing bw xy and then generating the sequence contained +-1 binary
% %value
%   x_new=zeros(numChannel, M);
%     for i = 1 : (numChannel*M) % iterate
%          if x(i) > y(i)
%         x_new(i) = 1;
%    else  x_new(i) = -1;
%          end
%     end
% output_args = reshape(x_new,[numChannel M]);
% end
