% Read Micron trace data file.
%   name: file name to read.
%   dec_by: decimation factor (default 10)
%   nblocks: number of blocks to read (default whole file)
% results:
%   res: 3D data array, see trace_defs.m

function [res] = read_bin_trace(name, dec_by, nblocks)
trace_defs
if (nargin < 2 | isempty(dec_by))
  dec_by = 10;
end
if (nargin < 3 | isempty(nblocks))
  nblocks = inf;
end

[FILE, message] = fopen(name);
if (FILE == -1)
  fprintf(1, 'Read failed: %s\n', message);
  res = [];
  return;
end

header = fread(FILE, [3, 1], 'float32');
if (header(1) ~= micron_trace_data_magic)
  fprintf(1, 'Bad Micron trace data header magic: %f\n', header(1)); 
  res = [];
  return;
end

if (deciFloor(header(2),3) ~= deciFloor(micron_trace_data_version,3))
%%if (header(2) ~= micron_trace_data_version)
  fprintf(1, 'Warning:  trace data version mismatch: %f\n', header(2));
end

npoints = fix(header(3));

if (npoints ~= micron_trace_length)
  fprintf(1, ['Warning:  trace data length mismatch, using record size from' ...
	      'file: %f\n'], npoints);
end

%discard = fread(FILE, [npoints*3, 1], 'float32');
% trace npoints * XYZ
nread = npoints * 3;
rdata = fread(FILE, [nread, nblocks], 'float32');
rdata = rdata';
fclose(FILE);

rdata3 = reshape(rdata, [], 3, npoints);
flags = fix(rdata3(:,1,micron_status_flags));

if (dec_by > 1)
  res = zeros(ceil(size(rdata, 1)/dec_by), nread);
  for i = 1:nread
    res(:, i) = decimate(rdata(:, i), dec_by);
  end
else
  res = rdata;
end

res = reshape(res, [], 3, npoints);
end



