function Turbo_R12_128n(ebn) 
 timetot = tic;
  RunID=0;
  % == PCTC SETTINGS ====================================
  TxRx.Sim.name = 'heshani_R12_128n';
  TxRx.Sim.nr_of_channels = 1e5; % 1k for good results, 10k for accurate results
  TxRx.Sim.no_of_channel_Taps = 7;
  TxRx.Sim.EbNo_dB_list = [ebn];
  
  TxRx.Decoder.Type = 'MPA'; % 'MPA' and 'SPA' (optimal)
  TxRx.Decoder.Iterations = 6;     
  TxRx.Decoder.Scaling = 0.6875; % good scaling value for max-log algorithm
  
  % == SETUP CODE PROPERTIES ============================
  load('codes/heshani_R12_128n.mat') % load code  
  % == EXECUTE SIMULATION ===============================  
  
  label.folder = 'FADIND_RESULTS/N128' ;
  label.R = 12 ;
  
  fprintf('\nTurbo_R%d_QAM_N%d_K%d_Iter%d_1e%d\n',label.R,PCTC.TotalCodedBits,PCTC.InformationBits,TxRx.Decoder.Iterations,log10(TxRx.Sim.nr_of_channels));

%   sim_PCTC(RunID,TxRx,PCTC) 
%   sim_PCTC_QAM(RunID,TxRx,PCTC,label); 

  sim_PCTC_QAM_AWGN(RunID,TxRx,PCTC,label); 
  fprintf('\n\ntotal time %.2f seconds\n',toc(timetot));
  
return
  
