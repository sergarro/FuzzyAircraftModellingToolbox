function CalcTrim(src,event)
k=0;
wb = waitbar(k,'Calculating Trim Values...');
global Strings
load('../data/CurrentVars')
addpath('../lib')

syms x y z u v w p q r phi theta Psi real; 
syms epr delta_a delta_e delta_r Windx Windy Windz real;
syms MASS XCG gamGLD T0 WX altRWY gamRWY real;

states = [x y z u v w p q r phi theta Psi];
inputs = [epr delta_a delta_e delta_r Windx Windy Windz];
flight = [MASS XCG gamGLD T0 WX altRWY gamRWY];

waitbar(0.30);
[deriv,out] = modelo;

flightpar.MASS=var.Mass/1000;
flightpar.XCG=var.XCG;
flightpar.VC=2.572+0.5144*max(119*sqrt(flightpar.MASS/140),118);
flightpar.WX=0;
flightpar.altRWY=0;
flightpar.gamRWY=0;
flightpar.T0=var.T0;
flightpar.Z=var.alt;
flightpar.gamK=0;
flightpar.gamGLD=0;
flightpar.dZ=0;
flightpar.dY=0;

waitbar(0.60);
p_eq = eq_point(deriv,out,flightpar,states,inputs,flight);

var.p0=p_eq(7);
var.q0=p_eq(8);
var.r0=p_eq(9);
var.u0=p_eq(4);
var.v0=p_eq(5);
var.w0=p_eq(6);
var.phi0=p_eq(10);
var.theta0=p_eq(11);
var.psi0=p_eq(12);
var.x0 = p_eq(1);
var.y0 = p_eq(2);
var.z0 = p_eq(3);
var.dp0=p_eq(13);
var.da0=p_eq(14);
var.de0=p_eq(15);
var.dr0=p_eq(16);
waitbar(0.90);
for i=1:length(Strings.Init.labels)
    for j=1:length(Strings.(Strings.Init.labels{i}).labels)
        
    h = findobj('Tag',Strings.(Strings.Init.labels{i}).labels{j});
    set(h,'String',num2str(var.(Strings.(Strings.Init.labels{i}).labels{j})));
    end
end
save('../data/CurrentVars','var')
waitbar(1);
close(wb)
end

