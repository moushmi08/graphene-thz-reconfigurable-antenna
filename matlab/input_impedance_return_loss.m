%% Input Impedance & Return Loss vs Chemical Potential
% Models the antenna's equivalent-circuit input admittance/impedance
% across frequency for several mu_c values, then derives the
% reflection coefficient and return loss. Reproduces "Figures 2, 3, 4"
% in the report (Input Resistance, Input Reactance, Return Loss).

clear;
clc;

% Constants
mu0 = 4 * pi * 1e-7;  % Permeability of free space (H/m)
sigma_v = 1e7;        % Bulk conductivity of graphene (S/m)
dg = 0.1e-6;          % Equivalent thickness of graphene (m)

% Reference impedance
Z0 = 50; % Reference impedance (Ohms)

% Frequency range
f = linspace(1e8, 10e9, 1000); % Frequency from 100 MHz to 10 GHz
omega = 2 * pi * f;             % Angular frequency (rad/s)

% Antenna parameters
R0 = 500;   % Base Resistance (Ohms)
C0 = 5e-10; % Base Capacitance (F)
L0 = 1e-3;  % Base Inductance (H)

% Define chemical potential values for mu_c
mu_c_values = [0, 0.05, 0.1, 0.2, 0.5, 1]; % Updated values for mu_c
num_values = length(mu_c_values);

% Initialize input impedance arrays and return loss array
Zin_real_all = zeros(num_values, length(f));    % Input resistance for each mu_c
Zin_imag_all = zeros(num_values, length(f));    % Input reactance for each mu_c
return_loss_all = zeros(num_values, length(f)); % Return loss for each mu_c

% Loop through each mu_c value
for m = 1:num_values
    mu_c = mu_c_values(m); % Current chemical potential

    % Calculate parameters based on mu_c
    R_shift = 1 + mu_c;                         % Resistance shift
    C_shift = 5e-12 * (1 / (1 + 2 * mu_c));     % Capacitance shift
    L_shift = 1e-9 / (1 + 5 * mu_c);            % Inductance shift

    % Initialize input admittance arrays for this mu_c
    Yin_real = zeros(size(f)); % Real part of input admittance
    Yin_imag = zeros(size(f)); % Imaginary part of input admittance

    % Loop through frequencies to calculate input admittance
    for i = 1:length(f)
        % Calculate total admittance
        Ysn = 0.1 + 1i * omega(i) * C_shift;          % Equivalent admittance of the open slot
        Yline = 1 / (R_shift + 1i * omega(i) * L_shift); % Transmission line admittance
        Ytotal = Ysn + Yline;                          % Total input admittance

        % Store real and imaginary parts
        Yin_real(i) = real(Ytotal); % Real part of input admittance
        Yin_imag(i) = imag(Ytotal); % Imaginary part of input admittance
    end

    % Calculate Input Impedance for current mu_c
    Zin = 1 ./ (Yin_real + 1i * Yin_imag); % Input impedance

    % Extract real and imaginary parts of input impedance
    Zin_real_all(m, :) = real(Zin); % Input resistance
    Zin_imag_all(m, :) = imag(Zin); % Input reactance

    % Calculate Reflection Coefficient and Return Loss for current mu_c
    reflection_coefficient = (Zin - Z0) ./ (Zin + Z0);
    return_loss_all(m, :) = 20 * log10(abs(reflection_coefficient));
end

% Scale frequency and input impedance
f_scaled = f * 100;                       % Scale frequency by 100
Zin_real_all = Zin_real_all * 100;        % Scale input resistance by 100
Zin_imag_all = Zin_imag_all * 100;        % Scale input reactance by 100

% Plot Input Resistance for different mu_c values in a new figure
figure;
hold on;
for m = 1:num_values
    plot(f_scaled * 1e-9, Zin_real_all(m, :), 'DisplayName', ['\mu_c = ' num2str(mu_c_values(m))]);
end
grid on;
title('Input Resistance of Graphene Reconfigurable Antenna for Varying \mu_c');
xlabel('Frequency (GHz)');
ylabel('Input Resistance (Ohms) (scaled by 100)');
xlim([0 1000]);
legend show;
hold off;

% Plot Input Reactance for different mu_c values in a new figure
figure;
hold on;
for m = 1:num_values
    plot(f_scaled * 1e-9, Zin_imag_all(m, :), 'DisplayName', ['\mu_c = ' num2str(mu_c_values(m))]);
end
grid on;
title('Input Reactance of Graphene Reconfigurable Antenna for Varying \mu_c');
xlabel('Frequency (GHz)');
ylabel('Input Reactance (Ohms) (scaled by 100)');
xlim([0 1000]);
legend show;
hold off;

% Plot Return Loss for different mu_c values in a new figure
figure;
hold on;
for m = 1:num_values
    plot(f_scaled * 1e-9, return_loss_all(m, :), 'DisplayName', ['\mu_c = ' num2str(mu_c_values(m))]);
end
grid on;
title('Return Loss of Graphene Reconfigurable Antenna for Varying \mu_c');
xlabel('Frequency (GHz)');
ylabel('Return Loss (dB)');
xlim([0 1000]);
legend show;
hold off;

% Display message to confirm that separate figures were created
disp('Separate figures generated for Input Resistance, Input Reactance, and Return Loss.');
