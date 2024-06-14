function h = plotTrace(data_out, data_in, options)

    figure; hold on
    
    wGLine = 2;
    wTLine = 2;
    
    switch size(data_out,2)
        case 1
            micron_Fs = 2016.1/2;
            dt = 1/micron_Fs*options.dec_by;
            time = 0:dt:(size(data_out,1)-1)*dt;
            h(1) = plot(time',data_out(:,1),'r','LineWidth',wTLine);
            h(2) = plot(time',data_in(:,1),'g','LineWidth',wGLine);
            
%             for i=1:size(data_out,2)
%                 hc(1) = plot(time',data_out(:,i),'r','LineWidth',wTLine);
%                 hc(2) = plot(time',data_in(:,i),'g','LineWidth',wGLine);
%             end
             xlabel('Time (s)'), ylabel('Amplitude (\mum)');
             
        case 2
             h(1) = plot(data_out(:,1),data_out(:,2),'r','LineWidth',wTLine);
             h(2) = plot(data_in(:,1),data_in(:,2),'g','LineWidth',wGLine); 
             xlabel('X (\mum)'), ylabel('Y (\mum)');
             
        case 3
            h(1) = plot3(data_out(:,1),data_out(:,2),data_out(:,3),'r','LineWidth',wTLine);
            h(2) = plot3(data_in(:,1),data_in(:,2),data_in(:,3),'g','LineWidth',wGLine);
            daspect([1 1 1]);
            view(3);
            xlabel('X (\mum)'), ylabel('Y (\mum)'), zlabel('Z (\mum)')
    end

    
    contents = {'Tip position', 'Goal position'};
    legend(h,contents);
    grid on;
    %axis equal;

   
    hold off;
    

end