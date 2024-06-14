function plotToI(data, timeStamp, Tasks)
%Plot Time of Interest..

    figure; hold on
    pData = data(:,3);
    plot(timeStamp(1:length(pData),:), pData);
    
%     pData2 = data(:,1, 51 );
%     pData = pData - mean(pData(:));
%     pData2 = pData2 - mean(pData2(:));
%     plot(timeStamp(1:length(pData),:), pData, timeStamp(1:length(pData),:), pData2);
    
       
    for i = 1:size(Tasks,1)

        ToI = cell2mat(Tasks(i,3:4));
        ind = cell2mat(Tasks(i,5:6));
        iStart = ind(1); iEnd = ind(2);
    
        rectToI.x = ToI(1);
        rectToI.w = ToI(2) - ToI(1);
        rectToI.h = (max(pData(iStart:iEnd)) - min(pData(iStart:iEnd)));
        rectToI.y = mean(pData(iStart:iEnd))-rectToI.h/2;

        rectangle('Position',[rectToI.x,rectToI.y,rectToI.w,rectToI.h], 'EdgeColor', 'r');
        text(rectToI.x,rectToI.y+rectToI.h,['\downarrow' Tasks{i,2}],'FontSize',10);


    end
    saveas(gcf,'ToI.fig','fig');
    hold off;
end