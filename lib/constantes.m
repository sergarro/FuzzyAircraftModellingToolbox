function ACSP = constantes
% Value of the aircraft parameters (as a function of flight conditions)

syms MASS XCG gamGLD T0 WX altRWY gamRWY

% Coefficients:

ACSP.COEF.CL.CL0     = 0.9;
ACSP.COEF.CL.CLa     = 5.5;
ACSP.COEF.CL.CLq     = 3.3;
ACSP.COEF.CL.CLh     = 0.2;
ACSP.COEF.CL.lambdah = 0.12;
ACSP.COEF.CL.CLde    = 0.32;

ACSP.COEF.CY.CYb     = -0.7;
ACSP.COEF.CY.CYdr     = 0.25;

ACSP.COEF.CD.CD0     = 0.065;
ACSP.COEF.CD.CDa     = 0.4;
ACSP.COEF.CD.CDa2    = 1.55;

ACSP.COEF.Cl.Clb     = -3;
ACSP.COEF.Cl.Clp     = -15;
ACSP.COEF.Cl.Clr0    = 5;
ACSP.COEF.Cl.Clra    = 35;
ACSP.COEF.Cl.Clda    = -0.7;
ACSP.COEF.Cl.Cldr    = 0.2;

ACSP.COEF.Cm.Cm0     = -0.3;
ACSP.COEF.Cm.Cma     = -1.5; 
ACSP.COEF.Cm.Cmq     = -12;
ACSP.COEF.Cm.Cmh0    = -0.09;
ACSP.COEF.Cm.Cmha    = -0.9;
ACSP.COEF.Cm.lambdah = 0.15;
ACSP.COEF.Cm.Cmde    = -1.2;

ACSP.COEF.Cn.Cnb0    = 0.85;
ACSP.COEF.Cn.Cnba    = -1.95;
ACSP.COEF.Cn.Cnp0    = -3;
ACSP.COEF.Cn.Cnpa    = -35;
ACSP.COEF.Cn.Cnr     = -7;
ACSP.COEF.Cn.Cnda    = -0.04;
ACSP.COEF.Cn.Cndr    = -1.25;



% Geometry:

ACSP.MIG.Sref = 360;
ACSP.MIG.Lref = 7.5;
ACSP.MIG.mass = MASS*1000; 
mo            = 150000;
Ixx           = 1e7 + 45*(ACSP.MIG.mass - mo);
Iyy           = 1.6e7 + 33*(ACSP.MIG.mass - mo);
Izz           = 2.4e7 + 100*(ACSP.MIG.mass - mo);
Ixz           = -1e6;
ACSP.MIG.I    = [Ixx 0 Ixz ; 0 Iyy 0 ; Ixz 0 Izz];
ACSP.MIG.J    = inv(ACSP.MIG.I);
ACSP.MIG.dxG  = -0.21+0.01*XCG;
ACSP.MIG.dxE  = -0.21+0.01*XCG;
ACSP.MIG.dzE  = 0.2667;
ACSP.MIG.dxL  = -0.67 + 0.01*XCG;
ACSP.MIG.dzL  = 0.77;
ACSP.MIG.dxGL = 3.11 + 0.01*XCG;
ACSP.MIG.dzGL = 0.124;
ACSP.MIG.dxLO = 3.3 + 0.01*XCG;
ACSP.MIG.dzLO = 0.04;



% Atmosphere:

To               = T0+273;
ro_o             = 1.2257;
T_rwy            = To - 6.5e-3*altRWY;
ACSP.ATM.To      = To;
ACSP.ATM.rho     = (353/T_rwy)*(T_rwy/To)^5.25;
ACSP.ATM.va2vc   = sqrt(ACSP.ATM.rho/ro_o);
ACSP.ATM.va2Mach = 1/(20*sqrt(T_rwy));



% Engines

ACSP.ENG.Ga      = 876000;
ACSP.ENG.Gb      = -852000;
ACSP.ENG.tau     = 2;
ACSP.ENG.UML     = 1.6;
ACSP.ENG.LML     = 0.95;
ACSP.ENG.RL      = 0.1;



% Actuators

ACSP.ACT.tau     = [0.0600 0.0700 0.2000];
ACSP.ACT.RL      = [1.0472 0.3491 0.5236];
ACSP.ACT.ML      = [0.9599 0.4363 0.5236];




% ILS

ACSP.ILS.tanggld = tan(abs(gamGLD)*pi/180);
ACSP.ILS.xgld    = -775864980.052022*ACSP.ILS.tanggld^5+243925997.427633*ACSP.ILS.tanggld^4-...
                    31945733.6562435*ACSP.ILS.tanggld^3+2230798.62384287*ACSP.ILS.tanggld^2-...
                    87604.0775635378*ACSP.ILS.tanggld+1834.34434821045;
ACSP.ILS.xloc    = 3000;




% Runaway

ACSP.RWY.elevation = altRWY;
ACSP.RWY.slope     = gamRWY/100;




% Noise

ACSP.NOISE.devLOC  = 0;
ACSP.NOISE.sigLOC  = 0;
ACSP.NOISE.sigGLD  = 0;
ACSP.NOISE.seedLOC = 4;
ACSP.NOISE.seedGLD = 5;



% Turbulence

ACSP.TURBW.WindStepTime = [0 0 0];
ACSP.TURBW.WindStepMag  = [0 0 0];
ACSP.TURBW.WX33         = WX;
ACSP.TURBW.WY33         = 0;
ACSP.TURBW.sigu         = 0;
ACSP.TURBW.sigw         = 0;
ACSP.TURBW.seedwx       = 1;
ACSP.TURBW.seedwy       = 2;
ACSP.TURBW.seedwz       = 3;


end
