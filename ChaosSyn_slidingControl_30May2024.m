close all
clear all
clc

% Set the initial conditions and parameters
x0m = [1; 22; 3];
x0s = [-10; -20; -30];
%k1 = 5; k2 = 10; k3 = 15;
%tspan = [0 20];
tspan = 0 : 0.01 : 100;

% Simulate the master and slave systems
[t,xm] = ode45(@lorenz_master, tspan, x0m);
figure; plot(t,xm(:,1))
[t,xs] = ode45(@(t,xs) lorenz_slave(t,xs,xm), tspan, x0s);

% Plot the results
figure;
subplot(3,1,1);
plot(t, xm(:,1), 'b', t, xs(:,1), 'r');
title('X states');
legend('Master', 'Slave');

subplot(3,1,2);
plot(t, xm(:,2), 'b', t, xs(:,2), 'r');
title('Y states');
legend('Master', 'Slave');

subplot(3,1,3);
plot(t, xm(:,3), 'b', t, xs(:,3), 'r');
title('Z states');
legend('Master', 'Slave');


% Define the Lorenz master and slave systems
function dxm = lorenz_master(t,xm)
    a = 10; b = 28; c = 8/3;
    dxm = [a*(xm(2)-xm(1)); xm(1)*(b-xm(3))-xm(2); xm(1)*xm(2)-c*xm(3)];
end

function dxs = lorenz_slave(t,xs,xm)
    %a = 10; b = 28; c = 8/3;
     a = 10; b = 28; c = 8/3;
%      k1 = 5; k2 = 10; k3 = 15;
        % Adaptive control law
    k1 = 1 + abs(xm(1)-xs(1));
      k2 = 1 + abs(xm(2)-xs(2));
        k3 = 1 + abs(xm(3)-xs(3));
    %dxs = [a*(xs(2)-xs(1)); xs(1)*(b-xs(3))-xs(2) + k1*(xm(1)-xs(1));xs(1)*xs(2)-c*xs(3) + k2*(xm(2)-xs(2)) + k3*(xm(3)-xs(3))];
     dxs = [a*(xs(2)-xs(1)); xs(1)*(b-xs(3))-xs(2) + k2*(xm(2)-xs(2)); xs(1)*xs(2)-c*xs(3)  + k3*(xm(3)-xs(3))];
      %dxs = [a*(xs(2)-xs(1)); xs(1)*(b-xs(3))-xs(2); xs(1)*xs(2)-c*xs(3)];
end