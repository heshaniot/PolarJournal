function ldpcBER1() 
%  ERR_LDPC_120b_R12_LAYERED_OMS_I5(RunID) 
  %N=120 K=60 R=12 
  % == LDPC SETTINGS ====================================
  RunID=0;
  TxRx.Sim.name = 'ERR_LDPC_120b_R12_LAYERED_OMS_I5';
  TxRx.Sim.nr_of_channels = 1e0; % 1k for good results, 10k for accurate results
  TxRx.Sim.EbNo_dB_list = [0:1:1];
  TxRx.Decoder.LDPC.Scheduling = 'Layered'; % 'Layered' and 'Flooding'
  TxRx.Decoder.LDPC.Type = 'OMS'; % 'MPA' and 'SPA' (optimal)
  TxRx.Decoder.LDPC.Iterations = 50;  
  load('codes/LDPC_11nD2_120b_R12.mat'); % load code
  
  % == EXECUTE SIMULATION ===============================  
  
  sim_LDPC_par(RunID,TxRx,LDPC) 
  
return
  
