using JuMP
using GLPK
using LinearAlgebra
using Random
using Printf

attempts = 0
found = false
while !found
	attempts += 1
	
	# step1. Generate Random sigma (vector)
	sig = rand(4)
	sig = round.(sig ./ sum(sig), digits=2)
	sig[4] = 1.0 - sum(sig[1:3])
	if sig[4] < 0 || any(sig .< 0)
		continue
	end
	# step2. solving
	#    min || sigma - 0.5 * diag(X) ||_L1
	#    s.t. Tr_Y(diag(X)) = Id_Z, X >= 0
	
	model = Model(GLPK.Optimizer)
	set_silent(model) 
	
	@variable(model, x[1:4] >= 0)
	@variable(model, t[1:4] >= 0) 
	
	#  x[1]->|0z0y>, x[2]->|0z1y>, 3->|1z0y>, 4->|1z1y>
	@constraint(model, x[1] + x[2] == 1.0)
	@constraint(model, x[3] + x[4] == 1.0)
	
	# L1 opt: t >= |sig - 0.5*x|
	# eqv to t >= (sig - 0.5x) and t >= -(sig - 0.5x)
	@constraint(model, t .>= sig .- 0.5 .* x)
	@constraint(model, t .>= -(sig .- 0.5 .* x))
	
	@objective(model, Min, sum(t))
	optimize!(model)
	X_opt = value.(x)
	
	# step3.compute the H and Tr_Y(HX)

	# Delta = sigma - 0.5 * X
	Delta = sig .- 0.5 .* X_opt
	
	# Y = sign(Delta).
	Y = map(v -> abs(v) < 1e-10 ? 0.0 : sign(v), Delta)
	H = 0.5 .* Y
	
	# RHS = 1_Y \otimes Tr_Y(HX)
	HX = H .* X_opt
	tr_HX_Z = [HX[1] + HX[2], HX[3] + HX[4]]
	# Tensor with 1_Y:
	RHS = [tr_HX_Z[1], tr_HX_Z[1], tr_HX_Z[2], tr_HX_Z[2]]
	
	#step4. Check if it is a counter example
	h_ge_rhs = all(H .>= RHS .- 1e-2)
	rhs_ge_h = all(RHS .>= H .- 1e-2)
	if !h_ge_rhs && !rhs_ge_h
		found = true
		println("find a counter example:")            
		println("Sigma:")
		println(sig)
		
		println("Optimal X :")
		println(X_opt)
		
		println("Delta:")
		println(round.(Delta, digits=4))
		
		println("Y = sign(Delta):")
		println(Y)
		
		println("H=")
		println(H)
		
		println("\n 1_Y ⊗ Tr_Y(HX)=")
		println(round.(RHS, digits=4))
					

		diff = H .- RHS
		println("H - RHS= ",diff)
	end
	if attempts > 100000
		println("Too much tests.")
		break
	end
end




