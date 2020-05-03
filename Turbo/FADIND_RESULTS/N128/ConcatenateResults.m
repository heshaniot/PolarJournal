% [0 1 2 3],
%     1.5 2.5
EbNo_mat1 = [0  1 2 3  4 5  ];
EbNo_mat2 =EbNo_mat1;
EbNo_mat3 = EbNo_mat1 ;


% EbNo_mat2=  [0 0.5 1      1.5   2 2.5 2.75];
% EbNo_mat3 = [0 0.5 1 1.5  2     2.5   3 3.5 3.75 ];

R_vec = [13  12  23];
% R_vec = [13 ];
K_vec = [40 64 80];
N_vec = [132 140 132];
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
    FER = [];
    BER = [];
    for i=1:length(EbNo_vec)
        
        load(sprintf('Turbo_R%d_QAM_N%d_K%d_Iter6_%.2fdB_1e5.mat',R,N,K,EbNo_vec(i)));     
        EbNo = [EbNo Results.EbNo];
        FER = [FER Results.FER];
        BER = [BER Results.BER];
               
    end
    
     Results.EbNo = EbNo;
     Results.FER = FER;
     Results.BER = BER ;
     
     filename = sprintf('Turbo_N%d_R%d',N,R);
     save(filename,'Results')

    subplot(211)
    semilogy(Results.EbNo,Results.FER);
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

