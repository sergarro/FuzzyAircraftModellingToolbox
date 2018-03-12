%% A310 vars
%% Coefficients

var.CL0=0.9;
var.CLa=5.5;
var.CLq=3.3;
var.CLh=0.2;
var.CLde=0.32;
var.lambdal=0.12;

var.CYdr=-0.7;
var.CYb=0.25;

var.CD0=0.065;
var.CDa=0.4;
var.CDa2=1.55;

var.Clb=-3;
var.Clp=-15;
var.Clr0=5;
var.Clra=35;
var.Clda=-0.7;
var.Cldr=0.2;

var.Cm0=-0.3;
var.Cma=-1.5;
var.Cmq=-12;
var.Cmh0=-0.09;
var.Cmha=-0.9;
var.lambdam=0.15;
var.Cmde=-1.2;

var.Cnb0=0.85;
var.Cnba=-1.95;
var.Cnp0=-3;
var.Cnpa=-35;
var.Cnr=-7;
var.Cnda=-0.04;
var.Cndr=-1.25;
%% Mass and geometry
var.Sref=360;
var.Lref=7.5;
var.Mass = 150000;
var.XCG = 21;
var.Ixx =1e7 + 45*(var.Mass - 150000);
var.Iyy =1.6e7 + 33*(var.Mass - 150000);
var.Izz =2.4e7 + 100*(var.Mass - 150000);
var.Ixz =-1e6;
var.dxg =-0.21+0.01*var.XCG;
var.dze =0.2667;

%% Atmosphere
var.T0 =15+273;
var.rho_0=1.2257;
var.T_rwy =0;
var.va2vc =0;
var.va2M =0;
var.alt = 1000;
%% Engine
var.Ga=876000;
var.Gb=-852000;
var.tau=2;
var.LML=0.95;
var.UML=1.6;
var.RL=0.1;

%%Actuators
var.a_tau=0.06;
var.a_RL=1.0472*180/pi;
var.a_ML=0.9599*180/pi;

var.e_tau=0.07;
var.e_RL=0.3491*180/pi;
var.e_ML=0.4363*180/pi;

var.r_tau=0.2;
var.r_RL=0.5236*180/pi;
var.r_ML=0.5236*180/pi;

save('A310vars','var')
