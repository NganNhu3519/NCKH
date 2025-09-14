% Design a sliding mode observer to reconstruct the transmitted signal at the receiver
% Date: July 3, 2025

close all; clear all; clc;
%load y_measurement
global a a1 a2 a3 C
global R N L M rho

%% System Initialization
%rng(0);
a = 1.7; % System parameter
% Random coefficients for matrix A
a1 = 1;
a2 = 2;
a3 = 1;

% System matrices
E = [1,0,0,0; 0,1,0,0; 0,0,1,0];
A = [0,0,0,a1; 0,0,0,a2; 0,0,0,a3];
C = [1,0,0,1; 0,1,0,1; 0,0,0,2]; % Random output matrix

% Compute matrix R (same as original for system transformation)
r1 = rank(C);
[m1,n1] = size(E);
rank([E;C]);
[U,S,V] = svd(C);
D1 = S(1:r1,1:r1);
P = V * blkdiag(inv(D1), eye(n1-r1));
E2 = E * P * [zeros(r1,n1-r1); eye(n1-r1)];
[U2,S2,V2] = svd(E2);
r2 = rank(E2);
D2 = S2(1:r2,1:r2);
[rowd2,cold2] = size(D2);
R0 = [zeros(m1+r1-n1,cold2), eye(m1+r1-n1); V2*inv(D2), zeros(rowd2,m1+r1-n1)] * U2';
R = P * [zeros(n1-m1,m1); R0];

Ahat = R * A;
Ehat = R * E;

%% Sliding Mode Observer Design
% Define sliding surface: e = C*(x - xhat) = 0
% Choose observer gain L to ensure sliding mode
% Assume C has full row rank for simplicity
% for tuning
% L =pinv(C); % Observer gain (pseudo-inverse of C for sliding mode)
% rho = 10; % Sliding mode gain (tunable, ensures robustness)
L =0.8* pinv(C); % Observer gain (pseudo-inverse of C for sliding mode)
rho = 8; % Sliding mode gain (tunable, ensures robustness)

% Define N and M matrices (similar to original for consistency)
N = Ahat - L * C; % Observer dynamics matrix
Mtau = linsolve(C', (eye(length(Ehat)) - Ehat)');
M = Mtau'; % Matrix to reconstruct the input

%% Simulation
x0 = [.1, .1, .1, 1, 1, 1, 0]; % Initial conditions
% tspan = 1:1:120;
tspan = 1:1:20;

options = odeset('RelTol', 1e-3, 'AbsTol', 1e-3);
[t, x] = ode45(@linechaos_smo, tspan, x0, options);
[~, y, x_est, z] = linechaos_smo(t', x');

%% Plotting the Results
figure
subplot(2,2,1)
hold on
plot(t, x(:,1), t, x_est(1,:))
grid
xlabel('time')
legend('Original state x_1', 'Estimated state')
set(gca, 'fontsize', 11)
set(gca, 'fontweight', 'bold')

subplot(2,2,2)
hold on
plot(t, x(:,2), t, x_est(2,:))
legend('Original state x_2', 'Estimated state')
grid
xlabel('time')
set(gca, 'fontsize', 11)
set(gca, 'fontweight', 'bold')

subplot(2,2,3)
hold on
plot(t, x(:,3), t, x_est(3,:))
legend('Original state x_3', 'Estimated state')
grid
xlabel('time')
set(gca, 'fontsize', 11)
set(gca, 'fontweight', 'bold')

subplot(2,2,4)
hold on
plot(t, z, t, x_est(4,:))
legend('Transmitted signal', 'Estimated signal')
grid
xlabel('time')
set(gca, 'fontsize', 11)
set(gca, 'fontweight', 'bold')

%% Sliding Mode Observer Function
function [dxdt, y, xhat, z] = linechaos_smo(t, x)
global R N L M rho
global a a1 a2 a3
global C
% Sliding mode gain (defined globally or passed)
%rho = 15;

% Load or define the input signal
load y_measurement
y_cp = y_cp(1:20)';
z = y_cp(uint16(t));

% Master system dynamics (same as original)
dxdt1 = [x(2,:).*x(3,:)+a1*z; x(1,:).*abs(x(1,:))-x(2,:).*abs(x(2,:))+a2*z; abs(x(1,:))-a*x(1,:).*x(2,:)+a3*z];

% Output
y = C * [x(1,:); x(2,:); x(3,:); z];

% Observer states
xhat = [x(4,:); x(5,:); x(6,:); x(7,:)] + M * y;

% Sliding mode term: sign(C*(x - xhat))
e = y - C * xhat; % Output error
%v = rho * sign(e); % Sliding mode control term
v = L * (rho * sign(e));

% Observer dynamics: dxhat/dt = N*x_observer + R*nonlinear(xhat) + L*y + v
dxdt2 = N * [x(4,:); x(5,:); x(6,:); x(7,:)] + ...
        R * [xhat(2,:).*xhat(3,:); xhat(1,:).*abs(xhat(1,:))-xhat(2,:).*abs(xhat(2,:)); abs(xhat(1,:))-a*xhat(1,:).*xhat(2,:)] + ...
        L * (y + rho * sign(e));

dxdt = [dxdt1; dxdt2];
end