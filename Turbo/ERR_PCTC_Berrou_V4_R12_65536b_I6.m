% function ERR_PCTC_Berrou_V4_R12_65536b_I6(RunID) 
  RunID =0;
  % == PCTC SETTINGS ====================================
  TxRx.Sim.name = 'ERR_PCTC_Berrou_V4_R12_65536b_I6';
  TxRx.Sim.nr_of_channels = 1000; % 1k for good results, 10k for accurate results
  TxRx.Sim.EbNo_dB_list = [0:0.25:3];
  
  TxRx.Decoder.Type = 'SPA'; % 'MPA' (max-log) and 'SPA' (optimal)
  TxRx.Decoder.Iterations = 6;
  TxRx.Decoder.Scaling = 1.0;
  
  % == SETUP CODE PROPERTIES ============================
  load('codes/PCTC_Berrou_V4_R12_65536b.mat') % load code  
  
  % == EXECUTE SIMULATION ===============================  
  sim_PCTC(RunID,TxRx,PCTC) 
  
return
  
