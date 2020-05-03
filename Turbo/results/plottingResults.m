% clear all;
% 
% str = sprintf('ERR_PCTC_LTE_V3_R12_64b_I10_0.mat',l);
% load(str);

EbNo = Results.TxRx.Sim.EbNo_dB_list; 
EbNo = EbNo+3
subplot(211)
% hold on
% turbo13 = semilogy(EbNo,Results.BLER);
turbo23 = semilogy(EbNo,Results.BLER);

hold on;


subplot(212)
% hold on
% turbo13 = semilogy(EbNo,Results.BER);

turbo23 = semilogy(EbNo,Results.BER);
hold on;

