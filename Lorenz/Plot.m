%% ================== SINE ==================
clear; clc; close all;

load('D:\NCKH\Github\NCKH\Lorenz\Result\Result_Plot\Sine_v1.mat','plotData');

t       = plotData.t;
x       = plotData.x_true;
x_est   = plotData.x_est;
z       = plotData.z;
error_z = plotData.error_z;
nmse    = plotData.NMSE;

% Figure 1: States and transmitted signal
figure;
subplot(2,2,1); plot(t,x(:,1),t,x_est(1,:)); grid on; legend('x1','x1 est');
xlabel('time'); ylabel('x1');
subplot(2,2,2); plot(t,x(:,2),t,x_est(2,:)); grid on; legend('x2','x2 est');
xlabel('time'); ylabel('x2');
subplot(2,2,3); plot(t,x(:,3),t,x_est(3,:)); grid on; legend('x3','x3 est');
xlabel('time'); ylabel('x3');
subplot(2,2,4); plot(t,z,t,x_est(4,:)); grid on; legend('z','z est');
xlabel('time'); ylabel('Signal');

% Figure 2: Error dynamics
figure;
plot(t,error_z,'LineWidth',1.2); grid on;
xlabel('time'); ylabel('Error of z');
title('Error dynamics of z');

% Print NMSE
fprintf('NMSE (Sine) = %.6e\n', nmse);


%% ================== ECG ==================
clear; clc; close all;

load('D:\NCKH\Github\NCKH\Lorenz\Result\Result_Plot\ECG_v1.mat','plotData');

t       = plotData.t;
x       = plotData.x_true;
x_est   = plotData.x_est;
z       = plotData.z;
error_z = plotData.error_z;
nmse    = plotData.NMSE;

figure;
subplot(2,2,1); plot(t,x(:,1),t,x_est(1,:)); grid on; legend('x1','x1 est');
xlabel('time'); ylabel('x1');
subplot(2,2,2); plot(t,x(:,2),t,x_est(2,:)); grid on; legend('x2','x2 est');
xlabel('time'); ylabel('x2');
subplot(2,2,3); plot(t,x(:,3),t,x_est(3,:)); grid on; legend('x3','x3 est');
xlabel('time'); ylabel('x3');
subplot(2,2,4); plot(t,z,t,x_est(4,:)); grid on; legend('z','z est');
xlabel('time'); ylabel('Signal');

figure;
plot(t,error_z,'LineWidth',1.2); grid on;
xlabel('time'); ylabel('Error of z');
title('Error dynamics of z');

fprintf('NMSE (ECG) = %.6e\n', nmse);


%% ================== AUDIO ==================
clear; clc; close all;

load('D:\NCKH\Github\NCKH\Lorenz\Result\Result_Plot\Audio_v1.mat','plotData');

t       = plotData.t;
x       = plotData.x_true;
x_est   = plotData.x_est;
z       = plotData.z;
error_z = plotData.error_z;
nmse    = plotData.NMSE;

figure;
subplot(2,2,1); plot(t,x(:,1),t,x_est(1,:)); grid on; legend('x1','x1 est');
xlabel('time'); ylabel('x1');
subplot(2,2,2); plot(t,x(:,2),t,x_est(2,:)); grid on; legend('x2','x2 est');
xlabel('time'); ylabel('x2');
subplot(2,2,3); plot(t,x(:,3),t,x_est(3,:)); grid on; legend('x3','x3 est');
xlabel('time'); ylabel('x3');
subplot(2,2,4); plot(t,z,t,x_est(4,:)); grid on; legend('z','z est');
xlabel('time'); ylabel('Signal');

figure;
plot(t,error_z,'LineWidth',1.2); grid on;
xlabel('time'); ylabel('Error of z');
title('Error dynamics of z');

fprintf('NMSE (Audio) = %.6e\n', nmse);
