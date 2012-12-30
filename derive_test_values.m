function [el] = derive_test_values(el)
    % This function computes various derived values from each test's data.
    % 'el' is a compilation of test data for a given electrolyte
    el.I = el.V./el.R;                      % current [mA]
    el.E = el.dur.*((el.V/1e3).^2)./el.R;   % energy assuming constant voltage [J]
    %% Electrical efficiency
    mol_Al_per_J = 2.4e-6;                  % moles of Al per J (assuming 42.9 MJ/L of Al)
    L_h2_per_J = 22.4*1.5*mol_Al_per_J;     % L of H2 expected per J of Al (at STP)
    el.h2t = L_h2_per_J*el.E;               % expected hydrogen production
    el.r_eff = (el.h2t*1e3)./el.h2m;        % electrical efficiency
                                            % (ratio of H2 expected from
                                            % perfectly efficient fuel cell
                                            % to H2 measured)
    %% Chemical efficiency
    e = 1.602e-19;                          % charge of electron
    av = 6.02e23;                           % avogadro's number
    C = el.I/1000.*el.dur;                  % total coulombs during test
    mol_e = C/(e*av);                       % moles of electrons corresponding to C
    mol_h2 = el.h2m/1e3/22.4;               % moles of H2 produced
    el.c_eff = (mol_e*2)./mol_h2;           % reaction separation efficiency
                                            % (ratio of hydrogen
                                            % corresponding to electrons
                                            % produced by electrochemical
                                            % reaction to total hydrogen)
    %% Hydrogen production rate
    el.h2rate = el.h2m./el.dur;             % [mL/s]
end