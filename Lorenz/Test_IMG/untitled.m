clear; close all; clc;

global z_interp
global sigma_L rho_L beta_L
global a1 a2 a3
global C R N L M rho

sigma_L = 10;
rho_L   = 28;
beta_L  = 8/3;

a1 = 1; a2 = 1; a3 = 1;

C = [1 0 0 0];
R = eye(3);
N = eye(4);
L = ones(4,1);
M = ones(4,1);
rho = 1;

Img = imread('tire.tif');
Img = Img([51:150],[51:150]);
x = double(Img(:));
x = (x - mean(x)) / std(x);

t_img = linspace(0,40,length(x));

g = fspecial('gaussian',[31 1],5);
x_s = conv(x,g(:),'same');

z_interp_raw = @(tt) interp1(t_img,x,tt,'previous',x(end));
z_interp_s   = @(tt) interp1(t_img,x_s,tt,'linear',x_s(end));

x0 = [1;1;1;0;0;0;0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-8);

disp('--- RAW IMAGE ---')
z_interp = z_interp_raw;
tic;
ode45(@lorenz_smo,[0 2],x0,opts);
disp(['RAW time = ',num2str(toc)])

disp('--- SMOOTH IMAGE ---')
z_interp = z_interp_s;
tic;
ode45(@lorenz_smo,[0 2],x0,opts);
disp(['SMOOTH time = ',num2str(toc)])


function dxdt = lorenz_smo(t, x)
global R N L M rho
global a1 a2 a3     
global C
global sigma_L rho_L beta_L
global z_interp

z = z_interp(t);

x1 = x(1); 
x2 = x(2); 
x3 = x(3);

f1 = sigma_L * (x2 - x1);                    
f2 = x1 * (rho_L - x3) - x2;                
f3 = x1 * x2 - beta_L * x3;                

dxdt1 = [ f1 + a1*z;                          
          f2 + a2*z;
          f3 + a3*z ];

y = C * [x1; x2; x3; z];

xhat = [x(4); x(5); x(6); x(7)] + M * y;

e = y - C * xhat;

xh1 = xhat(1); 
xh2 = xhat(2); 
xh3 = xhat(3);

fh1 = sigma_L * (xh2 - xh1);
fh2 = xh1 * (rho_L - xh3) - xh2;
fh3 = xh1 * xh2 - beta_L * xh3;

G_l = 0.01 * eye(size(L,1), size(C,1));
linear_injection = - G_l * e;

dxdt2 = N * [x(4); x(5); x(6); x(7)] + ...
        L * (y + rho*tanh(10*e)) + linear_injection;

dxdt = [dxdt1; dxdt2];
end
