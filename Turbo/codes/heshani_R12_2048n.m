% =============================================================================
% Title       : PCTC Code Definition file
% -----------------------------------------------------------------------------
% Revisions   :
%   Date       Version  Author  Description
%   06-mar-08  1.1      studer  added support for different interleavers
%   28-feb-08  1.0      studer  file created
% =============================================================================

function PCTC = heshani_R12_2048n

  PCTC.name = 'codes/heshani_R12_2048n.mat';
  
  % -- code properties
  PCTC.Generator = [13 15]; % [ feedback feedforward ]   
  PCTC.V = 3; % Code memory  
  PCTC.Rate = 1/2; % Rate
  PCTC.InformationBits = 1008;
  
  % -- interleaver pattern 
  PCTC.Interleaver.Perm = interleaver_3GPPLTE(1:PCTC.InformationBits); 
                      
  % -- puncturing index patterns
  PCTC.Puncturing.Period1 = 2; PCTC.Puncturing.Pattern1 = [ 1 ]; % rate 1/2
  PCTC.Puncturing.Period2 = 2; PCTC.Puncturing.Pattern2 = [ 2 ]; % rate 1/2
  
  % == compute PCTC related data ==
  PCTC = gencode(PCTC);   
  
return
            