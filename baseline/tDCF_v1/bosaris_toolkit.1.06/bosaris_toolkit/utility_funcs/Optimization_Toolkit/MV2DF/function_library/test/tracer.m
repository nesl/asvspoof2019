function [w,deriv] = tracer(w,vstring,gstring,jstring)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Applies linear transform y = map(w). It needs the transpose of map, 
% transmap for computing the gradient. map and transmap are function
% handles.

if nargin==0
    test_this();
    return;
end

if nargin<2
    vstring=[];
end

if nargin<3
    gstring=[];
end

if nargin<4
    jstring=[];
end

if isempty(w)
    w = @(x)tracer(x,vstring,gstring,jstring);
    return;
end

if isa(w,'function_handle')
    outer = tracer([],vstring,gstring,jstring);
    w = compose_mv(outer,w,[]);
    return;
end

if ~isempty(vstring)
    fprintf('%s\n',vstring);
end

deriv = @(g2) deriv_this(g2,gstring,jstring);

function [g,hess,linear] = deriv_this(g,gstring,jstring)
if ~isempty(gstring)
    fprintf('%s\n',gstring);
end
linear = true;
hess = @(d) hess_this(d,jstring);

function [h,Jd] = hess_this(Jd,jstring)
h = [];
if nargout>1
    if ~isempty(jstring)
        fprintf('%s\n',jstring);
    end
end

function test_this()
f = tracer([],'V','G','J');
test_MV2DF(f,randn(5,1));
