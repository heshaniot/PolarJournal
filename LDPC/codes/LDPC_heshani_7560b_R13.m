% =============================================================================
% Title       : 802.11n D2.0 LDPC Code Definition
% -----------------------------------------------------------------------------
% Revisions   :
%   Date       Version  Author  Description
%   04-oct-07  1.0      studer  file created
% =============================================================================

function LDPC = LDPC_heshani_7560b_R13

  LDPC.name = 'LDPC_heshani_7560b_R13.mat';
%    5670 bits. Sub-matrix dimension 378.
  LDPC.Z = 504; % subblock size
  %----------
  LDPC_heshani_7560b_R13 =[-1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1    -1 ;
                            451   128   -1    481   163   0     -1    -1    -1    -1    -1    -1    -1    -1    -1 ;
                            19    -1    402   383   34    79    0     -1    -1    -1    -1    -1    -1    -1    -1 ;
                            231   29    -1    289   167   -1    78     0    -1    -1    -1    -1    -1    -1    -1 ;
                            139   -1    -1    -1    203   -1    82     75    0    -1    -1    -1    -1    -1    -1 ;
                            -1    -1    79    -1    155   317   -1     406  -1     0    -1    -1    -1    -1    -1 ;
                            -1    -1    372   -1    294   -1    421    249  -1    -1    0     -1    -1    -1    -1 ;
                            -1    -1   251    -1    -1    -1     36    324  -1    -1    -1     0    -1    -1    -1 ;
                            305   -1   419    -1    -1    -1    128    478  -1    -1    488   -1    0     -1    -1 ;
                            353   -1    -1    -1    -1    -1    164    -1    -1   83    -1    234   -1    0     -1 ;
                            -1    -1   353    -1    -1    -1    -1    -1    400   38    -1    -1    -1    -1    0 ];

%    [row col] = size(LDPC_heshani_7560b_R13);
% 
%     prot = cell(row,col) ;
%     for i=1:row
%         for j=1:col
% %                 if H_r12_n120_z5(i,j) ~= -1
% %                     H_r12_n120_z5(i,j) = mod(H_r12_n120_z5(i,j),LDPC.Z);
% %                 end
%                 prot{i,j} =  int2str(H_r12_n120_z5(i,j));
%                 if strcmp(prot(i,j),'-1')
%                     prot{i,j}='-';
%                 end
%         end
%     end
%   %----------
%     
  LDPC.H_prot = LDPC_heshani_7560b_R13;
  LDPC = genmatt(LDPC); % compute check and generator matrices
  
return
            