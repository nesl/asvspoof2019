function aligned_scr = align_with_ndx(scr,ndx)
% The ordering in the output Scores object corresponds to ndx, so
% aligning several Scores objects with the same ndx will result in
% them being comparable with each other.
% Inputs:
%   scr: a Scores object
%   ndx: a Key or Ndx object
% Outputs:
%   aligned_scr: scr resized to size of 'ndx' and reordered
%     according to the ordering of modelset and segset in 'ndx'.

if nargin==1
    test_this();
    return
end

assert(nargin==2)
assert(isa(scr,'Scores'))
assert(isa(ndx,'Key')||isa(ndx,'Ndx'))
assert(scr.validate())
assert(ndx.validate())

aligned_scr = Scores();

aligned_scr.modelset = ndx.modelset;
aligned_scr.segset = ndx.segset;
m = length(ndx.modelset);
n = length(ndx.segset);


[hasmodel,rindx] = ismember(ndx.modelset,scr.modelset);
rindx = rindx(hasmodel);
[hasseg,cindx] = ismember(ndx.segset,scr.segset);
cindx = cindx(hasseg);

aligned_scr.scoremat = zeros(m,n);
aligned_scr.scoremat(hasmodel,hasseg) = double(scr.scoremat(rindx,cindx));  

aligned_scr.scoremask = false(m,n);
aligned_scr.scoremask(hasmodel,hasseg) = scr.scoremask(rindx,cindx);

assert(sum(aligned_scr.scoremask(:)) <= sum(hasmodel)*sum(hasseg));

if isa(ndx,'Ndx')
    aligned_scr.scoremask = aligned_scr.scoremask & ndx.trialmask;
else
    aligned_scr.scoremask = aligned_scr.scoremask & (ndx.tar | ndx.non);
end

if sum(hasmodel)<m
    log_warning('models reduced from %i to %i\n',m,sum(hasmodel));
end
if sum(hasseg)<n
    log_warning('testsegs reduced from %i to %i\n',n,sum(hasseg));
end

if isa(ndx,'Key') %supervised
    tar = ndx.tar & aligned_scr.scoremask;
    non = ndx.non & aligned_scr.scoremask;
    
    missing = sum(ndx.tar(:)) - sum(tar(:));
    if missing > 0
	log_warning('%i of %i targets missing.\n',missing,sum(ndx.tar(:)));
    end
    missing = sum(ndx.non(:)) - sum(non(:));
    if missing > 0
	log_warning('%i of %i non-targets missing.\n',missing,sum(ndx.non(:)));
    end
else
    mask = ndx.trialmask & aligned_scr.scoremask;
    
    missing = sum(ndx.trialmask(:)) - sum(mask(:));
    if missing > 0
	log_warning('%i of %i trials missing\n',missing,sum(ndx.trialmask(:)));
    end

end

assert(all(isfinite(aligned_scr.scoremat(aligned_scr.scoremask(:)))))

assert(aligned_scr.validate())

end

function test_this()

key = Key();
key.modelset = {'1','2','3'};
key.segset = {'a','b','c'};
key.tar = logical(eye(3));
key.non = ~key.tar;

scr = Scores();
scr.scoremat = [1 2 3; 4 5 6; 7 8 9];
scr.scoremask = true(3);
scr.modelset = {'3','2','1'};
scr.segset = {'c','b','a'};

scores = scr.scoremat,
scr = scr.align_with_ndx(key);
scores = scr.scoremat,
end
