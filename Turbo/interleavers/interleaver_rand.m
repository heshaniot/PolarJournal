% =========================================================================
% Title       : Random interleaver
% File        : interleaver_rand.m
% -------------------------------------------------------------------------
% Description :
%   Creates simple random interleaver
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

function out = interleaver_rand(Seed,Length)
 
  rand('state',Seed);
  out = randperm(Length);
    
return