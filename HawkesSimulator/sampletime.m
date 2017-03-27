function t2=sampletime(t1,LT,LI,mu,E_T)
if LI==0&&mu==0
    t2=100000;
else
    s=t1;
    lambda1=getintensity(LT,s,LI,mu);
    while s<E_T
        u=rand;
        g=-log(u)/lambda1;
        s=s+g;
        lambda2=getintensity(LT,s,LI,mu);
        d=rand;
        if d*lambda1<lambda2
            t2=s;
            break;
        else
            lambda1=lambda2;
        end
    end
    if s>=E_T
        t2=100000;
    end
end