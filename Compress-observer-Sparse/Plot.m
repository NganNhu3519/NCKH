%% Load saved results
load('smo_results.mat_v1','results');

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
