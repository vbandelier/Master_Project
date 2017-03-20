## Master Project in Financial Mathematics, EPFL
# Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

However there is a problem with a special case, called No Gain Knock-Out type, for the FD and GHQC methods. The problem seems to be in the interpolation of a discontinous function.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

First Results :

      KO_Type      Target      MC         FD        GHQC  
    ___________    ______    _______    _______    _______

    'No Gain'      0.3       0.19556   (0.22170)  (0.22150)
    'No Gain'      0.5       0.32871   (0.35624)  (0.35613)
    'No Gain'      0.7       0.45055   (0.47866)  (0.47861)
    'No Gain'      0.9       0.56334   (0.59079)  (0.59070)
    
    'Part Gain'    0.3       0.24458    0.24454    0.24450
    'Part Gain'    0.5       0.38174    0.38181    0.38176
    'Part Gain'    0.7       0.50569    0.50610    0.50604
    'Part Gain'    0.9       0.62015    0.61998    0.61990
    
    'Full Gain'    0.3       0.29753    0.29775    0.29739
    'Full Gain'    0.5       0.43863    0.43859    0.43845
    'Full Gain'    0.7       0.56440    0.56438    0.56453
    'Full Gain'    0.9       0.67921    0.67885    0.67874

Valentin Bandelier
