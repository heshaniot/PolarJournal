function ldpc120_R12(ebn) 
%  LDPC_heshani_504b_R23
  % == LDPC SETTINGS ====================================
  RunID=0;
  TxRx.Sim.name = 'LDPC_heshani_120b_R12';
  TxRx.Sim.nr_of_channels = 1e6; % 1k for good results, 10k for accurate results
%   ebn = 0;
  snr =ebn;
  no = 1;
  TxRx.Sim.EbNo_dB_list = [snr];
  TxRx.Decoder.LDPC.Scheduling = 'Layered'; % 'Layered' and 'Flooding'
  TxRx.Decoder.LDPC.Type = 'OMS'; % 'MPA' and 'SPA' (optimal)
  TxRx.Decoder.LDPC.Iterations =10;  
  load('codes/LDPC_11nD2_120b_R12.mat'); % load code
  
  % == EXECUTE SIMULATION ===============================  
  label.folder = 'AWGN_RESULTS';
  label.number = no;
  label.rate = 12 ;
  sim_LDPC_QAM_AWGN(RunID,TxRx,LDPC,label) 

%   sim_LDPC_point(RunID,TxRx,LDPC,label) 
  
return

