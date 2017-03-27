# Master Project in Financial Mathematics, EPFL
## Pricing TARN Using Numerical Methods
The goal of this project is to find some efficient numerical methods in order to price Target Accrual Redemption Notes (TARN).
For the moment I have implemented the Monte Carlo (MC), Finite Difference (FD) Gauss-Hermite Quadrature with Cubic interpolation (GHQC) methods on a Black-Scholes model with constant paramters.

However there is a problem with a special case, called No Gain Knock-Out type, for the FD and GHQC methods. The problem seems to be in the interpolation of a discontinous function.

The next step is to find other methods, more efficient than these ones if possible and extend them to more complex models as Local Volatility or Stochastic Volatility models.

First Results :

      KO_Type      Target      MC         FD        GHQC        TR   
    ___________    ______    _______    _______    _______    _______

    'No Gain'      0.3       0.19556   (0.20435)  (0.20539)  (0.21365)
    'No Gain'      0.5       0.32866   (0.33737)  (0.33700)  (0.35668)
    'No Gain'      0.7       0.45018   (0.45957)  (0.45944)  (0.49360)
    'No Gain'      0.9       0.56325   (0.57295)  (0.57276)  (0.62135)
    'Part Gain'    0.3       0.24450    0.24437    0.24448   (0.25802)
    'Part Gain'    0.5       0.38177    0.38157    0.38173   (0.40901)
    'Part Gain'    0.7       0.50614    0.5058     0.50602   (0.54871)
    'Part Gain'    0.9       0.61945    0.61963    0.61989   (0.67902)
    'Full Gain'    0.3       0.29772    0.29742    0.29752   (0.31752)
    'Full Gain'    0.5       0.43875    0.43861    0.43824   (0.47385)
    'Full Gain'    0.7       0.56455    0.56429    0.56413   (0.61725)
    'Full Gain'    0.9       0.67921    0.67966    0.67933   (0.74975)

Valentin Bandelier
