% function polar_N128_12(ebn) 
% addpath(genpath('functions/'));
% addpath(genpath('AWGN_RESULTS/'));
addpath(genpath('functions'));
addpath(genpath('AWGN_RESULTS'));

display('====================================================')

N = 128;
L = 16;
MCsize=1e6; %Monte Carlo size
% %to startparpool
% N=128;
% L_vec = [1];
% MCsize=1e1; %Monte Carlo size

EbN0dBrange=[1:0.5:5];
designSNRdB=2;

%  fprintf('N=%d L=%d MCsize=%d',N,L,MCsize);

start = tic

format long
 
label =12;
parfor i=1:length(EbN0dBrange)
    ebno = EbN0dBrange(i);
    
    K=64 ; %Rate 1/2
%     fprintf('QPSK N=%d K=%d L=%d MCsize=%d \n',N,K,L,MCsize);
    PlotPC_AWGN(N,K,L,ebno,designSNRdB,MCsize,label)
 
end

% legend('8','4','2');
toc(start)