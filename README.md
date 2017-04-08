# Master Project in Financial Mathematics, EPFL
## Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

## Results
Results under BS model: 

(MC = 2e5 simulations ; FD = 500 x 500 x 100; GHQC = 500 x 100; QUAD,CONV = 1024 x 100)

      KO_Type      Target      MC         FD        GHQC       QUAD       CONV  
    ___________    ______    _______    _______    _______    _______    _______

    'No Gain'      0.3       0.19553    0.19549    0.19520    0.19537    0.19539
    'No Gain'      0.5       0.32856    0.32866    0.32858    0.32865    0.32866
    'No Gain'      0.7       0.45098    0.45058    0.45062    0.45054    0.45052
    'No Gain'      0.9       0.56267    0.56334    0.56306    0.56312    0.56319
    
    'Part Gain'    0.3       0.24473    0.24454    0.24450    0.24454    0.24454
    'Part Gain'    0.5       0.38194    0.38181    0.38175    0.38180    0.38180
    'Part Gain'    0.7       0.50609    0.50610    0.50604    0.50609    0.50609
    'Part Gain'    0.9       0.62088    0.61998    0.61990    0.61997    0.61997
    
    'Full Gain'    0.3       0.29801    0.29777    0.29747    0.29765    0.29767
    'Full Gain'    0.5       0.43822    0.43862    0.43854    0.43861    0.43862
    'Full Gain'    0.7       0.56411    0.56441    0.56445    0.56437    0.56436
    'Full Gain'    0.9       0.67758    0.67895    0.67868    0.67873    0.67881
    ----------------------------------------------------------------------------
            CPU Time (sec) :  12.13       3.90      14.26       3.10       2.78
          
Results under BS model: 

(MC = 1e6 simulations ; FD = 1000 x 1000 x 200; GHQC = 1000 x 200; QUAD,CONV = 4096 x 200)

      KO_Type      Target      MC         FD        GHQC       QUAD       CONV  
    ___________    ______    _______    _______    _______    _______    _______

    'No Gain'      0.3       0.19556    0.19543    0.19531    0.19544    0.19544
    'No Gain'      0.5       0.32866    0.32866    0.32866    0.32865    0.32865
    'No Gain'      0.7       0.45018    0.45054    0.45070    0.45058    0.45059
    'No Gain'      0.9       0.56325    0.56334    0.56333    0.56332    0.56332
    
    'Part Gain'    0.3       0.24450    0.24453    0.24452    0.24454    0.24454
    'Part Gain'    0.5       0.38177    0.38179    0.38178    0.38180    0.38180
    'Part Gain'    0.7       0.50614    0.50608    0.50606    0.50609    0.50609
    'Part Gain'    0.9       0.61945    0.61995    0.61993    0.61996    0.61997
    
    'Full Gain'    0.3       0.29772    0.29771    0.29760    0.29772    0.29773
    'Full Gain'    0.5       0.43875    0.43864    0.43864    0.43862    0.43863
    'Full Gain'    0.7       0.56455    0.56439    0.56454    0.56442    0.56444
    'Full Gain'    0.9       0.67921    0.67896    0.67895    0.67894    0.67894
    ----------------------------------------------------------------------------
            CPU Time (sec) :  61.75      22.11      55.82      34.77      12.55


Valentin Bandelier
