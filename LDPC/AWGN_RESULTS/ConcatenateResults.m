% [0 1 2 3],
%     1.5 2.5
EbNo_mat1 = [0 0.5  1 1.5  2 2.5  3 3. 4 4.5  5 ];
EbNo_mat2= [0 0.5  1 1.5  2 2.5  3 3. 4 4.5  5 ];
EbNo_mat3 = [0  1 2 3  4 5 ];

R_vec = [13  12  23];
% R_vec = [13 ];
K_vec = [40 60 80];
N_vec = [120 120 120];
% K_vec = [168 256 336];
% N_vec = [516 524 516];
file = 'N128';
L=1;
for r = 1:length(R_vec)
    R = R_vec(r);
    K = K_vec(r);
    N = N_vec(r);
    
    ebno = eval(sprintf('EbNo_mat%d',r));
    EbNo_vec = ebno ;
    EbNo = [];
    BLER = [];
    BER = [];
    for i=1:length(EbNo_vec)
        
        load(sprintf('LDPC_N%d_K%d_R%d_QAM_OMS_Iter50_1e5_EbNo%.2f_point1.mat',N,K,R,EbNo_vec(i)));     
        EbNo = [EbNo Results.EbNo];
        BLER = [BLER Results.BLER];
        BER = [BER Results.BER];
               
    end
    
     Results.EbNo = EbNo;
     Results.BLER = BLER;
     Results.BER = BER ;
     
     filename = sprintf('LDPC_N%d_R%d',N,R);
     save(filename,'Results')

    subplot(211)
    semilogy(Results.EbNo,Results.BLER);
    hold on;
%     xlim([0 4])
    grid on
    title('')
    subplot(212)
    semilogy(Results.EbNo,Results.BER);
    
    hold on;
    grid on
%     xlim([0 4])

    
end

