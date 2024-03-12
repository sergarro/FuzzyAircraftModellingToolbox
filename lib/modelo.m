    function [deriv,out] = modelo
% Returns the main  equations of the aircraft model given in the document
% "A Civilian Aircraft Landing Challenge"


syms u v w x y z phi theta Psi p q r real;
syms epr delta_a delta_e delta_r Windx Windy Windz real;

ACSP = constantes;

%  Matrixes

TPHI = [1 sin(phi)*sin(theta)/cos(theta) cos(phi)*sin(theta)/cos(theta);...
        0 cos(phi) -sin(phi);0 sin(phi)/cos(theta) cos(phi)/cos(theta)];

RB2V = [cos(theta)*cos(Psi) sin(phi)*sin(theta)*cos(Psi)-cos(Psi)*sin(Psi) cos(Psi)*sin(theta)*cos(phi)+sin(phi)*sin(Psi);...
        cos(theta)*sin(Psi) cos(Psi)*cos(phi)+sin(phi)*sin(theta)*sin(Psi) sin(Psi)*sin(theta)*cos(phi)-cos(Psi)*sin(phi);...
        -sin(theta) sin(phi)*cos(theta) cos(theta)*cos(phi)];
    
RV2B = transpose(RB2V);

% Landing Gear

xyzLG    = [x;y;z]+ACSP.MIG.Lref*RB2V*[ACSP.MIG.dxL;0;ACSP.MIG.dzL];
Hlg      = -xyzLG(3);
Dlg      = xyzLG(1);
Ylg      = xyzLG(2);


%  Engines and actuators

TH = ACSP.ENG.Ga*epr + ACSP.ENG.Gb;

% Wind and Atm

VA = [u;v;w]-RV2B*[Windx;Windy;Windz];
Va = sqrt(sum(VA.*VA));
Vc = ACSP.ATM.va2vc*Va;
qd = 0.5*sum(VA.*VA)*ACSP.ATM.rho;

a  = atan2(VA(3),VA(1));
b  = asin(VA(2)/Va);

% F and M

qS = qd*ACSP.MIG.Sref;

     % Forces
Fg      = RV2B(:,3)*9.81*ACSP.MIG.mass;
Fengine = [TH;0;0];

CX      = -1*(ACSP.COEF.CD.CD0 + a*ACSP.COEF.CD.CDa + a*a*ACSP.COEF.CD.CDa2);
CY      = b*ACSP.COEF.CY.CYb + delta_r*ACSP.COEF.CY.CYdr;
CZ      = -1*(ACSP.COEF.CL.CL0 + ACSP.COEF.CL.CLa*a +(q/Va)*ACSP.MIG.Lref*ACSP.COEF.CL.CLq + delta_e*ACSP.COEF.CL.CLde + ACSP.COEF.CL.CLh*exp(-abs(Hlg*ACSP.COEF.CL.lambdah)));
CXYZ    = [CX;CY;CZ];

Fb      = qS*CXYZ;
Fa      = [cos(a)*Fb(1)-sin(a)*Fb(3);Fb(2);sin(a)*Fb(1)+cos(a)*Fb(3)];

Nxyz    = (-1/ACSP.MIG.mass)*(Fengine+Fa);
F       = Fg + Fengine + Fa;

     % Moments
     
MFaero  = cross([ACSP.MIG.dxG;0;0],Fa);
Mengine = [0;TH*ACSP.MIG.dzE;0];

Cl      = b*ACSP.COEF.Cl.Clb + (ACSP.MIG.Lref/Va)*(p*ACSP.COEF.Cl.Clp+(a*ACSP.COEF.Cl.Clra+ACSP.COEF.Cl.Clr0)*r) + delta_a*ACSP.COEF.Cl.Clda + delta_r*ACSP.COEF.Cl.Cldr;
Cm      = ACSP.COEF.Cm.Cm0 + a*ACSP.COEF.Cm.Cma + (q*ACSP.COEF.Cm.Cmq/Va)*ACSP.MIG.Lref + delta_e*ACSP.COEF.Cm.Cmde + (ACSP.COEF.Cm.Cmh0+a*ACSP.COEF.Cm.Cmha)*exp(-abs(ACSP.COEF.Cm.lambdah*Hlg));
Cn      = (ACSP.COEF.Cn.Cnb0+a*ACSP.COEF.Cn.Cnba)*b + (ACSP.MIG.Lref/Va)*(r*ACSP.COEF.Cn.Cnr+p*(ACSP.COEF.Cn.Cnp0+a*ACSP.COEF.Cn.Cnpa)) + delta_a*ACSP.COEF.Cn.Cnda + delta_r*ACSP.COEF.Cn.Cndr;
Clmn    = [Cl;Cm;Cn];

Ma      = qS*Clmn;
M       = ACSP.MIG.Lref*(MFaero+Ma+Mengine);


% Dynamics

OMdot   = ACSP.MIG.J*(M-cross([p;q;r],ACSP.MIG.I*[p;q;r]));
Vdot    = F*(1/ACSP.MIG.mass)-cross([p;q;r],[u;v;w]);

% Kinematics

PHIdot  = TPHI*[p;q;r];
Xdot    = RB2V*[u;v;w];

% Others
Vg       = Xdot(1);
Vz       = -Xdot(3)+ACSP.MIG.Lref*ACSP.MIG.dxL*q;


dyzILS   = ACSP.MIG.Lref*[RB2V(1,1)*ACSP.MIG.dxGL+RB2V(1,3)*ACSP.MIG.dzGL;...
                          RB2V(2,1)*ACSP.MIG.dxLO+RB2V(2,3)*ACSP.MIG.dzLO;...
                          RB2V(3,1)*ACSP.MIG.dxGL+RB2V(3,3)*ACSP.MIG.dzGL];

dzILS   = (x+dyzILS(1)-ACSP.ILS.xgld)*ACSP.ILS.tanggld-(z+dyzILS(3));
dyILS   = (y+dyzILS(2));
H       = -z+ACSP.RWY.elevation;
Chi     = atan2(Xdot(2),Xdot(1));
sslg    = Chi-Psi;
% Outputs

deriv   = rewrite([Xdot;Vdot;OMdot;PHIdot],'sqrt');
out     = rewrite([Vc;Vg;Vz;dzILS;dyILS;H;Hlg;Nxyz;Va;a;Chi;p;q;r;phi;theta;Psi;Vz;Dlg;Ylg;sslg;b],'sqrt');

end









