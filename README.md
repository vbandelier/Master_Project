# Master Project in Financial Mathematics, EPFL
## Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

However there is a problem with a special case, called No Gain Knock-Out type, for the FD and GHQC methods. The problem seems to be in the interpolation of a discontinous function.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

Results :

      KO_Type      Target      MC         FD        GHQC       QUAD  
    ___________    ______    _______    _______    _______    _______

    'No Gain'      0.3       0.19561   (0.20435)  (0.20539)  (0.20483)
    'No Gain'      0.5       0.32874   (0.33737)  (0.33700)  (0.33642)
    'No Gain'      0.7       0.45053   (0.45957)  (0.45944)  (0.45937)
    'No Gain'      0.9       0.56282   (0.57295)  (0.57276)  (0.57167)
    'Part Gain'    0.3       0.24546    0.24437    0.24448    0.24434
    'Part Gain'    0.5       0.38126    0.38157    0.38173    0.38152
    'Part Gain'    0.7       0.50601    0.50580    0.50602    0.50575
    'Part Gain'    0.9       0.61843    0.61963    0.61989    0.61958
    'Full Gain'    0.3       0.29740    0.29742    0.29752    0.29731
    'Full Gain'    0.5       0.43987    0.43861    0.43824    0.43790
    'Full Gain'    0.7       0.56485    0.56429    0.56413    0.56406
    'Full Gain'    0.9       0.67954    0.67966    0.67933    0.67843
    
            CPU Time (sec) :   6.41       1.01       3.44       0.54         

Valentin Bandelier
