function ldpc120_R12_nbf(ebn) 
%  LDPC_heshani_504b_R23
  % == LDPC SETTINGS ====================================
  RunID=0;
  TxRx.Sim.name = 'LDPC_heshani_120b_R12';
  TxRx.Sim.nr_of_channels = 1e5; % 1k for good results, 10k for accurate results
%   ebn = 0;
  
  no = 1;
  TxRx.Sim.EbNo_dB_list = [ebn];
  TxRx.Decoder.LDPC.Scheduling = 'Layered'; % 'Layered' and 'Flooding'
  TxRx.Decoder.LDPC.Type = 'OMS'; % 'MPA' and 'SPA' (optimal)
  TxRx.Decoder.LDPC.Iterations =50;  
  load('codes/LDPC_11nD2_120b_R12.mat'); % load code
  
  % == EXECUTE SIMULATION ===============================  
  label.folder = 'FADING_RESULTS/NBF';
  label.number = no;
  label.rate = 12 ;
  sim_LDPC_QAM_RayleighFading_point_nobeamforming(RunID,TxRx,LDPC,label) 

%   sim_LDPC_point(RunID,TxRx,LDPC,label) 
  
return

