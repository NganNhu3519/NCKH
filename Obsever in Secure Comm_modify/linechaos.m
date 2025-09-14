function dxdt= linechaos(t,x)
global a 

dxdt = [x(2)*x(3) ; x(1)*abs(x(1))-x(2)*abs(x(2)) ; abs(x(1))-a*x(1)*x(2)];
end