% Lazaros Moysis
% Youtube channel 
% https://www.youtube.com/@lazarosmoysis5095 
% RG: https://www.researchgate.net/profile/Lazaros-Moysis

% The code implements the Observer design proposed in
% the following work:

% Moysis, L., Volos, C., Pham, V. T., Goudos, S., Stouboulos, I., Gupta, M.
% K., & Mishra, V. K. (2019). Analysis of a chaotic system with line
% equilibrium and its application to secure communications using a
% descriptor observer. Technologies, 7(4), 76.

% https://www.mdpi.com/2227-7080/7/4/76 

% Please cite this work if you use the code below.


% The code is broken in sections. Run each section separately using
% ctr+enter, or by clicking the 'run section' button.

% Details about the observer design are provided in the paper, which is
% open access. We suggest that you read the work first, to get a grasp of
% the code.


%% First, you can simulate the master system alone
clear 
clear global
close all
clc
global a a1 C
global R N L M
a=3.999; 
% x0=[0.1]; tspan=[0:1:800];
% options = odeset('RelTol',1e-4,'AbsTol',1e-4);
% [t,x]=ode45(@logchaos,tspan,x0,options);
x(1)=0.1
N    = 400;
 for ii = 1:N
    x(ii+1) = a*x(ii)*(1 - x(ii));
 end
figure
 plot(x(1:N),x(2:N+1),'rs-')
 xlabel('x_n')
 ylabel('x_{n+1}')
grid on
set(gca,'fontsize',11)
set(gca,'fontweight','bold')


%% Observer  design
% Initialize the system
a=3.999;

% Run this section for random output matrix and random a_i until you find ones that
% satisfy the LMIs.

a1=randi([0,3]);

E=[1,0];
A=[0,a1];


%C=randi([0,3],1,2);
C = [3,4];
% find matrix R
r1=rank(C);
[m1,n1]=size(E);
rank([E;C]);
[U,S,V] = svd(C);
D1=S(1:r1,1:r1);
P=V*blkdiag(inv(D1),eye(n1-r1));
E2=E*P*[zeros(r1,n1-r1);eye(n1-r1)];
[U2,S2,V2] = svd(E2);
r2=rank(E2);
D2=S2(1:r2,1:r2);
[rowd2,cold2]=size(D2);
R0=[zeros(m1+r1-n1,cold2), eye(m1+r1-n1);V2*inv(D2), zeros(rowd2,m1+r1-n1)]*U2'; 
R=P*[zeros(n1-m1,m1);R0];


Ahat=R*A;
Ehat=R*E;

% define lmi variables
setlmis([])
P=lmivar(1,[2,1]);
Khat=lmivar(2,[2,1]);
lambda=3; 

% define lmi equations
lmiterm([1,1,1,P],Ahat',1,'s')
lmiterm([1,1,1,Khat],-1,C,'s')

%
lmiterm([1,1,1,0],lambda^2*eye(2))
%
lmiterm([1,1,2,P],1,R)
lmiterm([1,2,2,0],-1)

lmiterm([-2,1,1,P],1,1)

LMI=getlmis;
[tmin,xfeas]=feasp(LMI);
P=dec2mat(LMI,xfeas,P);
Khat=dec2mat(LMI,xfeas,Khat);

K=inv(P)*Khat;
N=Ahat-K*C;
Mtau=linsolve(C',(eye(length(Ehat))-Ehat)');
M=Mtau';
L=K+N*M;

%% Simulation time!

% Very important. The observer ode function 'linechaos_obs' is written in
% such a way, so that after its simulation, you can call it using the
% output of the ode45, in order to obtain back the internal algebraic
% variables, like the output y, x_estimate, and the unknown input s.


x0=[.1,.1,1];
% %tspan=[0,30]; 
% tspan=[1:1:10000]; 

tspan=[1:1:900];
options = odeset('RelTol',1e-4,'AbsTol',1e-4);

% system and observer solver
[t,x]=ode45(@logchaos_obs,tspan,x0,options); 
% s=0.3*cos(pi*t);
% y=[x(:,1)
%     ,x(:,2),x(:,3),s];
% y=C.*[x(1,:);x(2,:);x(3,:);s]
% run the system again to obtain the internal variables
% s denotes the input
[~,y,x_est,s]=logchaos_obs(t', x');
img_enc = vec2mat(y,30)';
%% Reconstructed img
s_hat=vec2mat(x_est(2,:),30)';   % s is secret img data
figure; 
subplot(1,2,1);imshow(uint8(img_enc));
subplot(1,2,2);imshow(uint8(s_hat));

%% Plotting the results
figure
subplot(1,2,1)
hold all
 plot(t,x(:,1),t,x_est(1,:))
grid
xlabel('time')
legend('Original states x_1','estimated state')
set(gca,'fontsize',11)
set(gca,'fontweight','bold')
% 
subplot(1,2,2)
hold all
plot(t,s,t,x_est(2,:))
legend('Original state x_2','estimated state')
grid
xlabel('time')

set(gca,'fontsize',11)
set(gca,'fontweight','bold')

