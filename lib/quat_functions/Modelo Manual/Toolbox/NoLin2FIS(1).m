function [ FIS ] = NoLin2FIS(param)
%% Description

%% Input
%param.coef : variable struct with aerodinamic forces coeficients
    %Lift --> coef.CL0, coef.CLa, coef.CLq, coef.CLde, coef.CLh,
    %coef.lambdal
    %Drag --> coef.CD0, coef.CDa, coef.CDa2
    %Lateral --> coef.CYb, coef.CYdr
    %Roll --> coef.Clb, coef.Clp, coef.Clr0, coef.Clra, coef.Clda
    %         coef.Cldr
    %Pitch --> coef.Cm0, coef.Cma, coef.Cmq, coef.Cmde, coef.Cmh0
    %          coef.Cmha, coef.lambdam
    %Yaw  -->  coef.Cnb0, coef.Cnba, coef.Cnp0, coef.Cnpa, coef.Cnr
    %          coef.Cnda, coef.Cndr
%param.wind : wind.Va=[Vax, Vay, Vaz] : Airspeed components
%param.dim : aircraft dimension parameters 
            % dim.Sref
            % dim.L
%param.lim : variable struct with inputs maximum and minimums. Every
%struct should be an 1x2 vector, where first column is the maximun and the
%second the minimum.
    %alpha --> lim.a
    %beta  --> lim.b
    %p,q,r --> lim.p,lim.q,lim.r
    %Va    --> lim.Va
    %Vax   --> lim.Vax
    %Vay   --> lim.Vay
    %Vaz   --> lim.Vaz
    %Hlg   --> lim.Hlg
    
%% Output
%FIS: struct with fuzzy model parameters.
      %mf --> membership functions
      %c  --> consecuent
      %r  --> number of rules
%% Code
%% Angle of attack
%a=atan(Vaz/Vax)
FIS.a.mf=[1,param.lim.Vaz(1)/abs(param.Vax(2)),0
          4,param.lim.Vaz(1)/abs(param.Vax(2)),param.lim.Vaz(2)/param.Vax(2) ];
FIS.a.c=['constant',param.lim.Vaz(1)/abs(param.Vax(2))
         'constant',param.lim.Vaz(2)/param.Vax(2)
         'constant',param.lim.Vaz(1)/abs(param.Vax(2)*pi/(2*param.lim.Vaz(1)/abs(param.Vax(2))))
         'constant',param.lim.Vaz(2)/param.Vax(2)*pi/(2*param.lim.Vaz(1)/abs(param.Vax(2)))];
FIS.a.r=4;
%% Beta
%b=asin(Vay/Va)
%% Lift Coeficients
%CL1=L/Va*CLq*q
FIS.CL1.mf=[4, param.lim.q(1)/param.lim.Va(2), param.lim.q(2)/param.lim.Va(1)];
FIS.CL1.c=['constant',param.dim.L*param.coef.CLq*param.lim.q(1)/param.lim.Va(2)
            'constant',param.dim.L*param.coef.CLq*param.lim.q(2)/param.lim.Va(1)];
FIS.CL1.r=2;

%CL2=CLh*e^(-lambdal*Hlg)
FIS.CL2.mf=[5, param.coef.lambdal*param.lim.Hlg(1),0];
FIS.CL2.c=['lineal',param.coef.CLh*(-1/param.lim.Hlg(1)),param.coef.CLh*1
            'lineal',param.coef.lambdal*param.coef.CLh*(-1),param.coef.CLh*1];
FIS.CL2.r=2;

%% Drag Coeficients
%CD2=CDa2*a^2
FIS.CD2.mf=[4,param.lim.a(1),param.lim.a(2)];
FIS.CD2.c=['lineal',param.coef.CDa2*param.lim.a(1),0
           'lineal',param.coef.CDa2*param.lim.a(2),0];
FIS.CD2.r=2;

%% Roll Coeficients
%Cl1=L/Va*Clp*p
FIS.Cl1.mf=[4, param.lim.p(1)/param.lim.Va(2), param.lim.p(2)/param.lim.Va(1)];
FIS.Cl1.c=['constant',param.dim.L*param.coef.Clp*param.lim.p(1)/param.lim.Va(2)
            'constant',param.dim.L*param.coef.Clp*param.lim.p(2)/param.lim.Va(1)];
FIS.Cl1.r=2;

%Cl2=L/Va*r*(Clr0+Clra*a)
FIS.Cl2.mf=[4, param.lim.p(1)/param.lim.Va(2), param.lim.p(2)/param.lim.Va(1)
            4,param.lim.a(1),param.lim.a(2)];
FIS.Cl2.c=['constant', param.dim.L*param.lim.p(1)/param.lim.Va(2)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.a(1))
           'constant', param.dim.L*param.lim.p(1)/param.lim.Va(2)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.a(2))
           'constant', param.dim.L*param.lim.p(2)/param.lim.Va(1)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.a(1))
           'constant', param.dim.L*param.lim.p(2)/param.lim.Va(1)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.a(2))];
FIS.Cl2.r=4;

%% Pitch Coeficients
%Cm1=L/Va*Cmq*q
FIS.Cm1.mf=[4, param.lim.q(1)/param.lim.Va(2), param.lim.q(2)/param.lim.Va(1)];
FIS.Cm1.c=['constant',param.dim.L*param.coef.Cmq*param.lim.q(1)/param.lim.Va(2)
            'constant',param.dim.L*param.coef.Cmq*param.lim.q(2)/param.lim.Va(1)];
FIS.Cm1.r=2;

%Cm2=(Cmh0+Cmha*a)e^(-lambdam).Hlg
FIS.Cm2.mf=[5, param.coef.lambdam*param.lim.Hlg(1),0
            4,param.lim.a(1),param.lim.a(2)];
FIS.Cm2.c=['lineal',(param.coef.Cmh0+param.coef.Cmha*param.lim.a(1))*(-1/param.lim.Hlg(1)),...
                            (param.coef.Cmh0+param.coef.Cmha*param.lim.a(1))*(1)
           'lineal',(param.coef.Cmh0+param.coef.Cmha*param.lim.a(2))*(-1/param.lim.Hlg(1)),...
                            (param.coef.Cmh0+param.coef.Cmha*param.lim.a(2))*(1)
           'lineal',(param.coef.Cmh0+param.coef.Cmha*param.lim.a(1))*(-1),...
                            (param.coef.Cmh0+param.coef.Cmha*param.lim.a(1))*(1)
           'lineal',(param.coef.Cmh0+param.coef.Cmha*param.lim.a(2))*(-1),...
                            (param.coef.Cmh0+param.coef.Cmha*param.lim.a(2))*(1)];
FIS.Cm2.r=4;

%% Yaw coeficients
%Cn1=L/Va*Cnr*r
FIS.Cm1.mf=[4, param.lim.r(1)/param.lim.Va(2), param.lim.r(2)/param.lim.Va(1)];
FIS.Cm1.c=['constant',param.dim.L*param.coef.Cnr*param.lim.r(1)/param.lim.Va(2)
            'constant',param.dim.L*param.coef.Cnr*param.lim.r(2)/param.lim.Va(1)];
FIS.Cm1.r=2;

%Cn2=L/Va*p*(Cnp0+Cnpa*a)
FIS.Cn2.mf=[4, param.lim.p(1)/param.lim.Va(2), param.lim.p(2)/param.lim.Va(1)
            4,param.lim.a(1),param.lim.a(2)];
FIS.Cn2.c=['constant', param.dim.L*param.lim.p(1)/param.lim.Va(2)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.a(1))
           'constant', param.dim.L*param.lim.p(1)/param.lim.Va(2)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.a(2))
           'constant', param.dim.L*param.lim.p(2)/param.lim.Va(1)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.a(1))
           'constant', param.dim.L*param.lim.p(2)/param.lim.Va(1)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.a(2))];
FIS.Cn2.r=4;

%Cn3=(Cnb0+Cnba*a)*b
FIS.Cn3.mf=[4,param.lim.b(1),param.lim.b(2)
            4,param.lim.a(1),param.lim.a(2)];
FIS.Cn3.c=['constant',param.lim.b(1)*(param.coef.Cnb0+param.coef.Cnba*param.lim.a(1))
           'constant',param.lim.b(1)*(param.coef.Cnb0+param.coef.Cnba*param.lim.a(2))
           'constant',param.lim.b(2)*(param.coef.Cnb0+param.coef.Cnba*param.lim.a(1))
           'constant',param.lim.b(2)*(param.coef.Cnb0+param.coef.Cnba*param.lim.a(2))];
end

