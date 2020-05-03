function updateLLR(l,i)
% PCparams structure is implicit parameter
%
% Non-Recursive implementation of the SCD update Likelihoods routine
%

global PCparams;
global SCLparams;

n = PCparams.n;



if i==1
    nextlevel=n;
else
    %%%%%%TO IMPROVE LATER%%%%%%%%%
      %FINDING FIRST INDEX OF '1'
    i_bin = dec2bin(i-1,n);
    for lastlevel = 1:n
        if i_bin(lastlevel) == '1'
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%% Initialize with lowerconv() %%%%%%
        st = 2^(lastlevel-1);
        ed = 2^(lastlevel) -1;
        for indx = st:ed
            SCLparams.LLR(l,indx) = lowerconv(...
                           SCLparams.BITS(2*l-1,indx), ...
                           SCLparams.LLR(l,ed+2*(indx-st)+1), ...
                           SCLparams.LLR(l,ed+2*(indx-st)+2) ...
                           );
        end
        nextlevel = lastlevel-1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Proceed upwards the TREE, with upperconv() till ROOT node
for lev = nextlevel :-1: 1
    st = 2^(lev-1);
    ed = 2^lev - 1;
    for indx = st:ed

% 	SCLparams.LLR(l,indx) = upperconv_mex(SCLparams.LLR(l,ed+2*(indx-st)+1), SCLparams.LLR(l,ed+2*(indx-st)+2));

    SCLparams.LLR(l,indx) = upperconv(SCLparams.LLR(l,ed+2*(indx-st)+1), SCLparams.LLR(l,ed+2*(indx-st)+2));



	
	%input1 = SCLparams.LLR(l,ed+2*(indx-st)+1);
	%input2 = SCLparams.LLR(l,ed+2*(indx-st)+2);

        %SCLparams.LLR(l,indx) = upperconv(input1,input2);
 	%output_from_mex = upperconv_mex(input1, input2);

 	%difference = SCLparams.LLR(l,indx)- output_from_mex;

 	%fprintf('Diff : %f\n', difference);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
