% =========================================================================
% Title       : Main PCTC encoder file
% File        : sim_encode.m
% -------------------------------------------------------------------------
% Description :
%   Encodes parallel-concatenated turbo codes by using the PCTC structure.
% ------------------------------------------------------------------------- 
% Revisions   :
%   Date       Version  Author  Description
%   11-dec-11  1.3      studer  cleanup for reproducible research
%   11-mar-07  1.2      studer  added puncturing
%   06-mar-07  1.1      studer  optimized for improved readability
%   03-mar-07  1.0      studer  file created
% -------------------------------------------------------------------------
%   (C) 2006-2011 Communication Theory Group                      
%   ETH Zurich, 8092 Zurich, Switzerland                               
%   Author: Dr. Christoph Studer (e-mail: studer@rice.edu)     
% =========================================================================

function CodedBitStream = PCTC_encode(PCTC,InformationBits) 

  % == 1st component encoder ==
  [EncoderOut1,EndState1] = convenc(InformationBits,PCTC.Trellis);
     
  % -- extract coded and systematic bits from 1st encoder
  SystematicBits1 = EncoderOut1(1:2:end); % extract systematic bits
  UnpuncturedCodedBits1 = EncoderOut1(1+(1:2:end-1)); % Coded output 1  
  CodedBits1 = UnpuncturedCodedBits1(PCTC.Puncturing.Index1); % puncturing 1
  
  % -- force 1st encoder into zero state
  TailBits1 = PCTC.OutputTerminationSequence(EndState1+1,:); 
    
  % == 2nd component encoder ==
  [EncoderOut2,EndState2] = convenc(InformationBits(PCTC.Interleaver.Perm),PCTC.Trellis);
    
  % -- extract coded bits from 2nd encoder
  UnpuncturedCodedBits2 = EncoderOut2(1+(1:2:end-1)); % Coded output 2
  CodedBits2 = UnpuncturedCodedBits2(PCTC.Puncturing.Index2); % puncturing 2

  % -- force 2nd encoder into zero state
  TailBits2 = PCTC.OutputTerminationSequence(EndState2+1,:);

  % == create coded bit stream ==  
  CodedBitStream = [ SystematicBits1 CodedBits1 TailBits1 CodedBits2 TailBits2 ];
  
return