# Master Project in Financial Mathematics, EPFL
## Pricing FX-TARN Under Lévy Processes Using Numerical Methods
The FX Target Accrual Redemption Notes (FX-TARN) are financial products on currency pairs. These are speculation products of a very risky nature, which makes them very popular in Asia. 

This thesis presents different numerical methods for pricing FX-TARN under L\'evy processes. The main goal is to go beyond the famous Black-Scholes model, which does not perform good with respect to the market structure. Thus, L\'evy processes including jumps are more adapted to the market observations.

In general, options with path dependents payoff, such as this product, are evaluated by Monte Carlo simulations. We will describe two other methods based respectively on Finite Difference (FD) and Fast Fourier Transform (FFT) in order to boost the performances of our pricing engine. At the end of this project, we will be able to propose a fast and accuracy method, which is not available in the literature, to price FX-TARN. This method is a combination of the methods proposed by Luo and Shevchenko (2015) and Lord et al. (2008). 

The main advantage of the method, proposed in this work, is that it is easy to implement and allows us to extend it to all L\'evy processes with closed form characteristic function.
