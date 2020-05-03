% parfor j=1:6

addpath(genpath('codes\'));
addpath(genpath('realArith\'));
addpath(genpath('AWGN_RESULTS\'));
addpath(genpath('param\'));
addpath(genpath('decoders\'))
parfor ebn=1:1:5
    

     ldpc120_R12(ebn);
        
end