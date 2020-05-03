function SCLparams=updateBITS(latestbit, i,l,PCparams,SCLparams)
% PCparams structure is implicit parameter
%
% Non-Recursive implementation of the SCD update BITS routine
%

% global PCparams;
% global SCLparams ;
N = PCparams.N;
n = PCparams.n;

if i==N  %no bits need to be updated
    return;
elseif i<=(PCparams.N/2)
    SCLparams.BITS(2*l-1,1) = latestbit;
else
    
    %%%%%%TO IMPROVE LATER%%%%%%%%%
      %FINDING FIRST INDEX OF '0'
    i_bin = dec2bin(i-1,n);
    for lastlevel = 1:n
        if i_bin(lastlevel) == '0'
            break;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    SCLparams.BITS(2*l,1) = latestbit;
    for lev=1:lastlevel-2 %forms level (lev+1) using values @ level (lev)
        st = 2^(lev-1);
        ed = 2^lev -1 ;
        for indx = st:ed
            SCLparams.BITS(2*l,ed+2*(indx-st)+1) = mod( SCLparams.BITS(2*l-1,indx)+SCLparams.BITS(2*l,indx), 2 );
            SCLparams.BITS(2*l,ed+2*(indx-st)+2) = SCLparams.BITS(2*l,indx);
        end
    end
    
    lev=lastlevel-1;
    st = 2^(lev-1);
    ed = 2^lev -1 ;
    for indx = st:ed
        SCLparams.BITS(2*l-1,ed+2*(indx-st)+1) = mod( SCLparams.BITS(2*l-1,indx)+SCLparams.BITS(2*l,indx), 2 );
        SCLparams.BITS(2*l-1,ed+2*(indx-st)+2) = SCLparams.BITS(2*l,indx);
    end
end

end