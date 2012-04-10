from math import *

def f(mu, sigma2, x):
    return 1/sqrt(2.0*pi*sigma2) * exp(-0.5 * (x - mu)**2 / sigma2)
    
print f(10.0, 4.0, 10.0)