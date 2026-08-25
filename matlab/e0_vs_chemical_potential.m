%% E0 vs Chemical Potential at Extreme Temperature
% Numerically integrates a Fermi-Dirac-based expression to obtain the
% field E0 as a function of chemical potential mu_c, evaluated at an
% extreme temperature. Reproduces "Figure 5" in the report.

% Constants
e = 1.60217662e-19;      % Elementary charge in Coulombs
h_bar = 1.054571817e-34; % Reduced Planck constant in J.s
v_F = 1e6;               % Fermi velocity in m/s
epsilon_b = 4;           % Example dielectric constant of the medium
k_B = 1.380649e-23;      % Boltzmann constant in J/K

% Set extreme temperature
T = 12000; % Extreme temperature in Kelvin

% Fermi-Dirac distribution function
f_d = @(epsilon, mu_c) 1 ./ (exp((epsilon - mu_c) / (k_B * T)) + 1);

% Increase upper limit for energy integration to an extreme value
energy_limit = 1e-19; % Very large upper integration limit

% Integrand function for E0
integrand = @(epsilon, mu_c) (f_d(epsilon, 0) - f_d(epsilon + 2 * mu_c, 0));

% Function to calculate E0 with numerical integration
E0 = @(mu_c) (e / (pi * h_bar^2 * v_F^2 * epsilon_b)) * integral(@(epsilon) integrand(epsilon, mu_c), 0, energy_limit);

% Range of chemical potentials (in eV)
mu_c_eV = linspace(-3, 3, 500); % Chemical potential in eV
mu_c_J = mu_c_eV * e;           % Convert to Joules

% Calculate E0 for each chemical potential
E0_values = arrayfun(E0, mu_c_J);

% Plotting the results
figure;
plot(mu_c_eV, 1); % NOTE: as in the original report appendix — this line's
                   % output is immediately overwritten by the next plot()
                   % call below (no `hold on` in between), so it has no
                   % visible effect. Left in place for fidelity to source.
plot(E0_values, mu_c_eV, 'LineWidth', 1.5);
xlabel('Chemical potential \mu_c (eV)');
ylabel('E_0 (V \cdot nm^{-1})');
title('Comparison of E_0 against increasing \mu_c at Extreme Temperature and Energy Range');
grid on;
