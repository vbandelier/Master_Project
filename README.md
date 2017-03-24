# Master Project in Financial Mathematics, EPFL
## Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

However there is a problem with a special case, called No Gain Knock-Out type, for the FD and GHQC methods. The problem seems to be in the interpolation of a discontinous function.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

First Results :

      KO_Type      Target      MC         FD        GHQC  
    ___________    ______    _______    _______    _______

    'No Gain'      0.3       0.19546   (0.20580)  (0.20546)
    'No Gain'      0.5       0.32862   (0.33747)  (0.33758)
    'No Gain'      0.7       0.45057   (0.45959)  (0.45968)
    'No Gain'      0.9       0.56305   (0.57236)  (0.57217)
    'Part Gain'    0.3       0.24452    0.24454    0.24450
    'Part Gain'    0.5       0.38167    0.38181    0.38175
    'Part Gain'    0.7       0.50592    0.50610    0.50604
    'Part Gain'    0.9       0.62001    0.61998    0.61990
    'Full Gain'    0.3       0.29775    0.29777    0.29747
    'Full Gain'    0.5       0.43868    0.43862    0.43854
    'Full Gain'    0.7       0.56458    0.56441    0.56445
    'Full Gain'    0.9       0.67894    0.67895    0.67868

Valentin Bandelier
