% [0 1 2 3],
%     1.5 2.5
load('resultsMAT/Polar_QPSK_designSNR2_N4096_K2730_L1_R12_1e5_CRC8.mat');

EbNo = results.EbNo;
FER = results.FER;
BER = results.BER;

load('HeshResults/Polar_N4096_K2730_R23_L1_1.50dB_1e2_CRC8.mat');

a.EbNo = [EbNo(1:2) results.EbNo EbNo(3)];
a.FER =  [FER(1:2) results.FER   FER(3)];
a.BER =  [BER(1:2) results.BER   BER(3)];

load('HeshResults/Polar_N4096_K2730_R23_L1_2.50dB_1e2_CRC8.mat');

Results.EbNo = [a.EbNo results.EbNo  EbNo(4)];
Results.FER =  [a.FER  results.FER   FER(4)];
Results.BER =  [a.BER  results.BER   BER(4)];

filename = sprintf('HeshResults/Polar_N4096_L1_R23');
save(filename,'Results')

subplot(211)
semilogy(Results.EbNo,Results.FER);
hold on;
    
subplot(212)
semilogy(Results.EbNo,Results.BER);
hold on;