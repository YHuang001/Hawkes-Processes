%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Learning Granger Causality for multi-dimensional Hawkes processes
%
% Please cite our paper if you use our code
%
% Hongteng Xu, Mehrdad Farajtabar, and Hongyuan Zha. 
% "Learning granger causality for hawkes processes".
% International Conference on Machine Learning (ICML), 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
addpath('./MLE');
addpath('./Simulate');

load SynMHP.mat


% parameters of proposed method and its variants
algMLE.alphaP = 1000;% pairwise similarity
algMLE.alphaS = 10;  % sparse
algMLE.alphaG = 100; % group lasso
algMLE.M = 10;
algMLE.T = 6;
algMLE.outer = 5;
algMLE.inner = 8;
algMLE.hardthres = 1e-7;
algMLE.thres = 1e-5;
algMLE.sigma = 0.5*(algMLE.T/algMLE.M);
algMLE.dt = 0.05;
algMLE.rho = 1000;



NP = 2;
NN = 250;

Aest = cell(2,2);
muest = cell(2,2);
Time = zeros(2,2);

for nt = 1:NP
    ind = randperm(5000);
    if nt ==1
        TrainData = Seq1(ind(1:NN));
    else
        TrainData = Seq2(ind(1:NN));
    end

    % MLE+SGL+Pairwise Similarity
    tic;
    [Aest{nt,1}, muest{nt,1}, ~] = ...
        LearningMHP_MLESGLP( TrainData, para, algMLE, [1,1,1] );
    Time(nt)=toc;
            

    % MLE
    tic;
    [Aest{nt,2}, muest{nt,2}, LandmarkF] = ...
        LearningMHP_MLESGLP( TrainData, para, algMLE, [0,0,0] );    
    Time(nt)=toc;
   
end


save('CmpResultNew.mat', 'Aest', 'muest', 'para', 'algMLE', 'LandmarkF');

%% visualize impact function
pattern={'sine', 'square'};

resolution = 0.05;


for p=1:NP
    sigma = algMLE.sigma*ones(size(LandmarkF));
    ts = 0:resolution:algMLE.T;
    ker = zeros(length(ts), para.U,para.U);
    kerest2 = ker;
    kerest1 = ker;
    figure
    for i=1:para.U
        for j=1:para.U
        
            gk = gkernel(algMLE.T, ts, LandmarkF, sigma);
            if para.shift(i,j)==0
                ker(:,i,j) = KernelFunc(ts, para.weight(i,j), para.freq(i,j), ...
                    para.shift(i,j), pattern{p});
                upper = 1/para.freq(i,j);
                [~,index] = min(abs(ts-upper));
                ker(index(1)+1:end,i,j)=0;
            else
                
                ker(:,i,j) = KernelFunc(ts, para.weight(i,j), para.freq(i,j), ...
                    para.shift(i,j), pattern{p});
                upper = 0.5/para.freq(i,j);
                [~,index] = min(abs(ts-upper));
                ker(index(1)+1:end,i,j)=0;
            end
        
            kerest2(end:-1:1,i,j) = Aest{p,2}(:,j,i)'*gk;
            
            kerest1(end:-1:1,i,j) = Aest{p,1}(:,j,i)'*gk;
            subplot(5,5,j+5*(i-1))
        
            plot(ts,ker(:,i,j),'k-',...
                 ts,kerest1(:,i,j),'r-',...
                 ts,kerest2(:,i,j),'b-');
            axis([0,algMLE.T,-0.02,0.12])

            %xlabel('Time');
            xlabel(['\phi_', sprintf('{%d%d}',i,j)])
            if i==1 && j==1
                legend('Real', 'MLE-SGLP', 'MLE', 'Orientation','horizontal');
                legend('boxoff');
            end
        end
    end

end