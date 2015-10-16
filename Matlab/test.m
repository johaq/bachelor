hFig = figure(1);
set(hFig, 'Position', [100 0 1000 700])

counter=1;
for z=1:3
    for y=1:3
        subplot(3,3,counter);
        hold on
        axis([0 65 0 150]);
        if(counter==1)
            title('2 classes');
        elseif(counter==2)
            title('4 classes');
        elseif(counter==3)
            title('8 classes');
        end
            
        if(counter>6)
            xlabel('True Rejects');
        else
            xlabel('');
            set(gca,'XTickLabel',{});
        end
        if(mod((counter-1),3) == 0)
            ylabel('False Rejects');
        else
            ylabel('');
            set(gca,'YTickLabel',{}) 
        end
        
        
        if(mod((counter-1),3) == 0)
            randTesttest;
        end
        if(mod((counter-2),3) == 0)
            randTest2Dtest;
        end
        if(mod((counter-3),3) == 0)
            randTest3Dtest;
        end
        counter = counter + 1;
        hold off
    end
end