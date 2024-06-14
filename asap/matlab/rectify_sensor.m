% Use lookup table to linearize sensor.  The table S is four square 2D lookup
% tables spanning the entire sensor range.  The value in each table is the
% correction to add to a measurement at that position.  The u and v error
% components have separate tables.  Indexing is (u, v, u_or_v, sensor)
%
function [res] = rectify_sensor(measured, S)
if (isempty(S))
  res = measured;
else
  % Interpolation chokes on NaN's.  We can get these if the light goes out
  % of the field of view, or is off.  If there are any, we smash them to
  % zero and then restore them after interpolation.
  nans = isnan(measured);
  measured(nans) = 0;
  res = zeros(size(measured));
  nbins = size(S, 1);
  XY = linspace(-nominal_scale, nominal_scale, nbins);
  for (s_ix = 1:2)
    col = (s_ix - 1)*2 + 1;
    for (light_ix = 1:size(measured, 3))
      for (uv_ix = 1:2)
	uv = measured(:, col:(col+1), light_ix);
	ZI = interp2(XY, XY, S(:, :, uv_ix, s_ix), uv(:, 1), uv(:, 2));
	res(:, col + uv_ix - 1, light_ix) = uv(:, uv_ix) - ZI;
      end
    end
  end
  res(nans) = nan;
end
