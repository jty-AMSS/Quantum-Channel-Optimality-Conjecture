#  Codes for "A Counterexample to the Optimality Conjecture in Convex Quantum Channel Optimization"

This repository contains codes for the paper: A Counterexample to the Optimality Conjecture in Convex Quantum Channel Optimization  [arXiv:2512.22863](https://arxiv.org/abs/2512.22863)

## Key Scripts
Two main scripts are provided:

1. **`CounterExample.py` and `VerifyOpt.jl` - Optimality Verification**  
   Numerically solves the primal optimization problem to confirm the optimality of our solution $X$ (and corresponding channel $\Phi$) in the paper.
   
2. **`FoundCounter.jl` -  Counterexample Generation**  

   Find more numerical counterexamples by randomly generate different $\sigma$ and $X$.


## Prerequisites

### Julia
To run the search script, you need [Julia](https://julialang.org/) and the following packages:
```julia
using JuMP, GLPK, LinearAlgebra, HiGHS
```

### Python
To run the verification script, you need Python 3 and the [QuTiP](https://qutip.org/) library:
```bash
pip install qutip numpy
```

## Usage

### 1. Search for a Counterexample
Execute the Julia script to find a new random counterexample:
```bash
julia FoundCounter.jl
```

### 2. Verify the Result
The Python script is pre-loaded with the specific values used in the paper (Theorem 4.1). Run it to see the violation of the optimality condition:
```bash
python CounterExample.py
```
