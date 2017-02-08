function ShowKernel(para, pattern)


figure

for i=1:para.U
    for j=1:para.U
        subplot(para.U, para.U, para.U*(i-1)+j)
        if para.shift(i,j)==0
            dt=1/para.freq(i,j);
            t=0:0.01:dt;             
            plot(t, KernelFunc( t, para.weight(i,j), para.freq(i,j), para.shift(i,j), pattern ));
        else
            dt=0.5/para.freq(i,j);
            t=0:0.01:dt;        
            plot(t, KernelFunc( t, para.weight(i,j), para.freq(i,j), para.shift(i,j), pattern ));
        end
    end
end
