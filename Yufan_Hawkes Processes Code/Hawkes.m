function H=Hawkes(fname,T,mu) %fname is the density kernel function
fh=str2func(fname);
H=[];
A=[];
t=0;
while t<T
    M=mu;
    if ~isempty(H)
        for i=1:length(H)
            M=M+fh(t-H(i));
        end
    end
    u=rand;
    E=-log(u)/M;
    t=t+E;
    U=rand;
    v=mu;
    if ~isempty(H)
        for i=1:length(H)
            v=v+fh(t-H(i));
        end
    end
    if t<T && (M*U<=v)
        H=[H,t];
        A=[A,M*U];
    end
end
x=[];
y=[];
h=[];
figure; hold on;
for i=1:(length(H)+1)
    if i==1
        t1=0:(H(i)/100):(99*H(i)/100);
        x=[x,t1];
        y=[y,mu*ones(1,length(t1))];
        h=[h,plot(t1,mu*ones(1,length(t1)),'b-','LineWidth',8)];
    elseif i==(size(H,2)+1) 
        t1=H(i-1):(T-H(i-1))/100:T;
        x=[x,t1];
        y1=ones(1,length(t1))*mu; 
        for j=1:length(t1)
            for k=1:i-1
                y1(j)=y1(j)+fh(t1(j)-H(k));
            end
        end
        h=[h,plot(t1,y1(1)*ones(1,length(t1)),'b-','LineWidth',8)];
        y=[y,y1]; 
    else
        t1=H(i-1):(H(i)-H(i-1))/100:(99*H(i)/100+H(i-1)/100);
        x=[x,t1];
        y1=ones(1,length(t1))*mu;
        for j=1:length(t1)
            for k=1:i-1
                y1(j)=y1(j)+fh(t1(j)-H(k));
            end
        end
        h=[h,plot(t1,y1(1)*ones(1,length(t1)),'b-','LineWidth',8)];
        y=[y,y1]; 
    end
end
h=[h,plot(x,y,'LineWidth',1)];
h=[h,scatter(H,0.5*zeros(1,length(H)),40,'LineWidth',2)];
h=[h,stem(H,A,'LineWidth',2)];
c={'Accepted Points','Hawkes Process Times','Density Values','M'};
legend(h([length(h),length(h)-1,length(h)-2,length(h)-3]),c);
xlabel('Time');
ylabel('Density');
hold off;
figure;
plot([0,H],0:length(H),'b-o');
xlabel('Time');
ylabel('Counts');
title('Hawkes Counting Process');


    

    
    
    
    