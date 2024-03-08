function param = ParamsInput( MASS,XCG,altRWY,T0)
%% This function call input parameters constants.
%% Inputs

%% Outputs

%% Code

%% Coeficients
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

%%  Geometry:
param.mig.Sref = 360;
param.mig.Lref = 7.5;
param.mig.mass = MASS*1000; 
param.mig.Mass = param.mig.mass;
mo            = 150000;
Ixx           = 1e7 + 45*(param.mig.mass - mo);
Iyy           = 1.6e7 + 33*(param.mig.mass - mo);
Izz           = 2.4e7 + 100*(param.mig.mass - mo);
Ixz           = -1e6;
param.mig.I    = [Ixx 0 Ixz ; 0 Iyy 0 ; Ixz 0 Izz];
param.mig.J    = inv(param.mig.I);
param.mig.dxg  = -0.21+0.01*XCG;
param.mig.dxe  = -0.21+0.01*XCG;
param.mig.dze  = 0.2667;
param.mig.dxL  = -0.67 + 0.01*XCG;
param.mig.dzL  = 0.77;
param.mig.dxGL = 3.11 + 0.01*XCG;
param.mig.dzGL = 0.124;
param.mig.dxLO = 3.3 + 0.01*XCG;
param.mig.dzLO = 0.04;
%% Atmosphere:
To               = T0+273;
ro_o             = 1.2257;
T_rwy            = To - 6.5e-3*altRWY;
param.atm.To     = To;
param.atm.rho  = (353/T_rwy)*(T_rwy/To)^5.25;
param.atm.rho_0 = ro_o;
param.atm.va2vc   = sqrt(param.atm.rho/ro_o);
param.atm.va2Mach = 1/(20*sqrt(T_rwy));
%% Engines
param.eng.Ga      = 876000;
param.eng.Gb      = -852000;
param.eng.tau     = 2;
param.eng.UML     = 1.6;
param.eng.LML     = 0.95;
param.eng.RL      = 0.1;
%% Actuators
param.act.tau     = [0.0600 0.0700 0.2000];
param.act.RL      = [1.0472 0.3491 0.5236];
param.act.ML      = [0.9599 0.4363 0.5236];
%% Runaway
param.rwy.elevation = altRWY;

end

