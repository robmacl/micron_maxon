% The realtime network IP for the Micron target, in this case serial # 1.
rhost = '192.168.1.101';

% The IP for this machine's RT network interface
this_host = '192.168.1.66';

status_port = 61557;
command_port = 61558;

trace_defs;

% Trace record is basically organized as triples of floats, with an extra
% triple for the header.  And there are two int32's at the end, the trace
% index and sequence number.
status_bytes = (micron_trace_length + 1) * 3 * 4 + 2*4;

global status_udp;

% A Matlab "instrument" is persistent, so to avoid creating lots of them,
% we look to see if it exists already.
status_udp = instrfind('Name', 'micron_status');

%{
% This will force deletion and reconstruction of the instrument object,
% useful if you have changed settings.
delete(status_udp);
clear status_udp;
status_udp = [];
%}

if (isempty(status_udp))
  status_udp = udp(rhost, status_port, ...
                   'Name', 'micron_status', ...
                   'LocalHost', this_host, ...
                   'LocalPortMode', 'manual', ...
                   'LocalPort', status_port, ...
                   'Timeout', 1, ...
                   'InputBufferSize', status_bytes);
end

fclose(status_udp);
fopen(status_udp);
