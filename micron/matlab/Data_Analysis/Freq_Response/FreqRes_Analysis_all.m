clear all;
close all;
clc

[filename, pathname]=uigetfile({'*.xlsx';'*.dat';'*.*'},'EXCEL files(*.xlsx)');
file=[pathname filename];

endSheet = false;
[type, sheets] = xlsfinfo(file);

nData = size(sheets,2);

figure;
hold on;
nData = 6;

%%

dataAll = cell(1,nData);
lNames = cell(1,nData);

for i=1:nData
    figure(i);
    hold on;

    [data, headertext] = xlsread(file, sheets{i});
    nTrial = floor(size(data,2)/2);
    sFreq = data(:,1);
    
    dataAll{i} = zeros(length(sFreq),2);
    subAll = zeros(length(sFreq),nTrial);
    
    valTrial = 0;
    for j=1:nTrial
        sData = data(:,j*2);
        sData(isnan(sData))=[];
        if(length(sData) == length(sFreq))
            valTrial = valTrial + 1;
            subAll(:,valTrial) = sData;
            plot(gca, sFreq,sData);
        end
    end
    
    dataAll{i}(:,1) = sFreq;
    dataAll{i}(:,2) = mean(subAll,2);
    
    
    lNames{i} = strrep(sheets{i}, '_', ' ');
    
    title(lNames{i});
    hold off;
    set(gca,'Xscale','log');
    %axis([min(sFreq) max(sFreq) -20 10]);
    
    
   
end


%%
figure;
hold on;
cols = hsv(nData);
wLine = 2;

for i=1:nData
     plot(dataAll{i}(:,1),  dataAll{i}(:,2), 'Color',cols(i,:), 'LineWidth',wLine);
end
hold off;
legend(lNames, 'Location', 'SouthWest');
set(gca,'Xscale','log');
axis([1e1 1e2 -40 10]);
set(gca,'YGrid', 'on');

%%
%%..smoothing..

sm =10;

figure;
hold on;
cols = hsv(nData);
wLine = 2;

for i=1:nData
    %interpolate
    xi = 10:2:100;
    pp = interp1(dataAll{i}(:,1),dataAll{i}(:,2),'cubic','pp');
    yi = ppval(pp,xi);
    ys = smooth(xi,yi,'lowess');
    
    hi(i) = plot(xi, ys, 'Color',cols(i,:), 'LineWidth',wLine);

    scatter(dataAll{i}(:,1),dataAll{i}(:,2),sm, cols(i,:),'o');
        
    %plot(sFreq,  magDataAll(:,i), 'Color',cols(i,:), 'LineWidth',wLine);
end
hold off;
legend(hi,lNames, 'Location', 'SouthWest');
set(gca,'Xscale','log');
axis([1e0 1e2 -40 10]);
set(gca,'YGrid', 'on');



% %%
% figure;
% hold on;
% 
% x = sFreq;
% y = sDataAll(:,4);
% 
% plot(x, y, 'bo-'); 
% 
% %smoothing..
% fnplt(csaps(x,y,0.1),2,'k--');
% yy1 = smooth(x,y,'lowess'); plot(x, yy1, 'g');
% 
% 
% %interpolate 'cubic'
% xi = 10:2:100;
% pp = interp1(x,y,'cubic','pp');
% yi = ppval(pp,xi);
% 
% fnplt(csaps(xi,yi,0.1),2,'r--');
% yy4 = smooth(xi,yi,'lowess'); plot(xi, yy4, 'c');
% set(gca,'Xscale','log');




