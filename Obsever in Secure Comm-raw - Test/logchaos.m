function dxdt= logchaos(t,x)
global a 
dxdt = [a*x(1)*(1-x(1))];
end