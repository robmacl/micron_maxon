function h = errPlot(data_out, data_in)

    figure; hold on
    h(1) = plot3(data_out(:,1),data_out(:,2),data_out(:,3),'r','LineWidth',1);
    h(2) = plot3(data_in(:,1),data_in(:,2),data_in(:,3),'g','LineWidth',2); 
    contents = {'Tip position', 'Goal position'};
    legend(h,contents);
    grid on; axis equal;
    view(3);
    xlabel('x'); ylabel('y'); zlabel('z');
    hold off;
    

end