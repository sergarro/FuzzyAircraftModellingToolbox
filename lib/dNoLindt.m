function [ dYoutdt] = dNoLindt(t,Y,input_t,input_u,param)
%% Differential equations from NonLinear Aircraft Model
%% Input
%  t     : time instant
%  Y     : Init condition state variables
%  input_t: time vector column of system inputs
%  input_u: values vector column of system inputs
%  param : aircraft especification struct (see ParamsInput.m)
%% Output
%  - dYoutdt : 1x12 vector with diferential states variables. 
%              -->  [dOMdt,dVdt,dPHIdt,dXdt]
%% Init values
OM=Y(1,1:3)';
V=Y(1,4:6)';
PHI=Y(1,7:9)';
X=Y(10:12)';
%epr=Y(13)';
%delta=Y(14:16)';

%% Inputs
epr=interp1(input_t,input_u(:,1),t);
da=interp1(input_t,input_u(:,2),t);
de=interp1(input_t,input_u(:,3),t);
dr=interp1(input_t,input_u(:,4),t);
Wx=interp1(input_t,input_u(:,5),t);
Wy=interp1(input_t,input_u(:,6),t);
Wz=interp1(input_t,input_u(:,7),t);

delta=[da,de,dr];

%% Engine & Actuators
Fx=param.eng.Ga*epr+param.eng.Gb;

%% Rotations and tranformations matrix
TPHI=[1, sin(PHI(1))*tan(PHI(2)),cos(PHI(1))*tan(PHI(2))
      0, cos(PHI(1)), -sin(PHI(1))
      0, sin(PHI(1))/cos(PHI(2)), cos(PHI(1))/cos(PHI(2))];
Rb2v=[cos(PHI(2))*cos(PHI(3)),sin(PHI(1))*sin(PHI(2))*cos(PHI(3))-sin(PHI(3))*cos(PHI(3)),...
                              sin(PHI(1))*sin(PHI(3))+sin(PHI(2))*cos(PHI(1))*cos(PHI(3))
      cos(PHI(2))*sin(PHI(3)),cos(PHI(1))*cos(PHI(3))+sin(PHI(2))*sin(PHI(1))*sin(PHI(3))...
                              sin(PHI(2))*cos(PHI(1))*sin(PHI(3))-sin(PHI(1))*cos(PHI(3))
      -sin(PHI(2)), cos(PHI(2))*sin(PHI(1)),cos(PHI(2))*cos(PHI(1))];
Rv2b=Rb2v';


%% Wind and atmosphere
W=[Wx,Wy,Wz]';
vVa=V-Rv2b*W;
Va=sqrt(vVa(1)^2+vVa(2)^2+vVa(3)^2);
qd=0.5*param.atm.rho_0*Va^2;
alpha=atan2(vVa(3),vVa(1));
beta=asin(vVa(2)/Va);
Rs2b=[cos(alpha),0,-sin(alpha)
      0,1,0
      sin(alpha),0,cos(alpha)];
%% Ground
Hlg=X(3)-param.rwy.elevation;
%% Aerodinamic Coeficients
CL=param.coef.CL0+param.coef.CLa*alpha+param.mig.Lref/Va*param.coef.CLq*OM(2)...
    +param.coef.CLde*delta(2)+param.coef.CLh*exp(-abs(param.coef.lambdal*Hlg));
CY=param.coef.CYb*beta+param.coef.CYdr*delta(3);
CD=param.coef.CD0+param.coef.CDa*alpha+param.coef.CDa2*alpha^2;
Cl=param.coef.Clb*beta+param.mig.Lref/Va*(param.coef.Clp*OM(1)+(param.coef.Clr0+...
    param.coef.Clra*alpha)*OM(3))+param.coef.Clda*delta(1)+param.coef.Cldr*delta(3);
Cm=param.coef.Cm0+param.coef.Cma*alpha+param.mig.Lref/Va*param.coef.Cmq*OM(2)+...
    param.coef.Cmde*delta(2)+(param.coef.Cmh0+param.coef.Cmha*alpha)*exp(-abs(param.coef.lambdam*Hlg));
Cn=(param.coef.Cnb0+param.coef.Cnba*alpha)*beta+param.mig.Lref/Va*(param.coef.Cnr*OM(3)+...
    (param.coef.Cnp0+param.coef.Cnpa*alpha)*OM(1))+param.coef.Cnda*delta(1)+param.coef.Cndr*delta(3);

%% Forces and Moments
Feng=[Fx;0;0];
Fg=Rv2b*[0;0;param.mig.Mass*9.81];
Fa=qd*param.mig.Sref*Rs2b*[-CD;CY;-CL];
F=Feng+Fa+Fg;

Meng=[0;param.mig.dze*Fx;0];
Ma=(qd*param.mig.Sref*[Cl;Cm;Cn]+cross([param.mig.dxg;0;0],Fa));
M=(Ma+Meng)*param.mig.Lref;
%% Differential equations  
dOMdt=param.mig.J*(M-cross(OM,param.mig.I*OM));
dVdt=F/param.mig.Mass-cross(OM,V);
dPHIdt=TPHI*OM;
dXdt=Rb2v*V;

%% Out Values
dYoutdt=[dOMdt',dVdt',dPHIdt',dXdt'];%,ddeltadt',deprdt'];
end

