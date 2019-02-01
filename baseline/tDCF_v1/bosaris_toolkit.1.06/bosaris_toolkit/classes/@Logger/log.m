function log(logger,level,message,varargin)
% Writes a message to all log files (and possibly standard out and
% standard error).
% Inputs:
%   level: The logging level.  See the constants defined in the
%     class header.  Several constants can be combined by bit oring
%     them. 

assert(logger.validate())

for ii=1:length(logger.fidlist)
    if bitand(logger.fidlevels(ii),level)
	fprintf(logger.fidlist(ii),message,varargin{:});
    end
end
for ii=1:length(logger.filenamefids)
    if bitand(logger.filenamelevels(ii),level)
	fprintf(logger.filenamefids(ii),message,varargin{:});
    end
end    
end
