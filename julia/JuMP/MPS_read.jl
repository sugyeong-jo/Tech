println("================Package Read=================")
using ProgressBars
using MathOptInterface
using JuMP, Cbc
const MOI = MathOptInterface
using SparseArrays

##########################
filepath = "/HDD/Workspace/CLT/mps/processing/CPLEX_file/4_R170725003_veri_cplex.mps"
m =read_from_file(filepath)
optimizer=optimizer_with_attributes(Cbc.Optimizer,  "maxSolutions" => 1, "logLevel "=>1, "seconds" => 300,"allowableGap "=>70)
set_optimizer(m, optimizer)

# constraint
list_of_constraint_types(m)
con = Dict()
con_rhs = Dict()
idx_con = Dict()
con_idx = Dict()

constraint = all_constraints(m, GenericAffExpr{Float64,VariableRef}, MathOptInterface.EqualTo{Float64})
for i in tqdm(1:length(constraint))
    con_name = name(constraint[i])
    con_rhs[con_name] = constraint_object(constraint[i]).set.value
    con[con_name]= :Equal
    idx_con[constraint[i].index.value] = con_name
    con_idx[con_name] = constraint[i].index.value
end
constraint = all_constraints(m, GenericAffExpr{Float64,VariableRef}, MathOptInterface.GreaterThan{Float64})
for i in tqdm(1:length(constraint))
    con_name = name(constraint[i])
    con_rhs[con_name] = constraint_object(constraint[i]).set.lower
    con[con_name]= :Greater
    idx_con[constraint[i].index.value] = con_name
    con_idx[con_name] = constraint[i].index.value
end
constraint = all_constraints(m, GenericAffExpr{Float64,VariableRef}, MathOptInterface.LessThan{Float64})
for i in tqdm(1:length(constraint))
    con_name = name(constraint[i])
    con_rhs[con_name] = constraint_object(constraint[i]).set.upper
    con[con_name]= :Less
    idx_con[constraint[i].index.value] = con_name
    con_idx[con_name] = constraint[i].index.value
end


# variable
var = Dict()
var_idx = Dict()
idx_var = Dict()
var_lb = Dict()
var_ub = Dict()
var_ref = Dict()
for var_name in tqdm(all_variables(m))
    var[var_name] = :Con
    var_idx[var_name] = var_name.index.value
    idx_var[var_name.index.value] = var_name
    var_lb[var_name] = -Inf
    var_ub[var_name] = Inf
    var_ref[var_name] = :except
end

variable = all_constraints(m, VariableRef, MathOptInterface.Interval{Float64})
for i in tqdm(1:length(variable))
    var_name = constraint_object(variable[i]).func
    var_lb[var_name] = constraint_object(variable[i]).set.lower
    var_ub[var_name] = constraint_object(variable[i]).set.upper
    var_ref[var_name] = :Interval
end

variable = all_constraints(m, VariableRef, MathOptInterface.GreaterThan{Float64})
for i in tqdm(1:length(variable))
    var_name = constraint_object(variable[i]).func
    var_lb[var_name] = constraint_object(variable[i]).set.lower
    var_ref[var_name] = :Greater
end
variable = all_constraints(m, VariableRef, MathOptInterface.LessThan{Float64})
for i in tqdm(1:length(variable))
    var_name = constraint_object(variable[i]).func
    var_ub[var_name] = constraint_object(variable[i]).set.upper
    var_ref[var_name] = :Less
end



variable = all_constraints(m, VariableRef, MathOptInterface.Integer)
for i in tqdm(1:length(variable))
    var_name = constraint_object(variable[i]).func
    var[var_name] = :Int
end

variable = all_constraints(m, VariableRef, MathOptInterface.ZeroOne)
for i in tqdm(1:length(variable))
    var_name = constraint_object(variable[i]).func
    var[var_name] = :Bin
    var_lb[var_name] = 0
    var_ub[var_name] = 1
end


# Sparse matrix
I = Int[]
J = Int[]
V = Float64[]
u = Dict()
l = Dict()


con_set = [k for (k,v) in con if v==:Less]
for i in tqdm(con_set)
    con_term =collect(linear_terms(constraint_object(constraint_by_name(m, i )).func))
    u[con_idx[i]] = con_rhs[i]
    l[con_idx[i]] = -Inf
    for j in 1:length(con_term)
        push!(I, con_idx[i])
        push!(J, var_idx[con_term[j][2]])
        push!(V, con_term[j][1])
    end
end

con_set = [k for (k,v) in con if v==:Greater]
for i in tqdm(con_set)
    u[con_idx[i]] = -(con_rhs[i])
    l[con_idx[i]] = -Inf
    con_term =collect(linear_terms(constraint_object(constraint_by_name(m, i )).func))
    for j in 1:length(con_term)
        push!(I, con_idx[i])
        push!(J, var_idx[con_term[j][2]])
        push!(V, -(con_term[j][1]))
    end
end
con_set = [k for (k,v) in con if v==:Equal]
for i in tqdm(con_set)
    u[con_idx[i]] = con_rhs[i]
    l[con_idx[i]] = con_rhs[i]
    con_term =collect(linear_terms(constraint_object(constraint_by_name(m, i )).func))
    for j in 1:length(con_term)
        push!(I, con_idx[i])
        push!(J, var_idx[con_term[j][2]])
        push!(V, con_term[j][1])
    end
end

A = sparse(I,J,V)

#######################################################################
#  Final result
#######################################################################

con # constraint with 
con_rhs 
idx_con 
con_idx 

var # variable with type
var_idx 
idx_var 
var_lb 
var_ub 
var_ref 

A # sparse matrix for constraint (standard form)
u # constraint upper bound
l # constraint upper bound


