%% Graphene Surface Conductivity vs Frequency
% Computes and plots the real and imaginary parts of graphene's
% intraband surface conductivity (Kubo/Drude model) across a THz
% frequency sweep, for several chemical potential (mu_c) values.
% Reproduces "Figure 1" in the report.

% Constants
e = 1.602e-19;      % Elementary charge (C)
hbar = 1.055e-34;   % Reduced Planck constant (J.s)
k_B = 1.381e-23;    % Boltzmann constant (J/K)
T = 300;            % Temperature (K)
tau = 1e-12;        % Relaxation time (s)
Gamma = 1/(2*tau);  % Scattering rate (s^-1)

frequencies = linspace(0.01, 5, 500); % Frequency range (THz)
frequencies = frequencies * 1e12;     % Convert THz to Hz

% Chemical potentials
mu_c_values = [0, 0.5, 1] * e; % Chemical potential in eV converted to J

% Fermi-Dirac distribution function
f_d = @(epsilon, mu_c) 1 ./ (exp((epsilon - mu_c) / (k_B * T)) + 1);

% Intra-band conductivity formula
sigma_intra = @(omega, mu_c) - (1i * e^2 * k_B * T) ./ (pi * hbar^2 * (omega - 1i * 2 * Gamma)) .* ...
    (mu_c / (k_B * T) + 2 * log(1 + exp(-mu_c / (k_B * T))));

% Allocate arrays for results
real_sigma = zeros(length(frequencies), length(mu_c_values));
imag_sigma = zeros(length(frequencies), length(mu_c_values));

% Loop over chemical potentials and frequencies
for j = 1:length(mu_c_values)
    mu_c = mu_c_values(j);
    for i = 1:length(frequencies)
        omega = 2 * pi * frequencies(i);
        sigma = sigma_intra(omega, mu_c);
        real_sigma(i, j) = real(sigma); % Real part of conductivity
        imag_sigma(i, j) = imag(sigma); % Imaginary part of conductivity
    end
end

% Plotting
figure;
hold on;
colors = {'k', 'r', 'b'}; % Colors for different mu_c values
linestyles = {'-', '--'};

% Plot real and imaginary parts for each mu_c
for j = 1:length(mu_c_values)
    plot(frequencies / 1e12, real_sigma(:, j), 'Color', colors{j}, 'LineStyle', linestyles{1}, 'LineWidth', 1.5);
    plot(frequencies / 1e12, imag_sigma(:, j), 'Color', colors{j}, 'LineStyle', linestyles{2}, 'LineWidth', 1.5);
end

% Graph details
xlabel('Frequency f (THz)');
ylabel('Conductivity (\times 10^{-2} \Omega^{-1})');
legend({'Real part, \mu_c=0 eV', 'Imaginary part, \mu_c=0 eV', ...
    'Real part, \mu_c=0.5 eV', 'Imaginary part, \mu_c=0.5 eV', ...
    'Real part, \mu_c=1 eV', 'Imaginary part, \mu_c=1 eV'}, ...
    'Location', 'northeast');
grid on;
title('Graphene Surface Conductivity vs Frequency');
hold off;
