function P=inPoisson(T,fname,M) %M is the maximum value of function fname
fh=str2func(fname); %input function
P=[];
A=[];
t=0;
while t<T
    u=rand;   
    E=-log(u)/M;  %exponential distribution 
    t=t+E;
    U=rand*M;
    if t<T && U<=fh(t)
        P=[P,t];
        A=[A,U];
    end
end
figure;
hold on;
x=0:0.1:T;
plot(x,fh(x),'LineWidth',3); 
plot(x,M*ones(1,length(x)),'LineWidth',8);
scatter(P,zeros(1,length(P)),100,'LineWidth',2);
stem(P,A);
hold off;
legend('Density Function','M','Inhomogenous Poisson Times','Accepted Points');
xlabel('Time');
ylabel('Density');
figure;
plot([0,P],0:length(P),'b-o');
title('Inhomogeneous Poisson Counting Process');
xlabel('Time');
ylabel('Counts');