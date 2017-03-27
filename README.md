# Master Project in Financial Mathematics, EPFL
## Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

However there is a problem with a special case, called No Gain Knock-Out type, for the FD and GHQC methods. The problem seems to be in the interpolation of a discontinous function.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

Results under BS model: (MC = 2e5 simulations ; FD = 500 x 500 x 100 grid ; GHQC, QUAD = 500 x 100 grid)

      KO_Type      Target      MC         FD        GHQC       QUAD  
    ___________    ______    _______    _______    _______    _______
    'No Gain'      0.3       0.19553    0.20580    0.20564    0.20568
    'No Gain'      0.5       0.32856    0.33747    0.33760    0.33735
    'No Gain'      0.7       0.45098    0.45959    0.45965    0.45961
    'No Gain'      0.9       0.56267    0.57236    0.57218    0.57221
    
    'Part Gain'    0.3       0.24473    0.24454    0.24450    0.24453
    'Part Gain'    0.5       0.38194    0.38181    0.38176    0.38179
    'Part Gain'    0.7       0.50609    0.50610    0.50604    0.50607
    'Part Gain'    0.9       0.62088    0.61998    0.61990    0.61994
    
    'Full Gain'    0.3       0.29801    0.29777    0.29760    0.29765
    'Full Gain'    0.5       0.43822    0.43862    0.43856    0.43843
    'Full Gain'    0.7       0.56411    0.56441    0.56443    0.56438
    'Full Gain'    0.9       0.67758    0.67895    0.67869    0.67876
    -----------------------------------------------------------------
            CPU Time (sec) :  12.42       4.31      15.52       1.42    
          
Results under BS model: (MC = 1e6 simulations ; FD = 1000 x 1000 x 200 grid ; GHQC, QUAD = 1000 x 200 grid)

Valentin Bandelier
