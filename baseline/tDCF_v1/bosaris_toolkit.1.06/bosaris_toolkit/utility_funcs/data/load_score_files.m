function score_obj_array = load_score_files(scorefilenamelist)
% Loads the scores for all the systems in the list into an array of
% Scores objects.
% Inputs
%   scorefilenamelist: A cell array of file name strings, one for
%     each system.
% Outputs:
%   score_obj_array: An array of score objects, with the same
%     number of elements as scorefilenamelist.

assert(iscell(scorefilenamelist))

numsystems = length(scorefilenamelist);

score_obj_array = Scores.empty(numsystems,0);
log_info('subsystems:\n');
for ii=1:numsystems
    log_info('%i: %s\n',ii,scorefilenamelist{ii});
    score_obj_array(ii) = Scores.read(scorefilenamelist{ii});
end
                     
end
