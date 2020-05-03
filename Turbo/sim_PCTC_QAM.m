% =========================================================================
% Title       : Simulator for Parallel-Concatenated Turbo Codes
% File        : sim_PCTC.m
% -------------------------------------------------------------------------
% Description :
%   This file performs the main Monte-Carlo simulation procedure.
%   Encodes PCTC turbo codes as specified by the files in the codes/ folder
%   transmits bits over an AWGN channel and calls the decoding algorithm.
% ------------------------------------------------------------------------- 
% Revisions   :
%   Date       Version  Author  Description
%   11-dec-11  1.3      studer  cleanup for reproducible research
%   04-jul-07  1.2      studer  multiple bug fixes
%   02-jul-07  1.1      studer  modularized & improved version
%   05-oct-06  1.0      studer  initial version 
% -------------------------------------------------------------------------
%   (C) 2006-2011 Communication Theory Group                      
%   ETH Zurich, 8092 Zurich, Switzerland                               
%   Author: Dr. Christoph Studer (e-mail: studer@rice.edu)     
% =========================================================================

function sim_PCTC_QAM(RunID,TxRx,PCTC,label) 

  randn('state',RunID)
  rand('state',RunID) 
     
  % -- initialize
  BER = zeros(1,length(TxRx.Sim.EbNo_dB_list)); 
  FER = zeros(1,length(TxRx.Sim.EbNo_dB_list));
  
  bitsPerSymbol = 2;
  
  sigma2 = bitsPerSymbol/(2*PCTC.Rate)*10.^(-TxRx.Sim.EbNo_dB_list/10);
  
 
%  fprintf('\nTurbo_R%d_QAM_N%d_K%d_Iter%d_1e%d\n',label.R,N,K,Iter,log10(MCsize));
 str = sprintf('Turbo_R%d_QAM_N%d_K%d_Iter%d_1e%d',label.R,PCTC.TotalCodedBits,PCTC.InformationBits,TxRx.Decoder.Iterations,log10(TxRx.Sim.nr_of_channels));
  
  tic;
  for trial=1:TxRx.Sim.nr_of_channels
        
    % -- draw random bits and map to symbol
    InformationBits = round(rand(1,PCTC.InformationBits));
        
    % -- encode and BPSK map InformationBits
    CodedBitStream = PCTC_encode(PCTC,InformationBits); 
    
    if(mod((length(CodedBitStream)),2) ==1) % if odd
        CodedBitStream = [CodedBitStream 0];
    end
    
    MappedBitStream = sign((CodedBitStream==0)-0.5); % mapping: 1 to -1.0 and 0 to +1.0
    
    [tt,Blocklength] = size(CodedBitStream);
    reshapedBitStream = reshape(MappedBitStream,bitsPerSymbol,Blocklength/bitsPerSymbol); 
    
    modulatedBitStream =  reshapedBitStream(1,:)+ 1i*reshapedBitStream(2,:);
    
%     MappedBitStream = sign((CodedBitStream==0)-0.5); % mapping: 1 to -1.0 and 0 to +1.0
    
    % -- prepare Gaussian Noise    
    noise = (1/sqrt(2))* (  randn(1,length(reshapedBitStream))+ 1i*randn(1,length(reshapedBitStream))); 
    
    for k=1:length(TxRx.Sim.EbNo_dB_list)
        
      % -- simulate AWGN channel
      y = modulatedBitStream + noise*sqrt(sigma2(k));
      
      % -- compute LLRs             
      initialLRs = zeros(1,length(CodedBitStream));
      initialLRs(1:2:end) = (2/sigma2(k)) * real(y); 
      initialLRs(2:2:end) = (2/sigma2(k)) * imag(y);
      LLR_A2= initialLRs(1:PCTC.TotalCodedBits);
%       LLR_A2 =  +2*y/sigma2(k);      
      
      % -- decode PCTC
      [LLR_A1,LLR_P1,binary_data_hat] = PCTC_decode(TxRx,PCTC,LLR_A2,TxRx.Decoder.Iterations);           
      
      % -- calculate BER
      tmp = sum(abs(InformationBits-binary_data_hat))/PCTC.InformationBits;
      BER(k) = BER(k) + tmp;  
      FER(k) = FER(k) + (tmp>0);
      
    end
    
    if mod(trial,10)==1
      disp(sprintf('Estimated remaining time is %1.2f minutes.',(toc)/trial*(TxRx.Sim.nr_of_channels-trial)/60));
      SaveResults(RunID,TxRx,PCTC,trial,BER,FER,label.folder,str);
    end
    
  end

  % -- simulation run finished
  SaveResults(RunID,TxRx,PCTC,trial,BER,FER,label.folder,str);
  disp(sprintf('\n### Simulation completed.\n')); 
  
return

% -- save results to disk
function SaveResults(RunID,TxRx,PCTC,trial,BER,FER,folder,str)
  Results.TxRx = TxRx;
  Results.PCTC = PCTC;
  Results.EbNo = TxRx.Sim.EbNo_dB_list;
  Results.BER = BER/trial;
  Results.FER = FER/trial;
  Results.Trials = trial;
  Results.FileName = sprintf([folder '/%s.mat'],str);
  save(Results.FileName,'Results');  
return
