% x1
figure;
plot(t, x(:,1), t, x_est(1,:));
grid on;
xlabel('time');
legend('Original state x_1','Estimated state');
exportgraphics(gcf,'State_x1.png','Resolution',300);

% x2
figure;
plot(t, x(:,2), t, x_est(2,:));
grid on;
xlabel('time');
legend('Original state x_2','Estimated state');
exportgraphics(gcf,'State_x2.png','Resolution',300);

% x3
figure;
plot(t, x(:,3), t, x_est(3,:));
grid on;
xlabel('time');
legend('Original state x_3','Estimated state');
exportgraphics(gcf,'State_x3.png','Resolution',300);

% z (transmitted vs estimated)
figure;
plot(t, z, t, x_est(4,:));
grid on;
xlabel('time');
legend('Transmitted signal','Estimated signal');
exportgraphics(gcf,'Transmitted & Estimated.png','Resolution',300);

%% Plot cho Sine & Sine
% x1
figure;
plot(plotData.t, plotData.x_true(:,1), ...
     plotData.t, plotData.x_est(1,:));
grid on;
xlabel('time');
legend('Original state x_1','Estimated state');
exportgraphics(gcf,'State_x1.png','Resolution',300);

% x2
figure;
plot(plotData.t, plotData.x_true(:,2), ...
     plotData.t, plotData.x_est(2,:));
grid on;
xlabel('time');
legend('Original state x_2','Estimated state');
exportgraphics(gcf,'State_x2.png','Resolution',300);

% x3
figure;
plot(plotData.t, plotData.x_true(:,3), ...
     plotData.t, plotData.x_est(3,:));
grid on;
xlabel('time');
legend('Original state x_3','Estimated state');
exportgraphics(gcf,'State_x3.png','Resolution',300);

% z (transmitted vs estimated)
figure;
plot(plotData.t, plotData.z, ...
     plotData.t, plotData.x_est(4,:));
grid on;
xlabel('time');
legend('Transmitted signal','Estimated signal');
exportgraphics(gcf,'Transmitted_Estimated.png','Resolution',300);