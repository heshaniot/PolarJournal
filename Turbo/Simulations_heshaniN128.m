

parfor j=1:18
    
        if j<=6
            cc = 1 ;
        elseif j<=12
            cc = 2 ;
        elseif j>12
            cc = 3;
        end
        

        switch(cc)
            case 1 
                ebn = j-1;
                Turbo_R13_128n(ebn);
            case 2
                ebn = j-7 ;
                Turbo_R12_128n(ebn);
            case 3
                ebn = j-13;
                Turbo_R23_128n(ebn);
        end

end