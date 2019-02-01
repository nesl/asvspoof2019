function S = sprintfmatrix(X,rowid)
% Formats a matrix for printing by converting to a string and
% adding row labels and newlines. 
% Inputs:
%   X: The input matrix (of numbers).
%   rowid: Row labels.  Can be numeric, cell array or char array. 
% Outputs:
%   S: The matrix converted to a string with formatting added.

[m,n] = size(X);
nnn = sprintf(repmat('\n',1,m))';

if exist('rowid','var')
    if isnumeric(rowid)
	rowid = num2str(rowid(:));
    elseif iscell(rowid)
	rowid = char(rowid);
    end
    S = sprintf('%s',[rowid,repmat(': ',m,1),num2str(X),nnn]');
else
    S = sprintf('%s',[num2str(X),nnn]');
end
