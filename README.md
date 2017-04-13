# Master Project in Financial Mathematics, EPFL
## Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

## Results
Results under BS model: 

(MC = 1e6 simulations ; FD = 500 x 300 x 50; GHQC = 500 x 50; QUAD,CONV = 1024 x 50)

      KO_Type      Target     Exact       MC         FD        GHQC       QUAD       CONV  
    ___________    ______    _______    _______    _______    _______    _______    _______
    'No Gain'      0.3       0.19540    0.19556    0.19552    0.19506    0.19529    0.19542
    'No Gain'      0.5       0.32865    0.32866    0.32866    0.32852    0.32858    0.32853
    'No Gain'      0.7       0.45057    0.45018    0.45055    0.45072    0.45043    0.45056
    'No Gain'      0.9       0.56331    0.56325    0.56325    0.56315     0.5633    0.56334
    
    'Part Gain'    0.3       0.24454    0.24450    0.24454    0.24450    0.24454    0.24453
    'Part Gain'    0.5       0.38180    0.38177    0.38181    0.38175    0.38180    0.38179
    'Part Gain'    0.7       0.50609    0.50614    0.50610    0.50604    0.50609    0.50608
    'Part Gain'    0.9       0.61996    0.61945    0.61998    0.61990    0.61997    0.61995
    
    'Full Gain'    0.3       0.29769    0.29772    0.29775    0.29729    0.29751    0.29767
    'Full Gain'    0.5       0.43863    0.43875    0.43859    0.43846    0.43851    0.43846
    'Full Gain'    0.7       0.56442    0.56455    0.56438    0.56452    0.56423    0.56436
    'Full Gain'    0.9       0.67894    0.67921    0.67885    0.67874    0.67889    0.67893
    ---------------------------------------------------------------------------------------
     rRMSE :                    NA      4.51E-4    1.99E-4    6.77E-4    2.95E-4    1.60E-4
     CPU(sec):                 >200     110.041     2.037      7.283      2.862      2.685
 
Valentin Bandelier
