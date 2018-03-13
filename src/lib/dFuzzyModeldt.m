function [ dYoutdt ] = dFuzzyModeldt(t,Y,input_t,input_u,param)
%% Description
%Aircraft Fuzzy and quaternion Model.
%% Input
%  t     : time instant
%  Y     : Init condition state variables [OM,V,Quat,X]
%  input_t: time vector column of system inputs
%  input_u: values vector column of system inputs
%  param : aircraft especification struct 
%          On this case, include param.FIS
%% Output
%  - dYoutdt : 1x13 vector with diferential states variables. 
%              -->  [dOMdt,dVdt,dQuatdt,dXdt]
%% Paths
addpath('lib');
%% Init values
OM=Y(1,1:3)';
V=Y(1,4:6)';
Quat=Y(1,7:10)';
X=Y(11:13)';

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
TQuat=[-Quat(2),-Quat(3),-Quat(4)
        Quat(1),-Quat(4),Quat(3)
        Quat(4),Quat(1),-Quat(2)
        -Quat(3),Quat(2),Quat(1)];
Rb2v=[Quat(1)^2+Quat(2)^2-Quat(3)^2-Quat(4)^2,2*(Quat(2)*Quat(3)-Quat(4)*Quat(1)),...
                                  2*(Quat(2)*Quat(4)+Quat(3)*Quat(1))
      2*(Quat(2)*Quat(3)+Quat(4)*Quat(1)),Quat(1)^2-Quat(2)^2+Quat(3)^2-Quat(4)^2,...
                                  2*(Quat(3)*Quat(4)-Quat(2)*Quat(1))
      2*(Quat(2)*Quat(4)-Quat(3)*Quat(1)),2*(Quat(3)*Quat(4)+Quat(2)*Quat(1)),...
                                  Quat(1)^2-Quat(2)^2-Quat(3)^2+Quat(4)^2];
Rv2b=Rb2v';


%% Wind and atmosphere
W=[Wx,Wy,Wz]';
vVa=V-Rv2b*W;
Va2=vVa(1)^2+vVa(2)^2+vVa(3)^2;
Va=calcfuzzy(param.FIS.Va,Va2);
qd=0.5*param.atm.rho_0*Va^2;
xa=[atan2(vVa(3),vVa(1)),vVa(3)/vVa(1)];
alpha=calcfuzzy(param.FIS.a,xa);
xb=[asin(vVa(2)/Va),vVa(2)/Va];
beta=calcfuzzy(param.FIS.a,xb);
q4=cos(-alpha/2);
q5=sin(-alpha/2);

Rs2b=[q4^2-q5^2,0,2*q4*q5
      0,q4^2+q5^2,0
      -2*q4*q5,0,q4^2-q5^2];
%% Ground
Hlg=X(3)-param.rwy.elevation;
%% Aerodinamic Coeficients
CL1=calcfuzzy(param.FIS.CL1,OM(2)/Va);
%CL2=0;
CL2=calcfuzzy(param.FIS.CL2,exp(-abs(param.coef.lambdal*Hlg)),param.coef.lambdal*Hlg);
CL=param.coef.CL0+param.coef.CLa*alpha+CL1...
    +param.coef.CLde*delta(2)+CL2;
CY=param.coef.CYb*beta+param.coef.CYdr*delta(3);
CD2=calcfuzzy(param.FIS.CD2,alpha);
CD=param.coef.CD0+param.coef.CDa*alpha+CD2;

Cl1=calcfuzzy(param.FIS.Cl1,OM(1)/Va);
Cl2=calcfuzzy(param.FIS.Cl2,[OM(3)/Va,alpha]);
Cl=param.coef.Clb*beta+Cl1+Cl2+param.coef.Clda*delta(1)+param.coef.Cldr*delta(3);
Cm1=calcfuzzy(param.FIS.Cm1,OM(2)/Va);
Cm2=calcfuzzy(param.FIS.Cm2,[exp(-abs(param.coef.lambdam*Hlg)),alpha],[param.coef.lambdam*Hlg,alpha]);
Cm=param.coef.Cm0+param.coef.Cma*alpha+Cm1+...
    param.coef.Cmde*delta(2)+Cm2;
Cn1=calcfuzzy(param.FIS.Cn1,OM(3)/Va);
Cn2=calcfuzzy(param.FIS.Cn2,[OM(1)/Va,alpha]);
Cn3=calcfuzzy(param.FIS.Cn3,[beta,alpha]);
Cn=Cn3+Cn2+Cn1+param.coef.Cnda*delta(1)+param.coef.Cndr*delta(3);

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
dQuatdt=0.5*TQuat*OM;
dXdt=Rb2v*V;

%% Out Values
dYoutdt=[dOMdt',dVdt',dQuatdt',dXdt'];%,ddeltadt',deprdt'];
if mod(t,10)==0
   fprintf('t=%d',t) 
end
if (param.waitbar)
   waitbar(0.7+0.3*(t/param.tf))
end
end

