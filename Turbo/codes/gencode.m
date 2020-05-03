% =========================================================================
% Title       : Generate PCTC Code Information
% File        : gencode.m
% -------------------------------------------------------------------------
% Description :
%   Creates PCTC related encoder and decoder information.
% ------------------------------------------------------------------------- 
% Revisions   :
%   Date       Version  Author  Description
%   11-dec-11  1.3      studer  cleanup for reproducible research
%   11-mar-07  1.1      studer  modified structure for puncturing
%   28-feb-07  1.0      studer  file created
% -------------------------------------------------------------------------
%   (C) 2006-2011 Communication Theory Group                      
%   ETH Zurich, 8092 Zurich, Switzerland                               
%   Author: Dr. Christoph Studer (e-mail: studer@rice.edu)     
% =========================================================================

function PCTC = gencode(PCTC)
 
  disp(sprintf('### Generate code \"%s\"',PCTC.name))
  
  % -- initialization
  PCTC.Feedback = PCTC.Generator(1);  % same as feedback  
  PCTC.ConstraintLength = PCTC.V + 1; % v+1
  
  % == Generate PCTC trellis structure ==================  
  PCTC.Trellis = poly2trellis(PCTC.V+1,PCTC.Generator,PCTC.Feedback);
  
  % == Compute input and output termination sequences ===  
  statelist = 0:2^PCTC.V-1;
  sequences = de2bi(statelist);    
  for startstate=statelist
    validseq = 0;
    % -- try all possible sequence and see which one leads to zero state
    % -- stupid approach but it works :-)
    for seq=1:length(sequences)
      [ tmp endstate ] = convenc(sequences(seq,:),PCTC.Trellis,ones(1,PCTC.V),startstate);
      if endstate==0
        inputtermsequence(startstate+1,:) = sequences(seq,:);
        validseq = 1;
      end
    end
    % -- check if valid sequence can be found (sanity check)      
    if validseq==0
      error('no valid termination sequence found')
    else
      outputtermsequence(startstate+1,:) = convenc(inputtermsequence(startstate+1,:),PCTC.Trellis,ones(1,PCTC.V),startstate);
    end   
  end
  
  % -- assign termination sequences
  PCTC.InputTerminationSequence = inputtermsequence;  
  PCTC.OutputTerminationSequence = outputtermsequence;

  % -- compute puncturing patterns 
  [PCTC.Puncturing.Index1,PCTC.Puncturing.Length1] = ...
    genpuncturing(PCTC.InformationBits,PCTC.Puncturing.Period1,PCTC.Puncturing.Pattern1); 
  [PCTC.Puncturing.Index2,PCTC.Puncturing.Length2] = ...
    genpuncturing(PCTC.InformationBits,PCTC.Puncturing.Period2,PCTC.Puncturing.Pattern2);   
  
  % -- compute total blocklength of coded and information bits
  PCTC.TotalCodedBits = PCTC.InformationBits + ...
                        length(PCTC.Puncturing.Index1) + ...
                        length(PCTC.Puncturing.Index2) + ...
                        2*length(PCTC.OutputTerminationSequence(1,:));                       
  disp(sprintf('Total length of codeblock is %i',PCTC.TotalCodedBits));
        
  % -- store PCTC construct  
  disp(sprintf('Store PCTC data structure to disc'));
  save(PCTC.name,'PCTC'); 

return

% == PCTC puncturing index pattern generation
function [Index,IndexLength] = genpuncturing(BlockLength,Period,Pattern)

  % -----------------------------------------------
  % example puncturing patterns:
  %
  %   Period = 18;  %R = 12/18 = 2/3 heshani
  %   Pattern = [ 1 2 3 6 7 8 9 12 13 14 15 18 ]; 
  % 
  %   Period = 10;   %R = 6/10 = 3/5
  %   Pattern = [ 1 2 3 6 7 10 ];  
  %  
  %   Period = 2; % R=1/2 odd puncturing
  %   Pattern = [ 1 ];  
  %  
  %   Period = 1; % no puncturing
  %   Pattern = [ 1 ];  
  % -----------------------------------------------

  % -- Ideal rate of puncturing pattern
  PatternLength = length(Pattern);
  
  % -- Ideal rate of puncturing pattern
  IdealRate = PatternLength/(Period); 
  
  % -- generate puncturing pattern indices 
  for i=1:ceil(BlockLength*IdealRate)  
    Index(PatternLength*(i-1)+1:PatternLength*i) = (i-1)*Period+Pattern;
  end
 
  % -- remove tail uneccessary padding bits
  Index(:,round(BlockLength*IdealRate)+1:end) = [];
  IndexLength = length(Index);
  
  % -- output true obtained data rate
  TrueRate = length(Index)/BlockLength;
    
  disp(sprintf('Generate puncturing of rate %2.2f (true rate %2.2f)',IdealRate,TrueRate))
  
return
