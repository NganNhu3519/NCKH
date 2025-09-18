%% Load saved results
clc;close all;clear;
load('smo_results_v2.mat','results');

t = results.t;
x = results.x;
x_est = results.x_est;
z = results.z;
error_z = results.error_z;

%% Replot states and estimated states
figure
subplot(2,2,1)
plot(t, x(:,1), t, x_est(1,:));
legend('Original x1','Estimated x1'); grid on;

subplot(2,2,2)
plot(t, x(:,2), t, x_est(2,:));
legend('Original x2','Estimated x2'); grid on;

subplot(2,2,3)
plot(t, x(:,3), t, x_est(3,:));
legend('Original x3','Estimated x3'); grid on;

subplot(2,2,4)
plot(t, z, t, x_est(4,:));
legend('Transmitted z','Estimated z'); grid on;

%% Replot error dynamics
figure;
plot(t, error_z, 'LineWidth',1.5);
xlabel('time'); ylabel('Error of z');
title('Error dynamics of z'); grid on;

%% Plot chaotic
figure;
plot3(x(:,1), x(:,2), x(:,3));
grid on;
xlabel('x1'); ylabel('x2'); zlabel('x3');
title('Chaotic trajectory');
