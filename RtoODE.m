function solpts = RtoODE(r,tspan,input)
    sol = ode45(@(t,y)fun(t,y,r,input.te,input.tm,tspan),tspan,input.y0);
    temp = deval(sol,tspan);
    solpts = (temp(1,:)-temp(2,:))';
end