% [0 1 2 3],
%     1.5 2.5
clear all
% close all
EbNo_vec = 1:1:5;
% EbNo_mat2 =EbNo_mat1;
% EbNo_mat3 = EbNo_mat1 ;


% EbNo_mat2=  [0 0.5 1      1.5   2 2.5 2.75];
% EbNo_mat3 = [0 0.5 1 1.5  2     2.5   3 3.5 3.75 ];

%%%%%-------128
% R_vec = [13  12 23];
% K_vec = [43 64 85];
% N_vec = [128 128 128];

%%%%%-------1024
% R_vec = [13 12 23 ];
% K_vec = [170 256 341];
% N_vec = [512 512 512];


file = 'N128';
L=1;

    EbNo = [];
    BLER = [];
    BER = [];


for i=1:length(EbNo_vec)

    load(sprintf('Polar_N128_K64_R12_L32_%.2fdB_1e6_CRC8.mat' , EbNo_vec(i)));     
    EbNo = [EbNo results.EbNo];
    BLER = [BLER results.FER];
    BER = [BER results.BER];

end

     Results.EbNo = EbNo;
     Results.BLER = BLER;
     Results.BER = BER ;
     
%     filename = sprintf('Polar_N%d_R%d',N,R);
%     save(filename,'Results')

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





