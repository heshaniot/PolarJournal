function SCLparams=initListDecode(PCparams,SCLparams)

%initialize List Decoder
% global PCparams
% global SCLparams

L = PCparams.L ;
N = PCparams.N ;

inactivePathIndices = java.util.Stack(); 

for l=1:L
    inactivePathIndices.push(l);
end

SCLparams.LLR = zeros(L,2*N-1);
SCLparams.BITS = zeros(2*L,N-1);
SCLparams.d_hat = zeros(N,L);
SCLparams.inactivePathIndices = inactivePathIndices;
SCLparams.pathMatric= zeros(L,1);
SCLparams.activePath = zeros(L,1);


end