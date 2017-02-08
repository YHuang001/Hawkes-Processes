%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate a set of event sequences based on multi-dimensional
% Hawkes processes
%
% Please cite our paper if you use our code
%
% Hongteng Xu, Mehrdad Farajtabar, and Hongyuan Zha. 
% "Learning granger causality for hawkes processes".
% International Conference on Machine Learning (ICML), 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

addpath('./Simulate/');
% time interval of sequence
para.N = 5000;
para.T = 25;
para.U = 5;
% intrinsic intensity matrix
para.mu = rand(para.U, 1)./para.U; 
% distribution of components
para.pair = [1,2; 2,3; 4,5];
para.freq = 0.1+blkdiag(0.2*ones(3), 0.1*ones(2));
para.shift = double(para.freq<0.3);
para.weight = blkdiag(0.05*ones(3), 0.05*ones(2));
para.weight(1:3,4) = 0.02;
para.weight(4,1:3) = 0.02;



% figure
% hold on
% for i=1:para.U
%     for j=1:para.U
%         if para.shift(i,j)==0
%             dt=1/para.freq(i,j);
%             t=0:0.01:dt;        
%             plot(t, para.weight(i,j)*2*round(0.5*(1-cos(2*pi*para.freq(i,j)*t))));
%         else
%             dt=0.5/para.freq(i,j);
%             t=0:0.01:dt;        
%             plot(t, para.weight(i,j)*2*round(0.5*(1-cos(2*pi*para.freq(i,j)*t+pi*para.shift(i,j)))));
%         end
%     end
% end
% hold off


Seq1 = SimMultiHawkes( para, 'sine' );
Seq2 = SimMultiHawkes( para, 'square' );

save('SynMHP.mat','Seq1','Seq2', 'para');

load SynMHP.mat

ShowKernel(para, 'sine');
ShowMultiHawkes(Seq1, para, 'sine');
ShowKernel(para, 'square');
ShowMultiHawkes(Seq2, para, 'square');

