function [dxdt,y,xhat,s]= logchaos_obs(t,x)
global R N L M
global a a1
global C

%s=0.3*cos(pi*t);
load Img_arr.mat
Img_arr=Img_arr';
s = Img_arr(uint16(t));
% master system
dxdt1 = [a*x(1)*(1-x(1))+a1*s];
y=C*[x(1,:);s];

% observer system
xhat=[x(2,:);x(3,:)]+M*y;

dxdt2=N*[x(2,:);x(3,:)]+R*[a.*xhat(1,:).*(1-xhat(1,:))]+L*y;

dxdt =[dxdt1;dxdt2];
end