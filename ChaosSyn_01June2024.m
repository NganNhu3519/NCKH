close all
clear all
clc
% Lorenz system parameters
global c
c = 2;

% Initial conditions for transmitter and receiver systems
x0_tx = 1;
y0_tx = 2;
z0_tx = 3;

x0_rx = -1;
y0_rx = -2;
z0_rx = -3;

% Simulate the transmitter system
[T, out_tx] = ode45(@lorenz, [0 10], [x0_tx, y0_tx, z0_tx]);
x_tx = out_tx(:,1);
y_tx = out_tx(:,2);
z_tx = out_tx(:,3);

% Simulate the receiver system with adaptive control
[t, out_rx] = ode45(@lorenz_adaptive, [0 10], [x0_rx, y0_rx, z0_rx]);
x_rx = out_rx(:,1);
y_rx = out_rx(:,2);
z_rx = out_rx(:,3);

%% Plot the results
% figure;
% subplot(3,1,1);
% plot(t, x_tx, 'b', t, x_rx, 'r');
% title('X states');
% legend('Transmitter', 'Receiver');
% 
% subplot(3,1,2);
% plot(t, y_tx, 'b', t, y_rx, 'r');
% title('Y states');
% legend('Transmitter', 'Receiver');
% 
% subplot(3,1,3);
% plot(t, z_tx, 'b', t, z_rx, 'r');
% title('Z states');
% legend('Transmitter', 'Receiver');




%%
function f = lorenz(t,y)
global c
f=zeros(3,1);
f(1)=10*(y(2)-y(1));
f(2)=(24-4*c)*y(1)+c*y(2)-y(1)*y(3);
f(3)=y(1)*y(2)-8/3*y(3);
end

function fsla = lorenz_adaptive(t,y,x_tx,y_tx)
global c
fsla = zeros(3,1);
    % Adaptive control law
    e = y - y_tx;
    k = 1 + abs(e);
fsla=zeros(3,1);
fsla(1)=10*(y(2)-y(1));
fsla(2)=(24-4*c)*y(1)+c*y(2)-y(1)*y(3)+ k*e;
fsla(3)=y(1)*y(2)-8/3*y(3);
end
% 
% function dz = lorenz_adaptive(t, z, a, b, c, x_tx, y_tx)
%     x = z(1);
%     y = z(2);
%     z = z(3);
%     
%     % Adaptive control law
%     e = y - y_tx;
%     k = 1 + abs(e);
%     
%     % Lorenz system dynamics with adaptive control
%     dx = a * (y - x);
%     dy = x * (b - z) - y + k*e;
%     dz = x * y - c * z;
%     
%     dz = [dx; dy; dz];
% end