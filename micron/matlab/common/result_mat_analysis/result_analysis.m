clear all;
close all;
clc
load('data.mat');
task = {'unconst', 'phantom','invivo'};

for i=1:3
    
    %for RMSE
    data_pick = [task{1,i} '_RMSE'];
    data = eval(data_pick);
    
    data_avg = mean(data);
    data_max = max(data,[],1);
    data_min = min(data,[],1);
    
    RMSE_AVG(i,:) = data_avg;
    RMSE_MAX(i,:) = data_max;
    RMSE_MIN(i,:) = data_min;
    RMSE_STD(i,:) = std(data,0,1);
    
    
    %for MAX
    data_pick = [task{1,i} '_MAX'];
    data = eval(data_pick);
    
    data_avg = mean(data,1);
    data_max = max(data,[],1);
    data_min = min(data,[],1);
    
    MAX_AVG(i,:) = data_avg;
    MAX_MAX(i,:) = data_max;
    MAX_MIN(i,:) = data_min;
    MAX_STD(i,:) = std(data,0,1);
    
end
%%
figure;
barData = RMSE_AVG';
err_max = (RMSE_MAX - RMSE_AVG)';
err_min = (RMSE_MIN - RMSE_AVG)';

h = bar(barData,1);
set(h(1),'FaceColor',1*ones(1,3));
set(h(2),'FaceColor',0.6*ones(1,3));
set(h(3),'FaceColor',0.3*ones(1,3));

hold on;

for i=1:3
    x = get(get(h(i),'children'),'xdata');
    xPos = (x(1,:)+x(3,:))/2;
    errorbar(xPos', barData(:,i),err_min (:,i),err_max(:,i),'xr', 'LineWidth',2,'Color' , 'k');
end
hold off;


set(gca, 'FontSize',15);
set(get(gca,'XLabel'),'FontSize',15);  set(get(gca,'YLabel'),'FontSize',15);
set(gca,'XTickLabel',{'X', 'Y', 'Z', '3D'})
ylabel('Error (\mum)');
set(gcf, 'Color', 'w');
legend('Unconst.','Phantom','In-vivo','Location','NorthWest');
set(gca,'YGrid','on');

%%
%with std
figure;
barData = RMSE_AVG';
err_max = (RMSE_STD - RMSE_AVG)';

h = bar(barData,1);
set(h(1),'FaceColor',1*ones(1,3));
set(h(2),'FaceColor',0.6*ones(1,3));
set(h(3),'FaceColor',0.3*ones(1,3));

hold on;

for i=1:3
    x = get(get(h(i),'children'),'xdata');
    xPos = (x(1,:)+x(3,:))/2;
    errorbar(xPos', barData(:,i),err_max(:,i),'xr', 'LineWidth',2,'Color' , 'k');
end
hold off;


set(gca, 'FontSize',15);
set(get(gca,'XLabel'),'FontSize',15);  set(get(gca,'YLabel'),'FontSize',15);
set(gca,'XTickLabel',{'X', 'Y', 'Z', '3D'})
ylabel('Error (\mum)');
set(gcf, 'Color', 'w');
legend('Unconst.','Phantom','In-vivo','Location','NorthWest');
set(gca,'YGrid','on');


%%
figure;
barData = MAX_AVG';
err_max = (MAX_MAX - MAX_AVG)';
err_min = (MAX_MIN - MAX_AVG)';

h = bar(barData,1);
set(h(1),'FaceColor',1*ones(1,3));
set(h(2),'FaceColor',0.6*ones(1,3));
set(h(3),'FaceColor',0.3*ones(1,3));

hold on;

for i=1:3
    x = get(get(h(i),'children'),'xdata');
    xPos = (x(1,:)+x(3,:))/2;
    errorbar(xPos', barData(:,i),err_min (:,i),err_max(:,i),'xr', 'LineWidth',2,'Color' , 'k');
end
hold off;


set(gca, 'FontSize',15);
set(get(gca,'XLabel'),'FontSize',15);  set(get(gca,'YLabel'),'FontSize',15);
set(gca,'XTickLabel',{'X', 'Y', 'Z', '3D'})
ylabel('Error (\mum)');
set(gcf, 'Color', 'w');
legend('Unconst.','Phantom','In-vivo','Location','NorthWest');
set(gca,'YGrid','on');

%%
%with std
figure;
barData = MAX_AVG';
err_max = (MAX_STD - MAX_AVG)';

h = bar(barData,1);
set(h(1),'FaceColor',1*ones(1,3));
set(h(2),'FaceColor',0.6*ones(1,3));
set(h(3),'FaceColor',0.3*ones(1,3));

hold on;

for i=1:3
    x = get(get(h(i),'children'),'xdata');
    xPos = (x(1,:)+x(3,:))/2;
    errorbar(xPos', barData(:,i),err_max(:,i),'xr', 'LineWidth',2,'Color' , 'k');
end
hold off;


set(gca, 'FontSize',15);
set(get(gca,'XLabel'),'FontSize',15);  set(get(gca,'YLabel'),'FontSize',15);
set(gca,'XTickLabel',{'X', 'Y', 'Z', '3D'})
ylabel('Error (\mum)');
set(gcf, 'Color', 'w');
legend('Unconst.','Phantom','In-vivo','Location','NorthWest');
set(gca,'YGrid','on');