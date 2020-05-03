% =========================================================================
% Title       : Main PCTC decoder file
% File        : sim_decoder.m
% -------------------------------------------------------------------------
% Description :
%   Decodes parallel-concatenated turbo codes by using the PCTC structure.
%   The coded bitstream is defined as follows: 
%             [SystematicBits1 CodedBits1 TailBits1 CodedBits2 TailBits2 ]
% ------------------------------------------------------------------------- 
% Revisions   :
%   Date       Version  Author  Description
%   11-dec-11  1.1      studer  cleanup for reproducible research
%   03-mar-07  1.0      studer  file created
% -------------------------------------------------------------------------
%   (C) 2006-2011 Communication Theory Group                      
%   ETH Zurich, 8092 Zurich, Switzerland                               
%   Author: Dr. Christoph Studer (e-mail: studer@rice.edu)     
% =========================================================================

function [LLR_E2,LLR_D2,binary_data_hat] = PCTC_decode(TxRx,PCTC,LLR_E1,Iterations)

  % -- initialization
  Length = PCTC.InformationBits; % number of information bits
  [tmp,TermBits] = size(PCTC.OutputTerminationSequence);
         
  % -- a-priori information and systematic exchange variables 
  % -- for decoding stages 1 and 2  
  PCTC_LLR_A1 = zeros(1,Length*2+TermBits); 
  PCTC_LLR_D1 = zeros(1,Length*2+TermBits); 
  SYS_LLR_E1 = zeros(1,Length); 
  SYS_LLR_A1 = zeros(1,Length); 
  PCTC_LLR_A2 = zeros(1,Length*2+TermBits); 
  PCTC_LLR_D2 = zeros(1,Length*2+TermBits); 
  SYS_LLR_E2 = zeros(1,Length); 
  SYS_LLR_A2 = zeros(1,Length); 
   
  % == desegmentation of received LLRs
  SystematicBits1 = LLR_E1(1:Length); 
  PuncturedCodedBits1 = LLR_E1(Length+1:Length+PCTC.Puncturing.Length1);
  CodedBits1 = zeros(1,PCTC.InformationBits);
  CodedBits1(PCTC.Puncturing.Index1) = PuncturedCodedBits1; % depuncturing  
  TailBits1 = LLR_E1(Length+PCTC.Puncturing.Length1+1:Length+PCTC.Puncturing.Length1+TermBits); 

  SystematicBits2 = SystematicBits1(PCTC.Interleaver.Perm);  
  PuncturedCodedBits2 = LLR_E1(Length+PCTC.Puncturing.Length1+TermBits+1:Length+PCTC.Puncturing.Length1+PCTC.Puncturing.Length2+TermBits);
  CodedBits2 = zeros(1,PCTC.InformationBits);
  CodedBits2(PCTC.Puncturing.Index2) = PuncturedCodedBits2; 
  TailBits2 = LLR_E1(Length+PCTC.Puncturing.Length1+PCTC.Puncturing.Length2+TermBits+1:Length+PCTC.Puncturing.Length1+PCTC.Puncturing.Length2+2*TermBits);
   
  % == BEGIN PCTC DECODING LOOP ==============================  
  for i=1:Iterations

    % == detection stage 1 ==
    PCTC_LLR_A1(1:2:2*Length) = SystematicBits1 + SYS_LLR_A1;
    PCTC_LLR_A1(1+(1:2:2*Length-1)) = CodedBits1;
    PCTC_LLR_A1(2*Length+1:2*Length+TermBits) = TailBits1;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BCJR DECODER USES REVERSE LLR DEFINITION
    switch (TxRx.Decoder.Type)
      case 'MPA', % max-log
        [PCTC_LLR_D1,tmp] = BCJR(PCTC.Trellis,-PCTC_LLR_A1); 
      case 'SPA', % log-MAP
        [PCTC_LLR_D1,tmp] = BCJRopt(PCTC.Trellis,-PCTC_LLR_A1);
    end
    PCTC_LLR_D1 = -PCTC_LLR_D1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    
    SYS_LLR_E1 = PCTC_LLR_D1(1:2:end-TermBits) - (SystematicBits1 + SYS_LLR_A1);      
    SYS_LLR_A2 = TxRx.Decoder.Scaling*SYS_LLR_E1(PCTC.Interleaver.Perm); %%% scaling 0.6875
    
    % == detection stage 2 ==
    PCTC_LLR_A2(1:2:2*Length) = SystematicBits2 + SYS_LLR_A2;
    PCTC_LLR_A2(1+(1:2:2*Length-1)) = CodedBits2;
    PCTC_LLR_A2(2*Length+1:2*Length+TermBits) = TailBits2;  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BCJR DECODER USES REVERSE LLR DEFINITION
    switch (TxRx.Decoder.Type)
      case 'MPA', % max-log
        [PCTC_LLR_D2,binary_data_hat_interleaved] = BCJR(PCTC.Trellis,-PCTC_LLR_A2);  
      case 'SPA', % log-MAP
        [PCTC_LLR_D2,binary_data_hat_interleaved] = BCJRopt(PCTC.Trellis,-PCTC_LLR_A2);
    end
    PCTC_LLR_D2 = -PCTC_LLR_D2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    SYS_LLR_E2 = PCTC_LLR_D2(1:2:end-TermBits) - (SystematicBits2 + SYS_LLR_A2);
    
    % -- extrinsic scaling (if required, e.g., 0.6875)
    SYS_LLR_A1(PCTC.Interleaver.Perm) = TxRx.Decoder.Scaling*SYS_LLR_E2;  
        
  end
  
  % -- segmentation 
  UnpuncturedOutCodedBits1 = PCTC_LLR_D1(1+(1:2:2*Length-1));
  OutCodedBits1 = UnpuncturedOutCodedBits1(PCTC.Puncturing.Index1);
  OutTailBits1 = PCTC_LLR_D1(2*Length+1:2*Length+TermBits);
  UnpuncturedOutCodedBits2 = PCTC_LLR_D2(1+(1:2:2*Length-1));
  OutCodedBits2 = UnpuncturedOutCodedBits2(PCTC.Puncturing.Index2);
  OutTailBits2 = PCTC_LLR_D2(2*Length+1:2*Length+TermBits);
  OutSystematicBits1(PCTC.Interleaver.Perm) = PCTC_LLR_D2(1:2:2*Length);
  
  % -- posterior and extrinsic output of the turbo decoder 
  LLR_D2 = [ OutSystematicBits1 OutCodedBits1 OutTailBits1 OutCodedBits2 OutTailBits2 ]; 
  LLR_E2 = LLR_D2 - LLR_E1;
  
  % -- extract binary estimates
  binary_data_hat(PCTC.Interleaver.Perm) =  binary_data_hat_interleaved(1:Length); % output

return