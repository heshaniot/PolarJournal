% =========================================================================
% Title       : Simulator for Quasi-Cyclic LDPC codes
% File        : sim_LDPC.m
% -------------------------------------------------------------------------
% Description :
%   This file performs the main Monte-Carlo simulation procedure.
%   Encodes LDPC codes described by the codes found in the codes/ folder
%   transmits bits over an AWGN channel and calls the decoding algorithm.
% ------------------------------------------------------------------------- 
% Revisions   :
%   Date       Version  Author  Description
%   20-may-11  1.3      studer  cleanup for reproducible research
%   04-jul-07  1.2      studer  multiple bug fixes
%   02-jul-07  1.1      studer  modularized & improved version
%   05-oct-06  1.0      studer  initial version 
% -------------------------------------------------------------------------
%   (C) 2006-2011 Communication Theory Group                      
%   ETH Zurich, 8092 Zurich, Switzerland                               
%   Author: Dr. Christoph Studer (e-mail: studer@rice.edu)     
% =========================================================================

function sim_LDPC_QAM_AWGN_lowRates(RunID,TxRx,LDPC,label) 

  randn('state',RunID)
  rand('state',RunID) 
  
  ttot = tic; 
  %coding parameters
  N = LDPC.tot_bits;
  K = LDPC.inf_bits;
  R = LDPC.rate;
  G = LDPC.G ;
  
  %Eb/No
  EbNodB_range  = TxRx.Sim.EbNo_dB_list;
  EbNo_length = length(EbNodB_range);
  No = 2;
  sigma2 = No/2 ;
 
  %simulations
  MCsize = TxRx.Sim.nr_of_channels;
   
  decoderScheduling = TxRx.Decoder.LDPC.Scheduling;

  % -- initialize
  BER = zeros(1,EbNo_length); 
  BLER = zeros(1,EbNo_length);

  modulationMethod = 'QAM';
  bitsPerSymbol = 2 ; %QAM
  tic;
  
  
  fprintf('\nLDPC_N%d_K%d_R%d_%s_%s_LDPCIterations%d_1e%d\n',N,K,label.rate,modulationMethod,TxRx.Decoder.LDPC.Type,TxRx.Decoder.LDPC.Iterations,log10(MCsize));
  str_filename = sprintf('/LDPC_N%d_K%d_R%d_%s_%s_Iter%d_1e%d_EbNo%.2f_point%d.mat',N,K,label.rate ,modulationMethod,TxRx.Decoder.LDPC.Type,TxRx.Decoder.LDPC.Iterations,log10(MCsize),EbNodB_range,label.number);

  Es =  bitsPerSymbol*(K/N)*No*10.^(EbNodB_range/10); %Energy per coded bit

  
  for trial=1:MCsize 
        titer = tic ;
%         BLER = zeros(MCsize,1);
%         BER_local = zeros(MCsize,1);

        % -- draw random bits and map to symbol
        c = gf(round(rand(1,K)),1);
        x = c*G; % generate codeword

        %QAM modulation
        s = sign((x==0)-0.5); % mapping: 1 to -1.0 and 0 to +1.0
        [tt,Blocklength] = size(s);
        s_reshaped = reshape(s,bitsPerSymbol,Blocklength/bitsPerSymbol); 
        
        % Modulated symbols with energy normalized to 1
        s_mod =  sqrt(1/2)*( s_reshaped(1,:) + 1i*s_reshaped(2,:));

            
        % noise and fading
        % Gaussian Noise    
        channelNoise = sqrt(sigma2).*(randn(1,length(x)/bitsPerSymbol)+1i*randn(1,length(x)/bitsPerSymbol));

        s_mod =  sqrt(Es).*s_mod;

        y =s_mod + channelNoise;

        initialLRs = zeros(1,length(x));
%             initialLRs(1:2:end) = (2*sqrt(Es)/No) * real(y); 
%             initialLRs(2:2:end) = (2*sqrt(Es)/No) * imag(y);
        initialLRs(1:2:end) =2*sqrt(Es)* real(y)/sigma2; 
        initialLRs(2:2:end) = 2*sqrt(Es)* imag(y)/sigma2;

        LLR_A2= initialLRs;


        switch (decoderScheduling)
            case 'Layered', % layered schedule             
                [bit_output,LLR_D2,NumC,NumV] = decLDPC_layered_lowrates(TxRx,LDPC,LLR_A2);
            case 'Flooding', % flooding schedule
                [bit_output,LLR_D2,NumC,NumV] = decLDPC_flooding(TxRx,LDPC,LLR_A2);
            otherwise,
                error('Unknown TxRx.Decoder.LDPC.Scheduling method.')  
        end
            

%         % -- calculate BER
         ref_output = (c==1);   
%         tmp = sum(abs(ref_output-bit_output))./length(bit_output);
%         BLER(trial) = (tmp>0);
%         BER(trial) = tmp ;

      % -- calculate BER
          tmp = sum(abs(ref_output-bit_output))./length(bit_output);
          BER = BER + tmp;  
          BLER = BLER + (tmp>0);
      

        if mod(trial,10)==1
          fprintf(sprintf('Estimated remaining time is %1.2f minutes.\n',(toc(titer))/trial*(TxRx.Sim.nr_of_channels-trial)/60));
          SaveResults(TxRx,LDPC,trial,EbNodB_range,BER,BLER,label.folder,str_filename );
        end
    
        if BLER>=30
            break;
        end    
    
  end

  % -- simulation run finished
  SaveResults(TxRx,LDPC,trial,EbNodB_range,BER,BLER,label.folder,str_filename );
  fprintf(sprintf('\n### Simulation completed.\n')); 
  fprintf('\nTotal time %.2f seconds \n',toc(ttot))
  
  
  
return


function SaveResults(TxRx,LDPC,trial,EbNodB_range,BER,BLER,folder,str)

  % -- save results to disk
  Results.TxRx = TxRx;
  Results.EbNo = EbNodB_range;
  Results.LDPC = LDPC;
  Results.BLER = BLER/trial;
  Results.BER = BER/trial;
  Results.MCsize = trial ;
%   Results.FileName = sprintf([label.folder '/LDPC_N%d_K%d_R%d_%s_%s_Iter%d_1e%d_EbNo%.2f_point%d.mat'],N,K,label.rate ,modulationMethod,TxRx.Decoder.LDPC.Type,TxRx.Decoder.LDPC.Iterations,log10(MCsize),EbNodB_range,label.number);
%   save(Results.FileName,'Results');
  Results.FileName = sprintf([folder '/%s'],str);
  save(Results.FileName,'Results');  

  
return

% function SaveResults(RunID,TxRx,PCTC,trial,BER,FER,folder,str)
%   Results.TxRx = TxRx;
%   Results.PCTC = PCTC;
%   Results.EbNo = TxRx.Sim.EbNo_dB_list;
%   Results.BER = BER/trial;
%   Results.FER = FER/trial;
%   Results.Trials = trial;
%   Results.FileName = sprintf([folder '/%s.mat'],str);
%   save(Results.FileName,'Results');  
% return

%   Results.FileName = sprintf([folder '/%s.mat'],str);
%   save(Results.FileName,'Results');  
