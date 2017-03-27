clear;
clc;
alpha=0.8;
beta=0.2;
N=100;
eta=1.5;
mu=4e-4;
A=zeros(N,N);

N_r=eta*eye(N,N);
A_l=mu*ones(N,N);
r_last=N_r;
l_last=A_l;

t=0;
T_r=[];
s_r=[];
d_r=[];
T_l=[];
s_l=[];
d_l=[];
H_T=[];
H_E=[];
E_T=100;
t_last_r=zeros(N,N);
t_last_l=zeros(N,N);

%%initialization
for i=1:N
    for j=1:N
        if i==j
            t_last_r(i,j)=sampletime(t,t_last_r(i,j),r_last(i,j),eta,E_T);
            T_r=[T_r,t_last_r(i,j)];
            s_r=[s_r,i];
            d_r=[d_r,j];
        else
            t_last_r(i,j)=sampletime(t,t_last_r(i,j),r_last(i,j),0,E_T);
            T_r=[T_r,t_last_r(i,j)];
            s_r=[s_r,i];
            d_r=[d_r,j];
        end
        if i~=j
            t_last_l(i,j)=sampletime(t,t_last_l(i,j),l_last(i,j),mu,E_T);
            T_l=[T_l,t_last_l(i,j)];
            s_l=[s_l,i];
            d_l=[d_l,j]; 
        end
    end
end
[T_r,I_r]=sort(T_r);
s_r=s_r(I_r);
d_r=d_r(I_r);
[T_l,I_l]=sort(T_l);
s_l=s_l(I_l);
d_l=d_l(I_l);
T_r_ini=T_r;
t_key=0;
while t_key<E_T
    if T_r(1)<T_l(1)
        t_key=T_r(1);
        s=s_r(1);
        u=d_r(1);
        H_T=[H_T,t_key];
        H_E=[H_E,{[u,s],'r'}];
        if s==u
           t_last_r(s,u)=sampletime(t_key,t_last_r(s,u),r_last(s,u),eta,E_T);
           inds=find(T_r>=t_last_r(s,u),1);
           T_r=[T_r(1:(inds-1)),t_last_r(s,u),T_r(inds:end)];
           s_r=[s_r(1:(inds-1)),s,s_r(inds:end)];
           d_r=[d_r(1:(inds-1)),u,d_r(inds:end)];
        end
        u_N=find(A(u,:));
        for i=1:length(u_N)
            v=u_N(i);
            if s~=v
                r_last(s,v)=r_last(s,v)+beta;
                if t_last_r(s,v)>=t_key
                    t_last_r(s,v)=0;
                end
                t_last_r(s,v)=sampletime(t_key,t_last_r(s,v),r_last(s,v),0,E_T);
                inds=find(T_r>=t_last_r(s,v),1);
                T_r=[T_r(1:(inds-1)),t_last_r(s,v),T_r(inds:end)];
                s_r=[s_r(1:(inds-1)),s,s_r(inds:end)];
                d_r=[d_r(1:(inds-1)),v,d_r(inds:end)];         
                if isempty(find(A(s,:)==v,1))
                    l_last(s,v)=l_last(s,v)+alpha;
                    if t_last_l(s,v)>=t_key
                        t_last_l(s,v)=0;
                    end
                    t_last_l(s,v)=sampletime(t_key,t_last_l(s,v),l_last(s,v),mu,E_T);
                    inds=find(T_l>=t_last_l(s,v),1);
                    T_l=[T_l(1:(inds-1)),t_last_l(s,v),T_l(inds:end)];
                    s_l=[s_l(1:(inds-1)),s,s_l(inds:end)];
                    d_l=[d_l(1:(inds-1)),v,d_l(inds:end)];
                end
            end
        end
        T_r(1)=[];
        s_r(1)=[];
        d_r(1)=[];
    else    
        t_key=T_l(1);
        s=s_l(1);
        u=d_l(1);
        H_T=[H_T,t_key];
        H_E=[H_E,{[u,s],'l'}];
        A(s,u)=1;
        l_last(s,u)=0;
        T_l(1)=[];
        s_l(1)=[];
        d_l(1)=[];
    end
end
if H_T(end)>E_T
    H_T(end)=[];
    H_E(end)=[];
end

