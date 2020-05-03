% =============================================================================
% Title       : PCTC Code Definition file
% -----------------------------------------------------------------------------
% Revisions   :
%   Date       Version  Author  Description
%   06-mar-08  1.1      studer  added support for different interleavers
%   28-feb-08  1.0      studer  file created
% =============================================================================

function PCTC = heshani_R23_1024n

  PCTC.name = 'codes/heshani_R23_1024n.mat';
  
  % -- code properties
  PCTC.Generator = [13 15]; % [ feedback feedforward ]   
  PCTC.V = 3; % Code memory  
  PCTC.Rate = 2/3; % Rate
  PCTC.InformationBits = 672;  % N = K*R+12
  
  % -- interleaver pattern 
  PCTC.Interleaver.Perm = interleaver_3GPPLTE(1:PCTC.InformationBits); 
                      
  %R = 12/18 = 2/3
  %   Period = 18;  %R = 12/18 = 2/3 heshani
  %   Pattern = [ 1 2 3 6 7 8 9 12 13 14 15 18 ]; 
  
  % -- puncturing index patterns
  PCTC.Puncturing.Period1 = 4; PCTC.Puncturing.Pattern1 = [ 1 ]; % rate 1/2
  PCTC.Puncturing.Period2 = 4; PCTC.Puncturing.Pattern2 = [ 4 ]; % rate 1/2
  
  
  
  % == compute PCTC related data ==
  PCTC = gencode(PCTC);   
  
%   label.folder = 'HeshResults' ;
%   label.rate   = '23'; 
  
return
            