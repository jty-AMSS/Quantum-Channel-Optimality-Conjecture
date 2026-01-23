#  Codes for "A Counterexample to the Optimality Conjecture in Convex Quantum Channel Optimization"

This repository contains codes with the paper: A Counterexample to the Optimality Conjecture in Convex Quantum Channel Optimization  [arXiv:2512.22863](https://arxiv.org/abs/2512.22863)

## Key Scripts
Two main scripts are provided:

1. **`CounterExample.py` - Optimality Verification**  
   Numerically solves the primal optimization problem to confirm the optimality of our solution $X$ (and corresponding channel $\Phi$) in the paper.
   
2. **`FoundCounter.jl` - Conjecture Refutation**  
   Find more numerical counterexamples by randomly generate different $\sigma$ and $X$.