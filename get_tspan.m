function out = get_tspan(S1,S2,r)
            result = zeros(2999*12,4);
            tspan = zeros(20*12,1);
            te = zeros(20*12,1);
            tm = zeros(20*12,1);
            for it = 1:10
                iter = -300;
                for j = 2:12
                    tspan(j) = tspan(j-1) + getdays(-3000000,j);
                end
                for i = iter*1000+1:iter*1000+19
                    for j = 1:12
                        tspan((i-iter*1000)*12 + j) = tspan((i-iter*1000)*12 + j-1) + getdays(app,-3000000,j);
                    end
                end
                for i = iter*1000:iter*1000+19
                    for j = 1:12
                        te((i-iter*1000)*12 + j) = S1(round((iter+300)*10+1),j);
                        tm((i-iter*1000)*12 + j) = S2(round((iter+300)*10+1),j);
                    end
                end
                if it==1
                    y0 = [te(1),te(1),tm(1),tm(1)];
                else
                    y0 = res(end,:);
                end
                [t,x] = ode45(@(t,y)fun(app,t,y,r,te,tm,tspan),tspan,y0);
                res=x(end-11:end,:);
                disp(it)
            end
            for iter = -300:0.1:-0.2
                tspan = zeros(20*12,1);
                te = zeros(20*12,1);
                tm = zeros(20*12,1);
                for j = 2:12
                    tspan(j) = tspan(j-1) + getdays(app,-3000000,j);
                end
                for i = iter*1000+1:iter*1000+19
                    for j = 1:12
                        tspan((i-iter*1000)*12 + j) = tspan((i-iter*1000)*12 + j-1) + getdays(app,-3000000,j);
                    end
                end
                for i = iter*1000:iter*1000+19
                    for j = 1:12
                        te((i-iter*1000)*12 + j) = S1(round((iter+300)*10+1),j);
                        tm((i-iter*1000)*12 + j) = S2(round((iter+300)*10+1),j);
                    end
                end
                if iter==-300
                    y0 = res(end,:);
                else
                    y0 = result(round((iter+300)*10*12),:);
                end
                [t,x] = ode45(@(t,y)fun(app,t,y,r,te,tm,tspan),tspan,y0);
                result(round((iter+300)*10*12+1):round((iter+300)*10*12+12),:)=x(end-11:end,:);
                disp(iter)
            end
            out.result = result;
            out.tspan = tspan;
            out.te = te;
            out.tm = tm;
        end
        function days = getdays(y,m)
            if m == 2 && floor(y/4) == y/4 && floor(y/100) ~= y/100 || floor(y/400) ~= y/400
                days = 29;
            else
                dates = [31,28,31,30,31,30,31,31,30,31,30,31];
                days = dates(m);
            end
        end