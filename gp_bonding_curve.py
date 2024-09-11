import numpy as np
import matplotlib.pyplot as plt

def get_amount_out(a, b, x0, delta_y):
    exp_b_x0 = np.exp(b * x0)
    exp_b_x1 = exp_b_x0 + (delta_y * b / a)
    delta_x = np.log(exp_b_x1) / b - x0
    return delta_x

# Set parameters
a = 1631932441900
b = 10000000000
delta_y = 1e18  # Fixed amount spent

# Generate data points
x0_values = np.linspace(0, 1e18, 1000)
delta_x_values = [get_amount_out(a, b, x0, delta_y) for x0 in x0_values]

# Create the plot
plt.figure(figsize=(12, 8))
plt.plot(x0_values, delta_x_values)
plt.title('Bonding Curve: Tokens Received vs Total Supply')
plt.xlabel('Total Supply (x0)')
plt.ylabel('Tokens Received (deltaX)')
plt.xscale('log')
plt.yscale('log')
plt.grid(True)
plt.show()