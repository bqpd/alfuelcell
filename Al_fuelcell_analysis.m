% Aluminum Fuel Cell Analysis: written by Edward Burnell for 2.013
% Last edited: 12/9/2012
% This file a) loads trace data from tests conducted Dec. 2012 [*]
%           b) organizes it by electrolyte used
%           c) computes chemical efficiency and other derived values [**]
%           d) plots chemical efficiency and I-V curves
% Direct any questions to eburn@mit.edu.
clear all;
%% Set pretty default colors for plots
color = load('21colors.txt');
color = color(mod([8 15 27 3 9 14 20 21 26 2],length(color))+1,:);
set(0,'DefaultAxesColorOrder',color(1:3,:));
% Plot settings for powerpoint presentations
% set(0,'DefaultLineLineWidth',4,'DefaultLineMarkerSize',1,'DefaultAxesFontSize',24)
%% Load test data into structures (tests listed in order conducted)

% 1-M NaOH, 1%-wt Al/Ga
% 10-Ohm test conducted Dec. 1st, others Dec. 2nd
acid.R = [10 1e6 1e3 10e3];                         % resistance [Ohms]
acid.h2m = [1.05 .9 1.3 1];                         % total H2 prod. [mL]
acid.file = {   '1MHCl-100O-1pctAl.csv',...         % trace data files
                '1MHCl-1MO-1pctAl.csv',...
                '1MHCl-1kO-1pctAl.csv',...
                '1MHCl-10kO-1pctAl.csv'};
acid.ti = [0 250 0 250];                            % test start time in file [s]
acid.dur = [500 500 500 500];                       % test duration [s]
acid.V = [53 1309 909 955];                         % steady state voltage [mV]
                                                    % (derived from trace files)
% 1M NaOH, 1%-wt Al/Ga
% conducted Dec. 2nd
base.R = [10 10e3 1e3 1e6];
base.h2m = [1.2 .3 .3 .35];
base.file = {   '1MNaOH-100O-1pctAl.csv',...
                '1MNaOH-10kO-1pctAl.csv',...
                '1MNaOH-1kO-1pctAl.csv',...
                '1MNaOH-1MO-1pctAl.csv'};
base.ti = [0 250 0 250];
base.dur = [500 500 500 500];
base.V = [28 1105 783 1329];
            
% H2O, 1%-wt Al/Ga
% conducted Dec. 3rd
h2o.R = [1e3 10e3 1e2 1e6];
h2o.h2m = [.55 .95 .3 .15];
h2o.file = {    'H2O-1kO10kO-1pctAl.csv',...
                'H2O-1kO10kO-1pctAl.csv',...
                'H2O-100O1MO-1pctAl.csv',...
                'H2O-100O1MO-1pctAl.csv'};
h2o.ti = [0 250 0 250];
h2o.dur = [250 250 250 250];
h2o.V = [106 250 28 650];
            
% 5M NaOH, 1%-wt Al/Ga
% conducted Dec. 3rd
sbase.R = [10e3 1e2 1e3 1e1 1e6];
sbase.h2m = [1 .2 3.05 1.1 3.9];
sbase.file = {  'H2O-1kO10kO-1pctAl.csv',...
                'H2O-1kO10kO-1pctAl.csv',...
                'H2O-100O1MO-1pctAl.csv',...
                'H2O-100O1MO-1pctAl.csv'};
sbase.ti = [250 0 250 0 100];
sbase.dur = [250 250 250 100 400];
sbase.V = [668 575 684 293 715];
%% Place test data into data structures and compute derived values like current
acid.dscr = '1M HCl';
acid = derive_test_values(acid);
acid.c_eff(1) = .765; % data from Ian's 12/5 retest
%
base.dscr = '1M NaOH';
base = derive_test_values(base);
base.c_eff(1) = .625; % data from Ian's 12/4 retest
base.c_eff(3) = .379; % data from Ian's 12/4 retest
%
h2o.dscr = 'H_2O';
h2o = derive_test_values(h2o);
%
sbase.dscr = '5M NaOH';
sbase = derive_test_values(sbase);
%% Plot net system efficiency
% set colors cycle to two values
set(0,'DefaultAxesColorOrder',color([1 4],:));
% prepare to sort by resistance
[aR, aRI] = sort(acid.R);
[bR, bRI] = sort(base.R);
% initialize figure
figure(3); clf; hold on;
% plot points with errorbars
h(1) = errorbar(aR,acid.r_eff(aRI),.02+.1*acid.r_eff(aRI),'o');
errorbarlogx;
%
h(2) = errorbar(bR,base.r_eff(bRI),.02+.1*acid.r_eff(bRI),'x','Color',color(4,:));
errorbarlogx;
% plot lines
plot(aR,acid.r_eff(aRI),':',bR,base.r_eff(bRI),':');
% legend and labels
legend(h,acid.dscr,base.dscr,'Location','NorthEast');
legend boxoff
xlabel('Resistance [\Omega]')
ylabel('Net System Efficiency [-]')
% close plot
hold off
%% Plot reaction separation efficiency
% set colors cycle to three values
set(0,'DefaultAxesColorOrder',color([1 4 2],:));
% prepare to sort by resistance
[aR, aRI] = sort(acid.R);
[bR, bRI] = sort(base.R);
[hR, hRI] = sort(h2o.R);
% initialize figure
figure(1); clf; hold on;
% plot points with errorbars
bar = 0.1./acid.h2m(aRI).*acid.c_eff(aRI);    % error corresponding to 0.1 mL H2 production uncertainty
bar(1) = 0.06;                      % from Ian's retest
h = errorbar(aR,acid.c_eff(aRI),bar,'+');
errorbarT(h,.5,2);
errorbarlogx(.03);
%
bar = 0.1./base.h2m(bRI).*base.c_eff(bRI);
bar(1:2) = [0.06 0.07];             % from Ian's retest
h = errorbar(bR,base.c_eff(bRI),bar,'x','Color',color(4,:));
errorbarT(h,.5,2);
errorbarlogx(.03);
%
bar = 0.1./h2o.h2m(hRI).*h2o.c_eff(hRI);
h = errorbar(hR,h2o.c_eff(hRI),bar,'o','Color',color(2,:));
errorbarT(h,.5,2);
errorbarlogx(.03);
% plot lines
h = plot(aR,acid.c_eff(aRI),':',bR,base.c_eff(bRI),'--',hR,h2o.c_eff(hRI),'-.');
% legend, labels, ticks, and grid
legend(h,acid.dscr,base.dscr,h2o.dscr,'Location','NorthEast')
legend boxoff
ylim([0 1])
xlabel('Resistance [\Omega]')
ylabel('chemical efficiency [-]')
xlim([9 1.1e6])
set(gca,'YTick',0.2*[0:5])
set(gca,'XTick',10.^(1:6))
set(gca,'YGrid','on')
% close plot
hold off;
%% Plot average voltage
% set colors cycle to three values
set(0,'DefaultAxesColorOrder',color([1 4 2],:));
% prepare to sort by resistance
[aR, aRI] = sort(acid.R);
[bR, bRI] = sort(base.R);
[hR, hRI] = sort(h2o.R);
%
figure(5);
semilogx(aR,acid.V(aRI),'+:',bR,base.V(bRI),'x:',hR,h2o.V(hRI),'o:')
legend(acid.dscr,base.dscr,h2o.dscr,'Location','NorthWest')
legend boxoff
xlabel('Resistance [\Omega]')
ylabel('Average voltage during reaction [mV]')
%% Plot I-V curves
% set colors cycle to three values
set(0,'DefaultAxesColorOrder',color([1 4 2],:));
% h2o data from H20-all-1pctAl.csv
R = [1e6 1e4 1e3 144];
V = [1.7 .65 .12 .02]*1e3;
I = V./R;
[I,ind] = sort(I); V = V(ind);
% prepare to sort by resistance
[aI, aII] = sort(acid.I);
[bI, bII] = sort(base.I);
% initialize figure
figure(6); clf; hold on;
err = 100*ones(1,4);
errorbar(aI,acid.V(aII),min(err,acid.V(aII)),err,'o');
errorbarlogx(.03);
errorbar(bI,base.V(bII),min(err,base.V(bII)),err,'x','Color',color(4,:));
errorbarlogx(.03);
errorbar(I,V,min(err,V),err,'d','Color',color(2,:));
errorbarlogx(.03);
h = plot(aI,acid.V(aII),':',bI,base.V(bII),'--',I,V,'-.');
% make legend, labels
legend(h,acid.dscr,base.dscr,h2o.dscr,'Location','NorthEast')
legend boxoff
xlabel('Current [mA]')
ylabel('Voltage [mV]')
set(gca,'YGrid','on')
% close plot
hold off;