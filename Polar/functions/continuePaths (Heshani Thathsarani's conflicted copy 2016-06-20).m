function continuePaths(i)

global PCparams;
global SCLparams;

pathForks = zeros(PCparams.L,2);

count=0;

%Populate ProbForks
for l=1:PCparams.L
    if SCLparams.activePath(l)==1 %true
        llr = SCLparams.LLR(l,1);  
        for u=0:1              
            pathForks(l,u+1) = SCLparams.pathMatric(l)+ log(1+exp((2*u-1)*llr));
        end
        count=count+1 ;
    else
        pathForks(l,1) = Inf; 
        pathForks(l,2) = Inf;
    end
end

rho = min(2*count,PCparams.L);

contForks = zeros(PCparams.L,2);

% sort
if rho>0
    sorted = sort(pathForks(:));
    rhoth_smallest = sorted(rho);

    % get the rho'th smallest
    contForks(pathForks < rhoth_smallest) = 1;
    count1 = sum(sum(contForks)');
 
    ties = sum(pathForks(:)== rhoth_smallest);
    if(ties==1)
        contForks(pathForks==rhoth_smallest)=1;
    else
% % % % % % % %         Random Tie breaking
    remain = rho-count1 ; %tie breakin
    ind = randperm(ties,remain);
    ind_count=1;
    for l=1:PCparams.L
        for b=1:2     
            if ((pathForks(l,b) == rhoth_smallest)) 
                if sum(find(ind==ind_count))
                    contForks(l,b)=1;
                end
                   ind_count = ind_count+1 ;
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % NOT RANDOM TIE BREAKING
%         remain = rho-count1 ; %tie breakin
%         ind_count=0;
%        for l=1:PCparams.L
%             for b=1:2     
%                 if ((pathForks(l,b) == rhoth_smallest))&&(ind_count<remain)
%                         contForks(l,b)=1;
%                         ind_count = ind_count+1 ;
%                 end
%             end
%        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

for l=1:PCparams.L
    if SCLparams.activePath(l)==0
        continue
    end
    if ((contForks(l,1)==0)&&(contForks(l,2)==0))
        SCLparams.activePath(l) = 0 ;
        SCLparams.inactivePathIndices.push(l);
        SCLparams.pathMatric(l) = Inf; %%%%%%%%%%%%%%
    end
end

%Then continue the relevant paths and duplicate if neccessary
for l=1:PCparams.L
    %both forks are bad
    if ((contForks(l,1)==0)&&(contForks(l,2)==0))
        continue
    end
    
    if ((contForks(l,1)==1)&&(contForks(l,2)==1)) %both forks are good
        SCLparams.d_hat(i,l) = 0;
        SCLparams.pathMatric(l) = pathForks(l,1);
        
        %clone Path
        l1 = SCLparams.inactivePathIndices.pop();
        SCLparams.activePath(l1)=1;
        SCLparams.LLR(l1,:)= SCLparams.LLR(l,:);
        SCLparams.BITS(2*l1-1,:)= SCLparams.BITS(2*l-1,:);
        SCLparams.BITS(2*l1,:)= SCLparams.BITS(2*l,:);
        SCLparams.d_hat(:,l1) = SCLparams.d_hat(:,l);
        
        SCLparams.d_hat(i,l1) = 1;
        SCLparams.pathMatric(l1)= pathForks(l,2);

    else %exactly one fork is good
        if (contForks(l,1)==1)
            SCLparams.d_hat(i,l) = 0;
            SCLparams.pathMatric(l) = pathForks(l,1);
        else
            SCLparams.d_hat(i,l) = 1;
            SCLparams.pathMatric(l) = pathForks(l,2);
        end
    end
end

end