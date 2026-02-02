using JuMP
using HiGHS
using LinearAlgebra

# Step1. Setup Parameters
# Diagonal elements of corresponding to basis order: |00>, |01>, |10>, |11>
sigma_vec = [0.55, 0.20, 0.15, 0.10]

X_In_paper = [1.00, 0.40, 0.00, 0.60]

# Step2. Compute Objective Value for paper's Solution
# Objective: || σ - 0.5 * X ||_1 (L1 norm)
obj_in_paper = sum(abs.(sigma_vec .- 0.5 .* X_In_paper))
println("Solution Objective in paper: ", obj_in_paper )


# Step3. Solve L1 Minimization Problem via LP
model = Model(HiGHS.Optimizer)
set_silent(model)

# Constraint:X>=0
@variable(model, x[1:4] >= 0)

# Constraint: Tr_Y(X) = 1_Z
@constraint(model, x[1] + x[3] == 1.0)
@constraint(model, x[2] + x[4] == 1.0)

# Auxiliary variables for L1 norm: t_i >= |σ_i - 0.5*x_i|
@variable(model, t[1:4] >= 0)
@constraint(model, [i=1:4], t[i] >= sigma_vec[i] - 0.5 * x[i])
@constraint(model, [i=1:4], t[i] >= -(sigma_vec[i] - 0.5 * x[i]))
@objective(model, Min, sum(t))

optimize!(model)

# Step4. Show Results
obj_optimal = objective_value(model)
X_optimal = value.(x)

println("Optimal Objective Found:   ", obj_optimal)
println("Optimal X Solution:        ", X_optimal)

# Verification tolerance
if isapprox(obj_in_paper, obj_optimal, atol=1e-6)
    println("\n The solution X in paper is globally optimal.")
else
    println("\n The solution in paper is NOT optimal.")
end
