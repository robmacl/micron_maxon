function cumulPosError(data_out, data_in)

      
      theta = (atan2(data_in(:,2), data_in(:,1)))*180/pi;
      idx = find(theta<0);
      theta(idx) = 360+theta(idx);
      error = sqrt(sum((data_in(:,1:2)-data_out(:,1:2)).^2,2));
      
      step = 10;
      thBin = floor(theta/step);
      nBins = max(thBin(:))+1;
      bins = 0:step:(nBins-1)*step;
      binVal = zeros(1,nBins);
      for i=1:nBins
          val = (i-1);
          idx = thBin==val;
          binVal(i) = sum(error(idx));
      end
      figure; 
      bar(bins+step/2,binVal,1);
      xlim([0 360]);
      title('Cumulative Pos Error');
      
end