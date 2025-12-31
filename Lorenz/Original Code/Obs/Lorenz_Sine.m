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
     0 0 0.01 1];
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

%% Check Ranking Conditions (Existence of Observer) =====
n = size(A,2);  % số state = 4 (x1,x2,x3,z)

% (a) Impulse observability: rank([E;C]) = n ?
rank_a = rank([E;C]);
fprintf('Condition (a) rank([E;C]) = %d (need %d)\n', rank_a, n);

% (b) Finite observability: rank([λE - A; C]) = n ?
lambda_list = [0 1 10 1i 10i];
cond_b = true;
for lam = lambda_list
    r = rank([lam*E - A; C]);
    if r < n
        cond_b = false;
        fprintf('Condition (b) FAIL at λ=%s: rank=%d < %d\n', num2str(lam), r, n);
    end
end
if cond_b
    fprintf('Condition (b) seems satisfied (all tested λ OK)\n');
end

% (c) Observability with canonical Ahat
rank_obsv = rank(obsv(Ahat,C));
fprintf('Condition (c) rank(obsv(Ahat,C)) = %d / %d\n', rank_obsv, size(Ahat,1));

%% Sliding Mode Observer Design
L = 1.2 * pinv(C);
rho = 9.0;

% N và M
N = Ahat - L * C;
format short

Eigenvalue = eig(N)
Mtau = linsolve(C', (eye(length(Ehat)) - Ehat)');
M = Mtau';   % xhat = x_obs + M*y

%% Simulation
x0 = [.1, .1, .1, 0, 0, 0, 0];
tspan = 0.01:0.01:4;

options = odeset('RelTol',1e-4,'AbsTol',1e-4); %5e-3
tic
[t, x] = ode45(@lorenz_smo, tspan, x0, options);
recon = toc;
[~, y, x_est, z] = lorenz_smo(t', x');
%save('x_est1.mat','x_est');

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

figure;
plot(t, z - x_est(4,:), 'LineWidth',1.5);
xlabel('time');
ylabel('Error of z');
title('Sine Error dynamics of z');
grid on;

%% MSE
% z = results.z;
% x_est = results.x_est;
if size(z) ~= size(x_est(4,:))
    x_est(4,:) = x_est(4,:)';
end

mse_sine = mse(z,x_est(4,:));
peak_val = max(abs(z));
[peaksnr_sine, snr_sine] = psnr(x_est(4,:), z, peak_val);
R = corrcoef(z, x_est(4,:));
CC = R(1,2);

fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %d \n',mse_sine)
fprintf('PSNR (Correct): %.4f dB\n', peaksnr_sine);
fprintf('SNR: %.4f dB\n', snr_sine);
format long
fprintf('Correlation Coefficient: %f\n', CC);

%% Sliding Mode Observer Function (Lorenz) =====
function [dxdt, y, xhat, z] = lorenz_smo(t, x)
global R N L M rho
global a1 a2 a3     
global C
global sigma_L rho_L beta_L

%Input signal z(t) từ CS
load y_sine
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
        L * (y + rho*sign(e));

dxdt = [dxdt1; dxdt2];
end

%% Result
% results = struct;

% --- Time and states ---
% results.t         = t;                  % time vector
% results.x         = x;                  % true states [x1, x2, x3, z]
% results.x_est     = x_est;              % estimated states
% results.z         = z;                  % true transmitted signal
% results.error_z   = error_z;            % error dynamics of z
% results.NMSE      = nmse_sine;               % NMSE value
% results.x0        = x0;                 % initial condition

% --- System parameters ---
% results.sigma_L   = sigma_L;            % Lorenz sigma
% results.rho_L     = rho_L;              % Lorenz rho
% results.beta_L    = beta_L;             % Lorenz beta
% results.a1        = a1;                 % system input coeff a1
% results.a2        = a2;                 % system input coeff a2
% results.a3        = a3;                 % system input coeff a3

% --- Observer matrices ---
% results.C         = C;                  % observer output matrix
% results.L         = L;                  % SMO gain matrix
% results.rho       = rho;                % SMO tanh gain
% results.N         = N;                  % N matrix
% results.M         = M;                  % M matrix
% results.R         = R;                  % R matrix
% results.Ahat      = Ahat;               % canonical A
% results.Ehat      = Ehat;               % canonical E
% results.Eigenvalue = Eigenvalue;        % eigenvalues of N
% 
% % --- Injection parameters ---
% % k1 = 0.8;
% % k2 = 1.5;
% % alpha = 0.3;
% % beta  = 1.5;
% % G_nl = 0.01 * ones(size(L,1), size(C,1));
% % G_l = 0.01 * eye(size(L,1), size(C,1));
% % 
% % results.k1        = k1;                 % nonlinear injection gain 1
% % results.k2        = k2;                 % nonlinear injection gain 2
% % results.alpha     = alpha;              % nonlinear injection exponent alpha
% % results.beta      = beta;               % nonlinear injection exponent beta
% % results.G_nl      = G_nl;               % nonlinear injection matrix
% % results.G_l       = G_l;                % linear injection matrix
% 
% --- Additional info ---
% results.rank_a    = rank_a;             % rank condition (a)
% results.rank_obsv = rank_obsv;          % rank of observability matrix
% results.cond_C    = cond_C;             % condition number of C
% 
% % Save to .mat file
% % save('D:\NCKH\Github\NCKH\Lorenz\Result\Sine_results_v2.mat','results');
% save('D:\Thungan\Github\NCKH\Lorenz\Result\Sine_results_v3.mat','results');

%% Save load data
% plotData = struct;
% 
% % --- Time and signals ---
% plotData.t       = t;                  % thời gian
% plotData.x_true  = x;                  % trạng thái gốc [x1,x2,x3,z]
% plotData.x_est   = x_est;              % trạng thái ước lượng
% plotData.z       = z;                  % tín hiệu truyền
% plotData.error_z = error_z;            % sai số z
% 
% % --- Metrics ---
% plotData.NMSE    = nmse_sine;               % chỉ số NMSE
% 
% % --- Parameters (optional) ---
% plotData.x0      = x0;                 
% plotData.sigma_L = sigma_L;            
% plotData.rho_L   = rho_L;              
% plotData.beta_L  = beta_L;             
% plotData.k1      = k1;                 
% plotData.k2      = k2;                 
% plotData.alpha   = alpha;              
% plotData.beta    = beta;               
% plotData.rho     = rho;                
% 
% save('D:\NCKH\Github\NCKH\Lorenz\Result\Result_Plot\Sine_v2.mat','plotData');
% save('D:\Thungan\Github\NCKH\Lorenz\Result\Result_Plot\Sine_v3.mat','plotData');
