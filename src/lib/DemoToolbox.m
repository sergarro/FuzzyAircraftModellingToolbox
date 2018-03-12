%% Demo toolbox
clc;clear all;
% Coefficients:
param.coef.CL0     = 0.9;
param.coef.CLa     = 5.5;
param.coef.CLq     = 3.3;
param.coef.CLh     = 0.2;
param.coef.lambdal = 0.12;
param.coef.CLde    = 0.32;

param.coef.CYb     = -0.7;
param.coef.CYdr     = 0.25;

param.coef.CD0     = 0.065;
param.coef.CDa     = 0.4;
param.coef.CDa2    = 1.55;

param.coef.Clb     = -3;
param.coef.Clp     = -15;
param.coef.Clr0    = 5;
param.coef.Clra    = 35;
param.coef.Clda    = -0.7;
param.coef.Cldr    = 0.2;

param.coef.Cm0     = -0.3;
param.coef.Cma     = -1.5; 
param.coef.Cmq     = -12;
param.coef.Cmh0    = -0.09;
param.coef.Cmha    = -0.9;
param.coef.lambdam = 0.15;
param.coef.Cmde    = -1.2;

param.coef.Cnb0    = 0.85;
param.coef.Cnba    = -1.95;
param.coef.Cnp0    = -3;
param.coef.Cnpa    = -35;
param.coef.Cnr     = -7;
param.coef.Cnda    = -0.04;
param.coef.Cndr    = -1.25;

% Geometry:
param.mig.Sref = 360;
param.mig.Lref = 7.5;

[ FIS ] = NoLin2FIS(param);
figure
subplot(2,2,1)
mfplot(FIS.a.mf)