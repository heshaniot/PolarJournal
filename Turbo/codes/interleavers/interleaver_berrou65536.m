% =========================================================================
% Title       : Block Interleaver as used by Berrou et al.
% File        : berrou65536.m
% -------------------------------------------------------------------------
% Description :
%   Creates simple block interleaver pattern as used in the original turbo
%   code paper by Berrou et al.
% ------------------------------------------------------------------------- 
% Revisions   :
%   Date       Version  Author  Description
%   11-dec-11  1.1      studer  cleanup for reproducible research
%   11-mar-08  1.0      studer  file created
% -------------------------------------------------------------------------
%   (C) 2006-2011 Communication Theory Group                      
%   ETH Zurich, 8092 Zurich, Switzerland                               
%   Author: Dr. Christoph Studer (e-mail: studer@rice.edu)     
% =========================================================================

function out = interleaver_berrou65536

  A = reshape(1:65536,256,256)';
  B = zeros(256,256);
  
  P = [ 17 37 19 29 41 23 13 7 ];
  
  for j=0:256-1
    for i=0:256-1
      ir = mod(129*(i+j),256);
      e = mod((i+j),8);
      jr = mod((P(e+1)*(j+1))-1,256);
      B(i+1,j+1) = A(ir+1,jr+1);
    end
  end
 
  out = B(:);
    
return