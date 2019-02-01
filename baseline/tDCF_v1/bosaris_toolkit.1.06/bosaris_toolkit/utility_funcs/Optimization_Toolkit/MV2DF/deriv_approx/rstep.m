function J = rstep(f,args,argno,argrow,outno);

if nargin<4
    argrow=1;
end
if nargin<5
    outno=1;
end
str = cell(1,outno);
if strcmp(class(f),'function_handle')
    [str{:}] = f(args{:});
else
    [str{:}] = feval(f,args{:});
end

y0 = str{end};
x0 = args{argno};
dx = sqrt(eps);
n = size(x0,2);
J = zeros(length(y0),n);
for i=1:n;
    x = x0;
    x(argrow,i) = x0(argrow,i) + dx;
    args{argno} = x;
    if strcmp(class(f),'function_handle')
        [str{:}] = f(args{:});
    else
        [str{:}] = feval(f,args{:});
    end
    y1 = str{end};
    J(:,i) = (y1-y0)/dx;
end
