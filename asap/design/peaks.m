function [res] = peaks(dat, Fs, lo_thresh, hi_thresh, norm)
  res = zeros(0,2);
  res_ix = 1;
  tdata = abs(fft(dat .* kaiser(length(dat), 9)));
  delta_f = Fs/length(dat)
  f = 0;
  max_val = 0;
  max_f = 0;
  for i = 1:(length(dat)/2)
    if (tdata(i) > lo_thresh)
      if (tdata(i) > max_val)
        max_val = tdata(i);
	max_f = f;
      end
    else
      if (max_val > 0)
        if (max_val > hi_thresh)
	  res(res_ix,:) = [max_f, max_val/norm];
	  res_ix = res_ix + 1;
	end
        max_val = 0;
      end
    end
    f = f + delta_f;
  end


    
