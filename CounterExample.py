import qutip as qt
import numpy as np


#Step1: Define Space Z with |k>_Z
ket0_Z = qt.basis(2, 0)  # |0>_Z
ket1_Z = qt.basis(2, 1)  # |1>_Z
# and <i|_Z 
bra0_Z = ket0_Z.dag()
bra1_Z = ket1_Z.dag()

#Step2: Define Space Y with |k>_Y and <i|_Y
ket0_Y = qt.basis(2, 0)  # |0>_Y
ket1_Y = qt.basis(2, 1)  #|1>_Y
bra0_Y = ket0_Y.dag()
bra1_Y = ket1_Y.dag()


#Step3:  Define sigma
ket_0Z_0Y = qt.tensor(ket0_Z, ket0_Y)  
bra_0Z_0Y = ket_0Z_0Y.dag()            
term1 = 0.55 * ket_0Z_0Y * bra_0Z_0Y

# 0.2 × |1>_Z|0>_Y ⟨1|_Z⟨0|_Y
ket_1Z_0Y = qt.tensor(ket1_Z, ket0_Y)
bra_1Z_0Y = ket_1Z_0Y.dag()
term2 = 0.2 * ket_1Z_0Y * bra_1Z_0Y

# 0.15 × |0>_Z|1>_Y ⟨0|_Z⟨1|_Y
ket_0Z_1Y = qt.tensor(ket0_Z, ket1_Y)
bra_0Z_1Y = ket_0Z_1Y.dag()
term3 = 0.15 * ket_0Z_1Y * bra_0Z_1Y

# 0.1 × |1>_Z|1>_Y ⟨1|_Z⟨1|_Y
ket_1Z_1Y = qt.tensor(ket1_Z, ket1_Y)
bra_1Z_1Y = ket_1Z_1Y.dag()
term4 = 0.1 * ket_1Z_1Y * bra_1Z_1Y
sigma = term1 + term2 + term3 + term4

#Step4: Define X
term1X = 1.00 * ket_0Z_0Y * bra_0Z_0Y

#0.4 × |1>_Z|0>_Y ⟨1|_Z⟨0|_Y
term2X = 0.4 * ket_1Z_0Y * bra_1Z_0Y

# 0.15 × |0>_Z|1>_Y ⟨0|_Z⟨1|_Y
term3X = 0.0 * ket_0Z_1Y * bra_0Z_1Y

# 项4：0.6 × |1>_Z|1>_Y ⟨1|_Z⟨1|_Y
term4X = 0.6 * ket_1Z_1Y * bra_1Z_1Y

X = term1X + term2X + term3X + term4X

delta=sigma-1/2*X


## Step5: spectral  calculus
eigenvalues, eigenkets = delta.eigenstates()


projectors = []
for ket in eigenkets:
    P_n = ket * ket.dag()  
    projectors.append(P_n)
    

# 2. delta： spectral decomposition：
delta_spectral = 0  
for n in range(len(eigenvalues)):
    delta_spectral += eigenvalues[n] * projectors[n]

Y=0
for n in range(len(eigenvalues)):
    Y += np.sign(eigenvalues[n]) * projectors[n]
  

H=1/2*Y

HX_Z = qt.ptrace(H*X, 0)  
Id_Y = qt.qeye(2)

HX_tensor_IdY = qt.tensor(HX_Z, Id_Y)

F=H-HX_tensor_IdY

ket_1Z_0Y * bra_1Z_0Y

ket_1Z_1Y * bra_1Z_1Y
print('LHS-RHS=')
print(F)
