close all; clear; clc;

global a1 a2 a3 C                
global R N L M rho             
global sigma_L rho_L beta_L    

%% System Initialization
sigma_L = 10;
rho_L   = 28;          
beta_L  = 8/3;
          
a1 = 1; 
a2 = 1; 
a3 = 2;

% System matrices
E = [1,0,0,0;
     0,1,0,0;
     0,0,1,0];    

A = [0,0,0,a1;
     0,0,0,a2;
     0,0,0,a3];       

C = [1 0 0 0;
     0 1 0 0;
     0 0 0.01 1];

cond_C = cond(C);

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

%% Check Existence of Observer
n = size(A,2);

rank_a = rank([E;C]);
fprintf('Condition (a) rank([E;C]) = %d (need %d)\n', rank_a, n);

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

rank_obsv = rank(obsv(Ahat,C));
fprintf('Condition (c) rank(obsv(Ahat,C)) = %d / %d\n', rank_obsv, size(Ahat,1));

%% Sliding Mode Observer Design
L = 1.5 * pinv(C);
rho = 35;

N = Ahat - L * C;
format short

Eigenvalue = eig(N);
disp(Eigenvalue);
Mtau = linsolve(C', (eye(length(Ehat)) - Ehat)');
M = Mtau';

%% Simulation
tspan = 0.01:0.01:327.68;
% tspan = [0.01 60.01];
x0 = [.1, .1, .1, 0, 0, 0, 0];

% options = odeset('RelTol',1e-4,'AbsTol',1e-6, 'OutputFcn', @odeProgress);
Tend = 327.68;
options = odeset('RelTol',1e-4,'AbsTol',1e-6, ...
                 'OutputFcn', @(t,x,flag) odeWaitbar(t,x,flag,Tend));


[t, x] = ode45(@lorenz_smo, tspan, x0, options); %mã hóa chaotic

tic
[~, y, x_est, z] = lorenz_smo(t', x');
recon = toc;

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
title('IMG Error dynamics of z');
grid on;

%% NMSE
% mse_img = mse(z,x_est(4,:));
z_norm     = z / max(abs(z));
x_est_norm = x_est(4,:) / max(abs(z));
error_z    = z_norm - x_est_norm;
nmse_img = mean(error_z.^2);

psnr_img = 10*log10(1/nmse_img);
Co = corrcoef(z, x_est(4,:));
CC = Co(1,2);

format long
fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %d \n',nmse_img)
fprintf('PSNR (Correct): %.4f dB\n', psnr_img);
fprintf('Correlation Coefficient: %f\n', CC);

%% Sliding Mode Observer Function (Lorenz)
function [dxdt, y, xhat, z] = lorenz_smo(t, x)
global R N L M rho
global a1 a2 a3     
global C sigma_L rho_L beta_L

load y_img_NIST_ver1.mat
% y_cp = y_cp';
y_cp = b.';
z = y_cp(uint16(100*t));

% Lorenz
x1 = x(1,:); 
x2 = x(2,:); 
x3 = x(3,:);

f1 = sigma_L * (x2 - x1);                    
f2 = x1 .* (rho_L - x3) - x2;                
f3 = x1 .* x2 - beta_L * x3;                

dxdt1 = [ f1 + a1*z;                          
          f2 + a2*z;
          f3 + a3*z];

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

% % Nonlinear injection
k1 = 1.2;
k2 = 1.2;
alpha = 0.3;
beta  = 1.3;

% phi_nl = -k1 .* sign(e) .* abs(e).^alpha ...
%          -k2 .* sign(e) .* abs(e).^beta;
phi_nl = -k1 .* tanh(2*e) .* (abs(e) + 1e-6).^alpha ...
         -k2 .* tanh(2*e) .* (abs(e) + 1e-6).^beta;
G_nl = 0.008 * ones(size(L,1), size(C,1));
nonlinear_injection = G_nl * phi_nl;

dxdt2 = N * [x(4,:); x(5,:); x(6,:); x(7,:)] + ...
        R * [fh1; fh2; fh3] + ...
      + L*(y + rho*tanh(2*e)) + nonlinear_injection;

dxdt = [dxdt1; dxdt2];
end

%%
function status = odeWaitbar(t, x, flag, Tend)
persistent h last_t
status = 0;

SAVE_INTERVAL = 0.5;

if strcmp(flag,'init')
    h = waitbar(0,'Running...');
    last_t = 0;

elseif isempty(flag)
    if t(end) - last_t >= SAVE_INTERVAL
        waitbar(min(1, t(end)/Tend), h, sprintf('t = %.1f s', t(end)));
        last_t = t(end);
    end

elseif strcmp(flag,'done')
    if isvalid(h), close(h); end
end
end

%%
% save("img_noblock_ver7.mat",'x_est');
% save("img_0block_ver7.mat");
% save("img_Rcos_work_ver5.mat");

% save("img_Rcos_ver7.mat",'x_est');
% save("img_Rcos_ver7_F2_workspace.mat");

save("img_NIST_ver1.mat",'x_est');
save("img_NIST_ver1_work.mat");