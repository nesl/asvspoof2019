function objective_function = make_objective_function_from_name(objective_name)

assert(nargin==1)
assert(isa(objective_name,'char'))

if strcmpi(objective_name,'cllr')
    objective_function = @(w,T,weights,logit_prior) cllr_obj(w,T,weights,logit_prior);
elseif strcmpi(objective_name,'brier')
    objective_function = @(w,T,weights,logit_prior) brier_obj(w,T,weights,logit_prior);
elseif strcmpi(objective_name,'boost')
    objective_function = @(w,T,weights,logit_prior) boost_obj(w,T,weights,logit_prior);
else
    error('name must be "cllr" or "brier" or "boost"')
end
