function plotPC(N,K,L,EbN0dBrange,designSNRdB,MCsize,verbose_output_flag) %designSNRdB is optional

% Plot the performance curve for (N,K) polar code
% Uses all-zero codeword transmission
% 
%    Usage: plotPC(N,K,EbN0dBrange,designSNRdB)
%
%       N - Block length
%       K - Message length
%       EbN0dBrange (=0:1:2, default) - the range of Eb/N0 values (in dB)
%                                           to simulate FER/BER
%       designSNRdB(=0dB, default) - The design-SNR=Ec/N0 at which the
%                                      polar code is to be constructed
%
%       verbose_output_flag - whether to print status messsages
% 
%   Note: This routine, preserves the global structure PCparams. It changes
%   the structure but restores at the end. So subsequent calls to functions
%   pencode(),pdecode() etc all are not affected.

% global PCparams;
PCparams=struct ;
if nargin==3 %if last 2 args are not supplied
    EbN0dBrange = 0:1:2; %default SNR range to quickly see the o/p
    designSNRdB = 0; 
    MCsize = 1e5;
    verbose_output_flag=0;
elseif nargin==4
    designSNRdB=0;
    MCsize = 1e5;
    verbose_output_flag=0;
elseif nargin==5
    MCsize = 1e5;
    verbose_output_flag=0;
elseif nargin==6
    verbose_output_flag=0;
elseif (nargin>7 || nargin<3)
    fprintf('\n   Usage: plotPC(N,K,EbN0dBrange,designSNRdB,verbose_output_flag)\n');
    fprintf('\n       N  -  Blocklength');
    fprintf('\n       K  -  Message length (Rate = K/N)');
    fprintf('\n       EbN0dBrange -  the range of Eb/N0 values in dB');
    fprintf('\n                           to Monte-Carlo simulate)');
    fprintf('\n       designSNRdB (optional) - the SNR at which the polar code should be constructed');
    fprintf('\n                                 (Here, SNR=Ec/N0 - by definition for a PCC, defaults to "0dB")');
    fprintf('\n       verbose_output_flag - whether to print detailed status of the simulation periodically\n\n');
    return;
end

PCparams1 = PCparams; %store the current

 PCparams = initPC(N,K,L,1,2, designSNRdB,PCparams,1); %silent, no output

EbN0dB = EbN0dBrange;

% MCsize = 1000000; %Montecarlo size

global BER;
global FER;

BER = zeros(1,length(EbN0dB));
FER = zeros(1,length(EbN0dB));

if(~verbose_output_flag)
    fprintf('Completed SNR points (out of %d): ',length(EbN0dB));
end

CRCgenerator = comm.CRCGenerator([8 2 1 0],'ChecksumsPerFrame',1);

%Modulation Parameters
alphabetSize = 4; %QPSK M
bitsPerSymbol = log2(alphabetSize); %m
componentLength = bitsPerSymbol/2 ; %p

r = PCparams.r ;
for j=1:length(EbN0dB)
tt=tic();
    N0 = PCparams.N0;
    Ec = bitsPerSymbol*(K/N)*N0*10^(EbN0dB(j)/10);
    
    PCparams.Ec = Ec; %normalized Ec %necessary for pencode(), pdecode()

    FER_local = zeros(MCsize,1);
    BER_local = zeros(MCsize,1);
    
    parfor l=1:MCsize
        tic
        %------------Generate data bits -----------------------------------
        u=randi(2,K-8,1)-1; %Bernoulli(0.5)
                
        %------------Adding CRC -------------------------------------------
        wordwithCRC = step(CRCgenerator,u);     
        
        %-----------Polar Encoding-----------------------------------------
        x=pencode(wordwithCRC,PCparams);
        
        %--------QPSK Modulation-------------------------------------------
%         txvec = (2*x-1)*sqrt(Ec);
        x = 2*x-1;
        x_reshaped = reshape(x,bitsPerSymbol,N/bitsPerSymbol); 
        x_mod =  x_reshaped(1,:)'+ 1i*x_reshaped(2,:)';
        txvec = x_mod*sqrt(Ec);
        
        %--------Channel Noise---------------------------------------------
%         y = txvec + sqrt(N0/2)*randn(N,1);
        channelNoise = sqrt(N0/2)*randn(N/bitsPerSymbol,1)+1i*sqrt(N0/2)*randn(N/bitsPerSymbol,1);
        y = txvec + channelNoise;
        
        %--------Polar Decoding-------------------------------------------
        uhat = pdecode(y, PCparams);
        uhat = uhat(1:K-8);
        
        %--------FER BER Calculation--------------------------------------
        nfails = sum(uhat ~= u);
%         FER(j) = FER(j) + (nfails>0);
	    FER_local(l) = (nfails>0);
%         BER(j) = BER(j) + nfails;
	    BER_local(l) = nfails;
        
        if(verbose_output_flag)
        if mod(l,200)==0
        fprintf('Eb/N0 = %.1f dB and iteration-%d: %.2f sec : %d FEs, %d BEs %c',EbN0dB(j),l,toc,FER(j),BER(j),char(10)); %DEBUG NOTE
        end
        end
        
%         if l>=1000 && sum(FER_local)>=200  %frame errors, sufficient to stop % FER(j)
%             break;
%         end
    end
 
    FER(j) = sum(FER_local);
    BER(j) = sum(BER_local);
    FER(j) = FER(j)/MCsize;
    BER(j) = BER(j)/((K-8)*MCsize);
if(verbose_output_flag)
    toc(tt);
else
    fprintf('\n %.2f dB (time taken:%.2f sec)',EbN0dB(j),toc(tt));
end
end

 results.EbNo = EbN0dBrange;
 results.N = N;
 results.K = K;
 results.R = K/N;
 results.ListSize = L;
 results.FER = FER;
 results.BER = BER;
 results.designSNR =designSNRdB;
 results.CRC = 8;
 results.MCsize = MCsize;

 
filename = sprintf('resultsMAT/Polar_QPSK_designSNR%d_N%d_K%d_L%d_R12_1e%d_CRC8.mat',designSNRdB,N,K,L,log10(MCsize));
save(filename,'results');

 subplot(211);
 semilogy(EbN0dB,FER); grid on;
 titlestr = sprintf('N=%d L=%d R=%.2f Polar code performance (designSNR=%.1dB) QPSK',N,PCparams.L,(K/N),designSNRdB);
 title(titlestr);
 xlabel('Eb/N0 in dB');
 ylabel('Frame Error Rate');
 hold on
 
 subplot(212);
 semilogy(EbN0dB,BER); grid on;
%  titlestr = sprintf('N=%d L=%d R=%.2f Polar code performance (designSNR=%.1dB) with CRC8',N,PCparams.L,(K/N),designSNRdB);
%  title(titlestr);
 xlabel('Eb/N0 in dB');
 ylabel('Bit Error Rate');
 
 filename = sprintf('resultsMAT/Polar_QPSK_designSNR%d_N%d_K%d_L%d_R12_1e%d_CRC8.fig',designSNRdB,N,K,L,log10(MCsize));
 savefig(filename);
 
hold on;
fprintf('\n\n Eb/N0 range (dB) : '); disp(EbN0dB);
fprintf(' Frame Error Rates: '); disp(FER);
fprintf(' Bit Error Rates  : '); disp(BER);

PCparams=PCparams1; %restore the original
end
