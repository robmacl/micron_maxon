%%..06/11/2013
clear all;
close all;
clc

phase = true;
[filename, pathname]=uigetfile({'*.xlsx';'*.dat';'*.*'},'EXCEL files(*.xlsx)');
file=[pathname filename];

%%
[type, sheets] = xlsfinfo(file);


%%
%..find active sheets
nSheets = size(sheets,2);
if(size(sheets,2)==1)
    sheets = {sheets};
end


nDel = 0;
for i=1:nSheets
    id = i - nDel;
    data = xlsread(file, sheets{id},'A1:A5');
    if(isempty(data))
        sheets(id) = [];
        nDel = nDel + 1;
    end
end
nSheets = nSheets-nDel;
%%

for s=1:nSheets
    [data, headertext] = xlsread(file, sheets{s});


    nAxis = 6;
    fitData = zeros(length(data),2,nAxis);
    ptData = zeros(length(data),2,nAxis);
    for i=1:nAxis
        selCol = i*2-1:i*2; 
        fitData(:,:,i) = data(:,selCol); %% curve data
        ptData(:,:,i) = data(:,selCol+nAxis*2); %% curve data
    end

    figure 
    hold on 
    col=hsv(nAxis); 
    lw = 2;
    sm =10;
    nDeci = 5;
    nOrder = 3;
    x=(linspace(-1,1,20))';
    fit_re = zeros(length(x),nAxis);

    for i=1:nAxis
        fit = fitData(:,:,i);
        pt = ptData(:,:,i);
        pt(any(isnan(pt),2),:)=[];
        pD = [];
        if(nDeci~=1)
            pD(:,1) = decimate(pt(:,1),nDeci);
            pD(:,2) = decimate(pt(:,2),nDeci);
        else
            pD = pt;
        end



        h(i)=plot(fit(:,1),fit(:,2),'Color',col(i,:), 'LineWidth',lw);
        scatter(pD(:,1),pD(:,2),sm,col(i,:),'o');

        iType{i}=sprintf('axis %d',i);

         %fit coefficients re-find
        idRemove = isnan(fit(:,1));
        fit(idRemove,:)=[];
        fitCoeff = polyfit(fit(:,1),fit(:,2),nOrder);


        y=fitCoeff(1)*x.^3+fitCoeff(2)*x.^2+fitCoeff(3)*x+fitCoeff(4);

        fit_re(:,i)=y';

    end


    legend(h,iType, 'Location','SouthEast');
    xlabel('Motor Command');
    ylabel('Velocity (mm/s)');

    grid on;
    axis([-1 1 -20 20]);
    hold off;
end


% avg_y=mean(fit_re,2);
% max_y=max(fit_re,[],2);
% min_y=min(fit_re,[],2);
% L = avg_y-min_y;
% U = max_y-avg_y;
% errorbar(x,avg_y,L,U,'r');


%%


