% =============================================================================
% Title       : PCTC Code Definition file
% -----------------------------------------------------------------------------
% Revisions   :
%   Date       Version  Author  Description
%   06-mar-08  1.1      studer  added support for different interleavers
%   28-feb-08  1.0      studer  file created
% =============================================================================

function PCTC = PCTC_Berrou_V4_R12_65536b

  PCTC.name = 'codes/PCTC_Berrou_V4_R12_65536b.mat';
  
  % -- code properties
  PCTC.Generator = [37 21]; % [ feedback feedforward ]   
  PCTC.V = 4; % Code memory  
  PCTC.Rate = 1/2; % Rate
  PCTC.InformationBits = 65536;
  
  % -- interleaver pattern 
  PCTC.Interleaver.Perm = interleaver_berrou65536; 
    
  % -- puncturing index patterns
  PCTC.Puncturing.Period1 = 2; PCTC.Puncturing.Pattern1 = [ 1 ]; % rate 1/2
  PCTC.Puncturing.Period2 = 2; PCTC.Puncturing.Pattern2 = [ 2 ]; % rate 1/2
  
  % == compute PCTC related data ==
  PCTC = gencode(PCTC);   
  
return
            