function PlotPC_AWGN(N,K,L,EbN0dBrange,designSNRdB,MCsize,label,verbose_output_flag) %designSNRdB is optional

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
    label = 12;
    verbose_output_flag=0;
elseif nargin==4
    designSNRdB=0;
    MCsize = 1e5;
    label = 12;
    verbose_output_flag=0;
elseif nargin==5
    MCsize = 1e5;
    label = 12;
    verbose_output_flag=0;
elseif nargin==6
    label = 12;
    verbose_output_flag=0;
elseif nargin==7
    verbose_output_flag=0;
elseif (nargin>8 || nargin<3)
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
Ec = 1;
N0 = 2;
PCparams = initPC(N,K,L,Ec,N0, designSNRdB,PCparams,1); %silent, no output

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
% alphabetSize = 2 % BPSK
alphabetSize = 4; %QPSK M

bitsPerSymbol = log2(alphabetSize); %m
 if alphabetSize == 2
     componentLength = bitsPerSymbol ; %p
 elseif alphabetSize > 2
     componentLength = bitsPerSymbol/2 ; %p
 end


r = PCparams.r ;
j=1;
tt=tic();
    N0 = PCparams.N0;
    Ec = bitsPerSymbol*(K/N)*N0*10^(EbN0dB(j)/10);
    
    PCparams.Ec = Ec; %normalized Ec %necessary for pencode(), pdecode()

    FER_local = zeros(MCsize,1);
    BER_local = zeros(MCsize,1);
    
    for l=1:MCsize
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
        txvec = sqrt(Ec/2).*x_mod;
        
        %--------Channel Noise---------------------------------------------
%         y = txvec + sqrt(N0/2)*randn(N,1);
%         H = sqrt(1/2).*( randn(length(x_reshaped),1)+ 1i*randn(length(x_reshaped),1) ); 

        channelNoise = sqrt(N0/2).*(randn(N/bitsPerSymbol,1)+1i*randn(N/bitsPerSymbol,1)); %sigma2 = N0/2
%         y = txvec + channelNoise;
         y = txvec+ channelNoise;
         
         %Receiver
%          y = y;
        
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
            if mod(l,10)==0
                fprintf('Eb/N0 = %.1f dB and iteration-%d: %.2f sec : %d FEs, %d BEs %c',EbN0dB(j),l,toc,sum(FER_local),sum(BER_local),char(10)); %DEBUG NOTE
              
                FER = sum(FER_local);
                BER = sum(BER_local);
                saveResults( EbN0dBrange,N,K,L,FER,BER,designSNRdB,l,MCsize,label);
            end
        end
        
        if sum(FER_local)>=30  %frame errors, sufficient to stop % FER(j)
            break;
        end

    end
 
    FER = sum(FER_local);
    BER = sum(BER_local);
    saveResults( EbN0dBrange,N,K,L,FER,BER,designSNRdB,l,MCsize,label);
if(verbose_output_flag)
    toc(tt);
else
    fprintf('\n %.2f dB (time taken:%.2f sec)',EbN0dB(j),toc(tt));
end


% hold on;
fprintf('\n\n Eb/N0 range (dB) : '); disp(EbN0dB);
fprintf(' Frame Error Rates: '); disp(FER/l);
fprintf(' Bit Error Rates  : '); disp(BER/((K-8)*l));

PCparams=PCparams1; %restore the original
end


function saveResults( EbN0dBrange,N,K,L,FER,BER,designSNRdB,l,MCsize,label)
             FER = FER/l;
             BER = BER/((K-8)*l);

 results.EbNo = EbN0dBrange;
 results.N = N;
 results.K = K;
 results.R = K/N;
 results.ListSize = L;
 results.FER = FER;
 results.BER = BER;
 results.designSNR =designSNRdB;
 results.CRC = 8;
 results.MCsize = l;
 
filename = sprintf('AWGN_RESULTS/Polar_N%d_K%d_R%d_L%d_%.2fdB_1e%d_CRC8.mat',N,K,label,L,EbN0dBrange,log10(MCsize));
save(filename,'results');

return;

end
