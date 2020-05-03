function ERR_PCTC_LTE_V3_R12_1952b_I10(RunID) 

  % == PCTC SETTINGS ====================================
  TxRx.Sim.name = 'ERR_PCTC_LTE_V3_R12_1952b_I10';
  TxRx.Sim.nr_of_channels = 10000; % 1k for good results, 10k for accurate results
  TxRx.Sim.EbNo_dB_list = [0:0.5:3];
  
  TxRx.Decoder.Type = 'MPA'; % 'MPA' and 'SPA' (optimal)
  TxRx.Decoder.Iterations = 10;     
  TxRx.Decoder.Scaling = 0.6875; % good scaling value for max-log algorithm
  
  % == SETUP CODE PROPERTIES ============================
  load('codes/PCTC_LTE_V3_R12_1952b.mat') % load code  
  
  % == EXECUTE SIMULATION ===============================  
  sim_PCTC(RunID,TxRx,PCTC) 
  
return
  
