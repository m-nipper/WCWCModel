r = optimvar('r',5,"LowerBound",[10e4 0.3 0 0 10e5],"UpperBound",[10e5 1 1 4 10e6]);
f = fcn2optimexpr(@RtoODE,r,tspan,input);
obj = sum(sum((f-ytrue).^2));
p = optimproblem("Objective",obj);
p.ObjectiveSense = 'min';
r0.r = [0.6 0.3 1.5/6 4/6 1];
[rsol, sumsq] = solve(p,r0);

function solpts = RtoODE(r,tspan,input)
    sol = ode45(@(t,y)fun(t,y,r,input.te,input.tm,tspan),tspan,input.y0);
    temp = deval(sol,tspan);
    solpts = (temp(1,:)-temp(2,:))';
end

function fy = fun(t,x,r,te,tm,tspan)
m = r(1);   
ep = r(2);
Ah = r(3);
Aw = r(4);
M = r(5);
tao = 200;
q = Ah * ((x(1) + x(2)) / 2 - x(3)) + Aw * (x(1) - x(2));
q = q/tao;
tte = interp1(tspan,te,t);
ttm = interp1(tspan,tm,t);
fy=[(tte-x(1))/tao+(1-ep)*q*(x(2)-x(1));(tte-x(2))/tao+q*(x(4)-x(2));(ttm-x(3))/tao+ep*q*(x(2)-x(3))/m+(1-ep)*q*(x(1)-x(3))/m;q*(x(3)-x(4))/M];
end