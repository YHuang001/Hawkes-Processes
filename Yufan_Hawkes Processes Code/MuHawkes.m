function [H1,H2]=MuHawkes(fname1,fname2,T,mu1,mu2,w11,w12,w21,w22) %fname1 and fname2 are density kernel functions
%w11, w12, w21, w22 mutual weights
fh1=str2func(fname1);
fh2=str2func(fname2);
H1=[];
H2=[];
A1=[];
A2=[];
t1=0;
t2=0;
while t1<T && t2<T
    M1=mu1;
    if ~isempty(H1)
        for i=1:length(H1)
            M1=M1+w11*fh1(t1-H1(i));
        end
        if ~isempty(H2)
            j=find(H2>t1,1);
            if isempty(j)
                for k=1:length(H2)
                    M1=M1+w21*fh2(t1-H2(k));
                end
            elseif j~=1
                for k=1:j-1
                    M1=M1+w21*fh2(t1-H2(k));
                end
            end
        end                
    end
    M2=mu2;
    if ~isempty(H2)
        for i=1:length(H2)
            M2=M2+w22*fh2(t2-H2(i));
        end
        if ~isempty(H1)
            j=find(H1>t2,1);
            if isempty(j)
                for k=1:length(H1)
                    M2=M2+w12*fh1(t2-H1(k));
                end
            elseif j~=1
                for k=1:j-1
                    M2=M2+w12*fh1(t2-H1(k));
                end
            end
        end   
    end    
    u1=rand;
    E1=-log(u1)/M1;
    t1=t1+E1;
    u2=rand;
    E2=-log(u2)/M2;
    t2=t2+E2;
    U1=rand;
    v1=mu1;
    U2=rand;
    v2=mu2;
    if ~isempty(H1)
        for i=1:length(H1)
            v1=v1+w11*fh1(t1-H1(i));
        end
        if ~isempty(H2)
            j=find(H2>t1,1);
            if isempty(j)
                for k=1:length(H2)
                    v1=v1+w21*fh2(t1-H2(k));
                end
            elseif j~=1
                for k=1:j-1
                    v1=v1+w21*fh2(t1-H2(k));
                end
            end
        end 
    end
    if ~isempty(H2)
        for i=1:length(H2)
            v2=v2+w22*fh2(t2-H2(i));
        end
        if ~isempty(H1)
            j=find(H1>t2,1);
            if isempty(j)
                for k=1:length(H1)
                    v2=v2+w12*fh1(t2-H1(k));
                end
            elseif j~=1
                for k=1:j-1
                    v2=v2+w12*fh1(t2-H1(k));
                end
            end
        end           
    end
    if t1<T && (M1*U1<=v1)
        H1=[H1,t1];
        A1=[A1,M1*U1];
    end
    if t2<T && (M2*U2<=v2)
        H2=[H2,t2];
        A2=[A2,M2*U2];
    end    
end
x1=[];
y1=[];
x2=[];
y2=[];
for i=0:T/1000:T
    x1=[x1,i];
    x2=[x2,i];
    j1=find(H1>i,1);
    j2=find(H2>i,1);
    m1=mu1;
    m2=mu2;
    if ~isempty(H1)
        if isempty(j1)
            for k=1:length(H1)
                m1=m1+w11*fh1(i-H1(k));
                m2=m2+w12*fh1(i-H1(k));
            end
        elseif j1~=1
            for k=1:j1-1
                m1=m1+w11*fh1(i-H1(k));
                m2=m2+w12*fh1(i-H1(k));
            end
        end
    end
    if ~isempty(H2)
        if isempty(j2)
            for k=1:length(H2)
                m1=m1+w21*fh2(i-H2(k));
                m2=m2+w22*fh2(i-H2(k));
            end
        elseif j2~=1
            for k=1:j2-1
                m1=m1+w21*fh2(i-H2(k));
                m2=m2+w22*fh2(i-H2(k));
            end 
        end
    end    
    y1=[y1,m1];
    y2=[y2,m2];
end
figure; 
subplot(2,1,1);
hold on;
plot(x1,y1);
stem(H1,A1,'LineWidth',2);
hold off;
subplot(2,1,2); 
hold on;
plot(x2,y2);
stem(H2,A2,'LineWidth',2);

                
        
    