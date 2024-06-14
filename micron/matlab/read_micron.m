function [data] = read_micron ()
% Read the most recent status packet from micron.  Result is a Nx3 array,
% where the rows are probe points, see trace_defs.m.  See open_micron() to
% open the UDP connection.
  global status_udp
  % It always reads the whole datagram, but we have to give something for
  % the length.
  pdata = fread(status_udp, 1, 'float32');
  % Strip off header (3 floats) and trailer (2 ints).
  data = pdata(4:end-2);
  % Make into 2D array, where rows are probe points.
  data = reshape(data, 3, [])';
end
