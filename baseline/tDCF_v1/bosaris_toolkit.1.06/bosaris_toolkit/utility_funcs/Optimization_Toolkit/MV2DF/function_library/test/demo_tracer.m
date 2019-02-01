%Naive fanout 
%define function from w to x
w=[];
x = tracer(w,'w -> x','dx -> dw','dw -> dx');

%define function from x to s
y = tracer(x,'x -> y','dy -> dx','dx -> dy');  % this does function composition
z = tracer(x,'x -> z','dz -> dx','dx -> dz');  % this does another composition 
s = sum_of_functions(w,[1,1],y,z); % this does not do composition

fprintf('naive case: function value:\n');
[v,deriv] = s(1);

fprintf('naive case: gradient:\n');
[g,hess] = deriv(v);
fprintf('naive case: jacobian:\n');
hess(1);
fprintf('\n');


%Correct fanout
w=[];
x = tracer(w,'w -> x','dx -> dw','dw -> dx');

xx=[];
y = tracer(xx,'x -> y','dy -> dx','dx -> dy'); %no composition
z = tracer(xx,'x -> z','dz -> dx','dx -> dz'); %no composition
s = sum_of_functions(x,[1,1],y,z); %this does the composition once

fprintf('corrected: function value:\n');
[v,deriv] = s(1);

fprintf('corrected: gradient:\n');
[g,hess] = deriv(v);
fprintf('corrected: jacobian:\n');
hess(1);
fprintf('\n');
