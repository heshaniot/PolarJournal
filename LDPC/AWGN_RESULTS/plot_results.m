% [0 1 2 3],
%     1.5 2.5
ebno = [ 1 2 3  4 5 ];

N=120
K=60
R=12

    
EbNo_vec = ebno ;
EbNo = [];
BLER = [];
BER = [];
for i=1:length(EbNo_vec)

    load(sprintf('LDPC_N%d_K%d_R%d_QAM_OMS_Iter10_1e6_EbNo%.2f_point1.mat',N,K,R,EbNo_vec(i)));     
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
xlabel('EbNo')
ylabel('BLER')
hold on;
%     xlim([0 4])
grid on
title('')
subplot(212)
semilogy(Results.EbNo,Results.BER);
xlabel('EbNo')
ylabel('BER')


hold on;
grid on
%     xlim([0 4])


