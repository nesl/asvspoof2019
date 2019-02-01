function qual = read_txt(infilename)
% Creates a Seg_Quality object from the contents of a text file.  
% Inputs:
%   infilename: The name of the text file to read.
% Outputs:
%   qual: A Seg_Quality object encoding the information in the input
%     text file.

assert(nargin==1)
assert(isa(infilename,'char'))

qual = Seg_Quality();

fid = fopen(infilename);
numvalues = fscanf(fid,'%d',1);
fstring = ['%s',repmat('%f',1,numvalues)];
lines = textscan(fid,fstring);
fclose(fid);

qual.ids = lines{1};
numids = length(qual.ids);
qual.values = zeros(numvalues,numids);

for ii=1:numvalues
    qual.values(ii,:) = lines{ii+1};
end

assert(qual.validate())

end
