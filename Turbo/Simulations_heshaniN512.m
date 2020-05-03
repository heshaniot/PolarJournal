ebnv = [ 1.5 2.5 3.5] ;

parfor j=1:3
%     
%         if j<=3
%             cc = 1 ;
% %         elseif j<=12
% %             cc = 2 ;
%         elseif j>3
%             cc = 2;
%         end
        

%         switch(cc)
%             case 1 
                ebn = ebnv(j);
                Turbo_R23_512n(ebn);
%             case 2
%                 ebn = ebnv(j-3) ;
%                 Turbo_R12_512n(ebn);
% %             case 3
% %                 ebn = j-13;
% %                 Turbo_R23_512n(ebn);
%         end

end