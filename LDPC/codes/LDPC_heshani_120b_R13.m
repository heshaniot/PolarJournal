% =============================================================================
% Title       : 802.11n D2.0 LDPC Code Definition
% -----------------------------------------------------------------------------
% Revisions   :
%   Date       Version  Author  Description
%   04-oct-07  1.0      studer  file created
% =============================================================================

function LDPC = LDPC_heshani_120b_R13

  LDPC.name = 'LDPC_heshani_120b_R13.mat';
%    5670 bits. Sub-matrix dimension 378.
%   LDPC.Z = 378; % subblock size
  LDPC.Z = 8; % subblock size
  %----------
  LDPC_heshani_3780b_R13 =[ 
                           -1    -1   227   275   231     0    -1    -1    -1    -1    -1    -1    -1    -1    -1
                           317   282    -1    90   361   260     0    -1    -1    -1    -1    -1    -1    -1    -1
                            -1   371    -1   359   163    -1   275     0    -1    -1    -1    -1    -1    -1    -1
                            87    -1   321    -1    -1    -1   117    50     0    -1    -1    -1    -1    -1    -1
                            -1   301    -1    -1    -1   241   279    -1   143     0    -1    -1    -1    -1    -1
                           376    -1    -1    -1    90    -1    -1    -1   155    -1     0    -1    -1    -1    -1
                           249    -1    -1   223    -1    -1    21    -1    -1    -1    -1     0    -1    -1    -1
                           263    -1    -1    -1   203    -1    -1    -1   102   171    -1    -1     0    -1    -1
                            15    -1    52    -1    -1    21    -1   307    -1    -1    -1    -1    -1     0    -1
                            14   100    -1    -1    -1    -1    -1    -1    -1   178   186    -1   153    -1     0 
                        ];

%    [row col] = size(LDPC_heshani_5670b_R13);

%     prot = cell(row,col) ;
%     for i=1:row
%         for j=1:col
%                 if H_r12_n120_z5(i,j) ~= -1
%                     H_r12_n120_z5(i,j) = mod(H_r12_n120_z5(i,j),LDPC.Z);
%                 end
%                 prot{i,j} =  int2str(H_r12_n120_z5(i,j));
%                 if strcmp(prot(i,j),'-1')
%                     prot{i,j}='-';
%                 end
%         end
%     end
  LDPC_heshani_3780b_R13(LDPC_heshani_3780b_R13~=-1)= mod(LDPC_heshani_3780b_R13(LDPC_heshani_3780b_R13~=-1),LDPC.Z);
  %----------
    
  LDPC.H_prot = LDPC_heshani_3780b_R13;
  LDPC = genmatt(LDPC); % compute check and generator matrices
  
return
            