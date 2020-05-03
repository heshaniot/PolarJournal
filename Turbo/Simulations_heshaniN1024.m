

parfor j=1:12
    
        if j<=4
            cc = 1 ;
        elseif j<=8
            cc = 2 ;
        else
            cc = 3;
        end
        

        switch(cc)
            case 1 
                ebn = j-0.5;
                Turbo_R13_1024n(ebn);
            case 2
                ebn = j-4.5 ;
                Turbo_R12_1024n(ebn);
            case 3
                ebn = j-8.5;
                Turbo_R23_1024n(ebn);
        end

end