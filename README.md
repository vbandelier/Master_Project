# Master Project in Financial Mathematics, EPFL
## Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

However there is a problem with a special case, called No Gain Knock-Out type, for the FD and GHQC methods. The problem seems to be in the interpolation of a discontinous function.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

First Results :

      KO_Type      Target      MC         FD        GHQC  
    ___________    ______    _______    _______    _______

    'No Gain'      0.3       0.19546   (0.20580)  (0.20564)
    'No Gain'      0.5       0.32862   (0.33747)  (0.33760)
    'No Gain'      0.7       0.45057   (0.45959)  (0.45965)
    'No Gain'      0.9       0.56305   (0.57236)  (0.57218)
    'Part Gain'    0.3       0.24452    0.24454    0.24450
    'Part Gain'    0.5       0.38167    0.38181    0.38175
    'Part Gain'    0.7       0.50592    0.50610    0.50604
    'Part Gain'    0.9       0.62001    0.61998    0.61990
    'Full Gain'    0.3       0.29775    0.29777    0.29760
    'Full Gain'    0.5       0.43868    0.43862    0.43856
    'Full Gain'    0.7       0.56458    0.56441    0.56443
    'Full Gain'    0.9       0.67894    0.67895    0.67869
    
Fast :

      KO_Type      Target      MC         FD        GHQC  
    ___________    ______    _______    _______    _______

    'No Gain'      0.3       0.19561   (0.20435)  (0.20539)
    'No Gain'      0.5       0.32847   (0.33737)  (0.33700)
    'No Gain'      0.7       0.45053   (0.45957)  (0.45944)
    'No Gain'      0.9       0.56496   (0.57295)  (0.57276)
    'Part Gain'    0.3       0.24464    0.24437    0.24448
    'Part Gain'    0.5       0.38320    0.38157    0.38173
    'Part Gain'    0.7       0.50495    0.50580    0.50602
    'Part Gain'    0.9       0.62037    0.61963    0.61989
    'Full Gain'    0.3       0.29772    0.29742    0.29752
    'Full Gain'    0.5       0.43785    0.43861    0.43824
    'Full Gain'    0.7       0.56485    0.56429    0.56413
    'Full Gain'    0.9       0.67954    0.67966    0.67933

Valentin Bandelier
