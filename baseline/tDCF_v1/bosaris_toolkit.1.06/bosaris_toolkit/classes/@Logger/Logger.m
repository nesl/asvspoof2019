classdef Logger < handle
% A class that writes messages to log files (and/or standard out).
% To use the class, put the following two lines in your script:
%   global logger
%   logger = Logger();
% and then add and remove logfiles as required e.g.
%   logger.add_stdout(logger.All);
%   logger.add_filename('errorfile.txt',logger.Error);
%   logger.log(logger.All,'1 + 2 = %d\n',3);
%   logger.log(logger.Error,'An error occurred.\n');
%   logger.rm_filename('errorfile.txt');
%   fid = fopen('warningfile.txt','w');
%   logger.add_fid(fid);
%   logger.log(logger.Warning,'This is a warning.\n');
%   logger.clear()
%   fclose(fid);

properties (Access=private)
  fidlist = []
  fidlevels = [];
  filenamelist = {}
  filenamefids = []
  filenamelevels = []
end

properties (Access=public,Constant=true)
  None = 0
  Major_Error = 1
  Error = 2
  Warning = 4
  Minor_Warning = 8  
  Info = 16
  Minor_Info = 32
  Debug_1 = 64
  Debug_2 = 128
  All = 255;
end

methods (Access=public)
  log(logger,level,message,varargin)
  add_fid(logger,fid,level)
  rm_fid(logger,fid)
  clear(logger)
  add_filename(logger,fname,level)
  rm_filename(logger,fname)
  add_stdout(logger,level)
  rm_stdout(logger)
  add_stderr(logger,level)
  rm_stderr(logger)
end

end
