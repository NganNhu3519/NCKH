% Design a sliding mode observer to reconstruct the transmitted signal at the receiver
% Lorenz system with z(t) injection via [a1 a2 a3]
% Date: July 3, 2025

close all; clear all; clc;

% ===== Globals =====
global a1 a2 a3 C                
global R N L M rho                 
global sigma_L rho_L beta_L        

%% System Initialization
% Lorenz parameters
sigma_L = 10;          % sigma
rho_L   = 28;          
beta_L  = 8/3;         % beta
          
a1 = 1;
a2 = 1;
a3 = 1;

% System matrices
E = [1,0,0,0;
     0,1,0,0;
     0,0,1,0];    

A = [0,0,0,a1;
     0,0,0,a2;
     0,0,0,a3];       

%C = randi([0,3],3,4);
C = [1 0 0 0;
     0 1 0 0;
     0 0 0.1 1];
cond_C = cond(C)

r1 = rank(C);
[m1,n1] = size(E);
rank([E;C]);
[U,S,V] = svd(C);
D1 = S(1:r1,1:r1);
P = V * blkdiag(inv(D1), eye(n1-r1));
E2 = E * P * [zeros(r1,n1-r1); eye(n1-r1)]; %Canonical form
[U2,S2,V2] = svd(E2);
r2 = rank(E2);
D2 = S2(1:r2,1:r2);
[rowd2,cold2] = size(D2);
R0 = [zeros(m1+r1-n1,cold2), eye(m1+r1-n1);
      V2*inv(D2), zeros(rowd2,m1+r1-n1)] * U2';
R = P * [zeros(n1-m1,m1); R0];

%Ehat, Ahat Canonical form of E, A
Ahat = R * A;
Ehat = R * E;

% define lmi variables
setlmis([])
P=lmivar(1,[4,1]);
Khat=lmivar(2,[4,3]);
lambda=3; 

% define lmi equations
lmiterm([1,1,1,P],Ahat',1,'s')
lmiterm([1,1,1,Khat],-1,C,'s')

%
lmiterm([1,1,1,0],lambda^2*eye(4))
%
lmiterm([1,1,2,P],1,R)
lmiterm([1,2,2,0],-1)

lmiterm([-2,1,1,P],1,1)

LMI=getlmis;
[tmin,xfeas]=feasp(LMI);
P=dec2mat(LMI,xfeas,P);
Khat=dec2mat(LMI,xfeas,Khat);

K=inv(P)*Khat;
N=Ahat-K*C;
Mtau=linsolve(C',(eye(length(Ehat))-Ehat)');
M=Mtau';
L=K+N*M;
rho = 6.0; %thêm vào
%% Simulation
x0 = [.1, .1, .1, 1, 1, 1, 0];
tspan = 1:1:40;

options = odeset('RelTol',1e-3,'AbsTol',1e-3);
[t, x] = ode45(@lorenz_smo, tspan, x0, options);
[~, y, x_est, z] = lorenz_smo(t', x');

%% Plotting the Results
figure
subplot(2,2,1)
hold on
plot(t, x(:,1), t, x_est(1,:))
grid
xlabel('time')
legend('Original state x_1', 'Estimated state')
set(gca, 'fontsize', 11, 'fontweight', 'bold')

subplot(2,2,2)
hold on
plot(t, x(:,2), t, x_est(2,:))
legend('Original state x_2', 'Estimated state')
grid
xlabel('time')
set(gca, 'fontsize', 11, 'fontweight', 'bold')

subplot(2,2,3)
hold on
plot(t, x(:,3), t, x_est(3,:))
legend('Original state x_3', 'Estimated state')
grid
xlabel('time')
set(gca, 'fontsize', 11, 'fontweight', 'bold')

subplot(2,2,4)
hold on
plot(t, z, t, x_est(4,:))
legend('Transmitted signal', 'Estimated signal')
grid
xlabel('time')
set(gca, 'fontsize', 11, 'fontweight', 'bold')

%% DECLARE FUNCTION
function [dxdt, y, xhat, z] = lorenz_smo(t, x)
global R N L M rho
global a a1 a2 a3     
global C
global sigma_L rho_L beta_L

%Input signal z(t) từ CS
load y_measurement
y_cp = y_cp';
z = y_cp(uint16(100*t));  

% Lorenz plant dynamics (f(x) + B z)
x1 = x(1,:); 
x2 = x(2,:); 
x3 = x(3,:);

f1 = sigma_L * (x2 - x1);                    
f2 = x1 .* (rho_L - x3) - x2;                
f3 = x1 .* x2 - beta_L * x3;                

dxdt1 = [ f1 + a1*z;                          
          f2 + a2*z;
          f3 + a3*z ];

% Output
y = C * [x1; x2; x3; z];

%Observer estimate
xhat = [x(4,:); x(5,:); x(6,:); x(7,:)] + M * y;

%Sliding error
e = y - C * xhat;

%Observer dynamics
xh1 = xhat(1,:); 
xh2 = xhat(2,:); 
xh3 = xhat(3,:);

fh1 = sigma_L * (xh2 - xh1);
fh2 = xh1 .* (rho_L - xh3) - xh2;
fh3 = xh1 .* xh2 - beta_L * xh3;

dxdt2 = N * [x(4,:); x(5,:); x(6,:); x(7,:)] + ...
        R * [fh1; fh2; fh3] + ...
        L * (y + rho * sign(e));

dxdt = [dxdt1; dxdt2];
end
