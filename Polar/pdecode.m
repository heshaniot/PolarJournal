function u=pdecode(y,PCparams)
% PCparams structure is implicit parameter
%
% y    : Received bits in an AWGN (of noise variance N0/2, available via "PCparams")
% u    : Decoded message bits
%
% Polar coding parameters (N,K,FZlookup,Ec,N0,LLR,BITS) are taken
% from "PCparams" structure FZlookup is a vector, to lookup each integer
% index 1:N and check if it is a message-bit location or frozen-bit location.
%
%        FZlookup(i)==0 or 1 ==> bit-i is a frozenbit
%        FZlookup(i)==  -1   ==> bit-i is a messagebit
%
% PCparams.Ec   : The encoded bits power before entering AWGN
% PCparams.N0   : 2 times the Noise variance
% PCparams.LLR  : Log-Likelihood Ratios data structure for SC decoding
%                    vector of 1 x 2N-1
% PCparams.BITS : Intermediate bit decisions for SC decoding
%                    matrix of 2 x N-1
% -----
% NOTE:
%       EbN0 : If "SNR" is the signal-to-noise ratio of the AWGN;
%                 Eb/N0 = (Ec/N0) * (N/K) = (SNR/2) * (N/K)

%%%%%%%%DEBUGGING DECODER Part 1of2%%%%%%%%%
% TECHNIQUE: Compare the output with a sample output from other perfect decoder implementation
% y = [-2.29054 -2.42021 0.78617 -1.48262 -1.78447 -1.34204 1.82231 2.01136 -0.50112 -1.70260 -2.20256 -1.23027 -1.83809 -0.65077 0.92667 1.07634]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=PCparams.N;
SCLparams =struct ; 
SCLparams=initListDecode(PCparams,SCLparams);


% Initializing the likelihoods (i.e. the right end of the butterfly str)
SCLparams.LLR(:,:) = 0; %PCparams.BITS=-1;
initialLRs = zeros(N,1);
initialLRs(1:2:end) = -(4*sqrt(PCparams.Ec/2)/PCparams.N0) * real(y); 
initialLRs(2:2:end) = -(4*sqrt(PCparams.Ec/2)/PCparams.N0) * imag(y);

CRCdetector = comm.CRCDetector([8 2 1 0],'ChecksumsPerFrame',1);

%initial Path
l1 = SCLparams.inactivePathIndices.pop();
SCLparams.activePath(l1)=1;

SCLparams.LLR(l1,N:2*N-1) = initialLRs;
% Explanation:
% ------------
%   y(i) = x(i) + n; x \in {+sqrt(Ec),-sqrt(Ec)}; n ~ Gaussian(0,N0/2)
%   LLR(i) = Pr{y(i) | x(i) = -sqrt(Ec)} / Pr{y(i) | x(i) = +sqrt(Ec)}
%   Pr(y|x) = (1/sqrt(2*pi* (N0/2))) * exp( (y-x)^2 / (2*(N0/2)) )


finalLRs = zeros(N,PCparams.L); %DEBUG

for j=1:N
        i = bitreversed(j-1,PCparams.n) +1 ; % "+1" is for base-1 indexing

        for l=1:PCparams.L
            %Check if the path is active
            if SCLparams.activePath(l)==0
                continue
            end
            
            SCLparams = updateLLR(l,i,PCparams,SCLparams);
            finalLRs(i,l) = SCLparams.LLR(l,1); %DEBUG

            %-----------If Frozen----------------------------------------------
            if PCparams.FZlookup(i) == 0
                SCLparams.d_hat(i,l) = PCparams.FZlookup(i);
            end
            %------------------------------------------------------------------
        end
        if PCparams.FZlookup(i) == -1
            SCLparams = continuePaths(i,PCparams,SCLparams);
        end
        for l=1:PCparams.L
        %Check if the path is active
            if SCLparams.activePath(l)==0
                continue
            end
            
            SCLparams=updateBITS(SCLparams.d_hat(i,l),i,l,PCparams,SCLparams);
        end
end

%decoded databits+CRC
wordlist_u = SCLparams.d_hat ( PCparams.FZlookup == -1,:);

err = zeros(1,PCparams.L); %indicator for each path satisfies CRC 
for l=1:PCparams.L
    [~,err(l)] = step(CRCdetector,wordlist_u(:,l)); 
end

number_of_paths_with_CRC0 = sum(1-err);

l1 = 0; % intialize optimum path
p1 = Inf; %nitialize optimum path probability
noerr = 0; % number of paths satisfying CRC

switch number_of_paths_with_CRC0
    case 0 % non of paths satisfy CRC
        all_paths_active = sum(1-SCLparams.activePath(:)); %if paths are active -->0
        if all_paths_active==0
            [p1,l1]=min(SCLparams.pathMatric(:));
        else
            for l=1:PCparams.L
                if SCLparams.activePath(l)==0 %if path is not active
                    continue
                end
                if SCLparams.pathMatric(l)<p1
                    l1 = l;
                    p1 = SCLparams.pathMatric(l);
                end
            end
        end
    case 1 % exactly one path satisfy CRC
        l1 = find(err==0); %Get the path for which CRC=0
        p1 = SCLparams.pathMatric(l1);
    otherwise %more than one path satisfy CRC
        
end
for l=1:PCparams.L
    if SCLparams.activePath(l)==0 %if path is not active
        continue
    end
    if err(l)==0 && noerr==0 %if no CRC error and no paths satisfying CRC
        p1 = SCLparams.pathMatric(l);
        l1 = l;
        noerr = noerr+1;
% %         display(l)
    elseif err(l)==0 && SCLparams.pathMatric(l)<p1
        p1 = SCLparams.pathMatric(l);
        l1 = l;
        noerr = noerr+1;

    elseif noerr==0 && SCLparams.pathMatric(l)<p1
        l1 = l;
        p1 = SCLparams.pathMatric(l);
    end
end
u = SCLparams.d_hat ( PCparams.FZlookup == -1,l1);
% FOR TESTING ONLY
% % u_bits = u(1:8); %for testing
% % failbits=sum(u_bits ~= Testing.u);
% % fprintf('\n============================\n');
% % if failbits==0
% %     fprintf('No bit errors\n');
% % elseif((noerr==1)&&(failbits>0))
% %     
% %     fprintf('chosen path l1=%d failbits=%d\n',l1,failbits);
% %     fprintf('num paths satisfy CRC=%d \n',noerr);
% %     for l=1:PCparams.L
% %         l_bits = SCLparams.d_hat ( PCparams.FZlookup == -1,l);
% %         dec_bits = l_bits(1:8)';
% %         fprintf('l=%d',l);
% %         display(dec_bits);
% %         fprintf('path Metric=%d  CRC=%d \n', SCLparams.pathMatric(l),err(l));               
% %     end
% %     fprintf('\nu = l=%d ',l1);
% %     display(Testing.u');
% %     fprintf('\n withCRc=');
% %      display(Testing.wordwithCRC');
% %     fprintf('\n********************\n');
% %     a=0;
% % else
% %     fprintf('chosen path l1=%d failbits=%d\n',l1,failbits);
% %     fprintf('num paths satisfy CRC=%d \n',noerr);
% %     for l=1:PCparams.L
% %         l_bits = SCLparams.d_hat ( PCparams.FZlookup == -1,l);
% %         dec_bits = l_bits(1:8)';
% %         fprintf('l=%d',l);
% %         display(dec_bits);
% %         fprintf('path Metric=%d  CRC=%d \n', SCLparams.pathMatric(l),err(l));             
% %     end
% %     fprintf('\nu = l=%d ',l1);
% %     display(Testing.u');
% %     fprintf('\n withCRc=');
% %      display(Testing.wordwithCRC');
% %      fprintf('\n-------------------------\n');
% % end
    
% end

clearvars -global SCLparams 
% %%%%%%%%DEBUGGING DECODER Part 2of2%%%%%%%%%
% % TECHNIQUE: Compare the output with a sample output from other perfect decoder implementation
% % DEBUGGING
% fprintf('\n\n N=%d, K=%d, initdB=%.2f',N,PCparams.K,PCparams.designSNRdB);
% fprintf('\n FrozenBitsLookups Actual and Expected respectively =\n [');
% fprintf('%d ',PCparams.FZlookup); fprintf('\b]');
% fprintf('\n [0 0 0 -1 0 -1 0 -1 0 -1 0 -1 0 -1 -1 -1]\n\n');
% 
% fprintf('\n Received Vectors Actual & Expected respectively =\n [');
% fprintf('%.5f ',y'); fprintf('\b]');
% fprintf('\n [-2.29054 -2.42021 0.78617 -1.48262 -1.78447 -1.34204 1.82231 2.01136 -0.50112 -1.70260 -2.20256 -1.23027 -1.83809 -0.65077 0.92667 1.07634]\n\n');
% 
% fprintf('\n Initial Likelihoods Vectors Actual & Expected respectively =\n [');
% fprintf('%.5f ',initialLRs'); fprintf('\b]');
% fprintf('\n [4.58109 4.84043 -1.57235 2.96523 3.56893 2.68408 -3.64461 -4.02271 1.00224 3.40520 4.40512 2.46054 3.67618 1.30155 -1.85335 -2.15268]\n\n');
% 
% fprintf('\n FINAL o/p Likelihoods Vectors Actual & Expected respectively =\n [');
% fprintf('%.5f ',finalLRs'); fprintf('\b]');
% fprintf('\n [-0.09647 1.25093 1.65714 8.74567 0.39491 6.98428 5.69810 20.24560 -0.69722 -4.64566 4.73276 -19.65780 2.06594 -15.43850 13.90370 -44.99160]\n\n');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end