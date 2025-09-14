function [dxdt,y,xhat,s]= linechaos_obs(t,x)
global R N L M
global a a1 a2 a3
global C

s=0.3*cos(pi*t);

% master system
dxdt1 = [x(2,:).*x(3,:)+a1*s ; x(1,:).*abs(x(1,:))-x(2,:).*abs(x(2,:))+a2*s ; abs(x(1,:))-a*x(1,:).*x(2,:)+a3*s];
y=C*[x(1,:);x(2,:);x(3,:);s];

% observer system
xhat=[x(4,:);x(5,:);x(6,:);x(7,:)]+M*y;

dxdt2=N*[x(4,:);x(5,:);x(6,:);x(7,:)]+R*[xhat(2,:).*xhat(3,:);xhat(1,:).*abs(xhat(1,:))-xhat(2,:).*abs(xhat(2,:));abs(xhat(1,:))-a*xhat(1,:).*xhat(2,:)]+L*y;

dxdt =[dxdt1;dxdt2];
end