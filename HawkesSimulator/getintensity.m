function I2=getintensity(t1,t2,I1,mu)
omega=1;
I2=(I1-mu)*exp(-omega*(t2-t1))+mu;
    