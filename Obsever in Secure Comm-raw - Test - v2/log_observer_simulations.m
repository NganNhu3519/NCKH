% Author: Uyen Nguyen LP
% Date: Oct 1-2024

%REF: Moysis, L., Volos, C., Pham, V. T., Goudos, S., Stouboulos, I., Gupta, M.
% K., & Mishra, V. K. (2019). Analysis of a chaotic system with line
% equilibrium and its application to secure communications using a
% descriptor observer. Technologies, 7(4), 76.


%% First, you can simulate the master system alone
clear 
clear global
close all
clc
secretImagePre = double(imread('mri.tif')); 
figure, imshow(uint8(secretImagePre))
Img_org = secretImagePre([51:80],[51:80]);
figure, imshow(uint8(Img_org))
global a a1 C
global R N L M
a=3.999; 
a1=randi([0,3]);
%a1 = 1;
a1= 0.000001;
 C = [300,0.4];

%% Observer  design
% Initialize the system
a=3.999;

% Run this section for random output matrix and random a_i until you find ones that
% satisfy the LMIs.

% a1=randi([0,3]);

E=[1,0];
A=[0,a1];


%C=randi([0,3],1,2);
%C = [3,4];
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
% x0=[0.1]; tspan=[0:1:800];
% options = odeset('RelTol',1e-4,'AbsTol',1e-4);
% [t,x]=ode45(@logchaos,tspan,x0,options);
x(1)=0.003;
z1(1)=0.0001;
z2(1) = 0.001;
load Img_arr.mat
Img_arr=Img_arr';
s =  Img_arr';
  
%s = zeros(1,900);
n    = 900;
  for ii = 1:n
%    s(ii)=0.3*cos(pi*ii);
    x(ii+1) = a*x(ii)*(1 - x(ii))+a1*s(ii);
    y(ii)=C*[x(ii);s(ii)];
    xhat1(ii)=z1(ii)+M(1)*y(ii);
    xhat2(ii)=z2(ii)+M(2)*y(ii);
%   z1(ii+1)=mod((N(1)*z1(ii)+N(3)*z2(ii))+R(1)*(a.*xhat1(ii).*(1-xhat1(ii)))+L(1)*y(ii),255); 
%   z2(ii+1)=mod((N(2)*z1(ii)+N(4)*z2(ii))+R(2)*(a.*xhat2(ii).*(1-xhat2(ii)))+L(2)*y(ii),255);
  z1(ii+1)=(N(1)*z1(ii)+N(3)*z2(ii))+R(1)*(a.*xhat1(ii).*(1-xhat1(ii)))+L(1)*y(ii); 
  z2(ii+1)=(N(2)*z1(ii)+N(4)*z2(ii))+R(2)*(a.*xhat2(ii).*(1-xhat2(ii)))+L(2)*y(ii);
 end
%  img_enc = vec2mat(mod(y,255),30)';
img_enc = vec2mat(y,30)';
img_cons = vec2mat(xhat2,30);
%img_enc_mod256 = mod(img_enc,255);
figure
 plot(x(1:n),x(2:n+1),'rs-')
 xlabel('x_n')
 ylabel('x_{n+1}')
grid on
set(gca,'fontsize',11)
set(gca,'fontweight','bold')

figure;
subplot(131);imshow(uint8(vec2mat(s,30))');title('Original image'); 
subplot(132);imshow(uint8(img_enc ));title('Encrypted Image');
subplot(133);imshow(uint8(img_cons));title('Constructed Image');

 %% Observer  design
% % Initialize the system
% a=3.999;
% 
% % Run this section for random output matrix and random a_i until you find ones that
% % satisfy the LMIs.
% 
% % a1=randi([0,3]);
% 
% E=[1,0];
% A=[0,a1];
% 
% 
% %C=randi([0,3],1,2);
% %C = [3,4];
% % find matrix R
% r1=rank(C);
% [m1,n1]=size(E);
% rank([E;C]);
% [U,S,V] = svd(C);
% D1=S(1:r1,1:r1);
% P=V*blkdiag(inv(D1),eye(n1-r1));
% E2=E*P*[zeros(r1,n1-r1);eye(n1-r1)];
% [U2,S2,V2] = svd(E2);
% r2=rank(E2);
% D2=S2(1:r2,1:r2);
% [rowd2,cold2]=size(D2);
% R0=[zeros(m1+r1-n1,cold2), eye(m1+r1-n1);V2*inv(D2), zeros(rowd2,m1+r1-n1)]*U2'; 
% R=P*[zeros(n1-m1,m1);R0];
% 
% 
% Ahat=R*A;
% Ehat=R*E;
% 
% % define lmi variables
% setlmis([])
% P=lmivar(1,[2,1]);
% Khat=lmivar(2,[2,1]);
% lambda=3; 
% 
% % define lmi equations
% lmiterm([1,1,1,P],Ahat',1,'s')
% lmiterm([1,1,1,Khat],-1,C,'s')
% 
% %
% lmiterm([1,1,1,0],lambda^2*eye(2))
% %
% lmiterm([1,1,2,P],1,R)
% lmiterm([1,2,2,0],-1)
% 
% lmiterm([-2,1,1,P],1,1)
% 
% LMI=getlmis;
% [tmin,xfeas]=feasp(LMI);
% P=dec2mat(LMI,xfeas,P);
% Khat=dec2mat(LMI,xfeas,Khat);
% 
% K=inv(P)*Khat;
% N=Ahat-K*C;
% Mtau=linsolve(C',(eye(length(Ehat))-Ehat)');
% M=Mtau';
% L=K+N*M;

%% Simulation time!

% Very important. The observer ode function 'linechaos_obs' is written in
% such a way, so that after its simulation, you can call it using the
% output of the ode45, in order to obtain back the internal algebraic
% variables, like the output y, x_estimate, and the unknown input s.


%x0=[.1,.1,1];
% %tspan=[0,30]; 
% tspan=[1:1:10000]; 

tspan=[1:1:900];
%options = odeset('RelTol',1e-4,'AbsTol',1e-4);

% system and observer solver
%[t,x]=ode45(@logchaos_obs,tspan,x0,options); 
% s=0.3*cos(pi*t);
% y=[x(:,1)
%     ,x(:,2),x(:,3),s];
% y=C.*[x(1,:);x(2,:);x(3,:);s]
% run the system again to obtain the internal variables
% s denotes the input

% [~,y,x_est,s]=logchaos_obs(tspan', x');
% img_enc = vec2mat(y,30)';
% %% Reconstructed img
% s_hat=vec2mat(x_est(2,:),30)';   % s is secret img data
% figure; 
% subplot(1,2,1);imshow(uint8(img_enc));
% subplot(1,2,2);imshow(uint8(s_hat));

% %% Plotting the results
% figure
% subplot(1,2,1)
% hold all
%  plot(t,x(:,1),t,x_est(1,:))
% grid
% xlabel('time')
% legend('Original states x_1','estimated state')
% set(gca,'fontsize',11)
% set(gca,'fontweight','bold')
% % 
% subplot(1,2,2)
% hold all
% plot(t,s,t,x_est(2,:))
% legend('Original state x_2','estimated state')
% grid
% xlabel('time')
% 
% set(gca,'fontsize',11)
% set(gca,'fontweight','bold')

