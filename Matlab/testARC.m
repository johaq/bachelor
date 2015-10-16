hFig = figure(1);
set(hFig, 'Position', [100 0 1000 700])

counter=1;
for z=1:3
    for y=1:3
        subplot(3,3,counter);
        set(0,'DefaultTextInterpreter', 'latex')
        hold on
        axis([0.5 1 0.8 1]);
        if(counter>6)
            xlabel('$$ \frac{\left|A_{\bar{\Theta}}\right|}{|X|} $$');
        else
            xlabel('');
            set(gca,'XTickLabel',{});
        end
        if(mod((counter-1),3) == 0)
            ylabel('$$ \frac{\left|L \cap A_{\bar{\Theta}}\right|}{\left|A_{\bar{\Theta}}\right|} $$');
        else
            ylabel('');
            set(gca,'YTickLabel',{}) 
        end
        if(counter==1)
            title('2 classes');
        elseif(counter==2)
            title('4 classes');
        elseif(counter==3)
            title('8 classes');
        end
        
        if(mod((counter-1),3) == 0)
            randTest1DARC;
        end
        if(mod((counter-2),3) == 0)
            randTest2DARC;
        end
        if(mod((counter-3),3) == 0)
            randTest3DARC;
        end
        counter = counter + 1;
        hold off
    end
end