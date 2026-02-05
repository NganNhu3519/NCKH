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

%%
load img_NIST_ver1_work
t_min = t(1);
t_view = 5;

FIG_W = 700;
FIG_H = 1200;

figure('Units','pixels','Position',[100 100 FIG_W FIG_H])

subplot(5,1,1)
plot(t, x(:,1), t, x_est(1,:), 'LineWidth', 1.2)
grid on
ylabel('State amplitude')
xlabel('Time (s)')
legend('Original state x_1','Estimated state','Location','best','FontSize',8)
xlim([t_min t_min + t_view])
set(gca,'FontSize',9)
text(0.5,-0.4,'(a)','Units','normalized','HorizontalAlignment','center','FontSize',9)

subplot(5,1,2)
plot(t, x(:,2), t, x_est(2,:), 'LineWidth', 1.2)
grid on
ylabel('State amplitude')
xlabel('Time (s)')
legend('Original state x_2','Estimated state','Location','best','FontSize',8)
xlim([t_min t_min + t_view])
set(gca,'FontSize',9)
text(0.5,-0.4,'(b)','Units','normalized','HorizontalAlignment','center','FontSize',9)

subplot(5,1,3)
plot(t, x(:,3), t, x_est(3,:), 'LineWidth', 1.2)
grid on
ylabel('State amplitude')
xlabel('Time (s)')
legend('Original state x_3','Estimated state','Location','best','FontSize',8)
xlim([t_min t_min + t_view])
set(gca,'FontSize',9)
text(0.5,-0.4,'(c)','Units','normalized','HorizontalAlignment','center','FontSize',9)

subplot(5,1,4)
plot(t, z, t, x_est(4,:), 'LineWidth', 1.2)
grid on
ylabel('Signal amplitude')
xlabel('Time (s)')
legend('Transmitted signal','Estimated signal','Location','best','FontSize',8)
xlim([t_min t_min + t_view])
set(gca,'FontSize',9)
text(0.5,-0.4,'(d)','Units','normalized','HorizontalAlignment','center','FontSize',9)

subplot(5,1,5)
plot(t, z - x_est(4,:), 'LineWidth', 1.5)
grid on
ylabel('Estimation error')
xlabel('Time (s)')
ylim([-100 100])
xlim([t_min t_min + t_view])
set(gca,'FontSize',9)
text(0.5,-0.4,'(e)','Units','normalized','HorizontalAlignment','center','FontSize',9)

exportgraphics(gcf,'SMO_Performance.png','Resolution',300);


