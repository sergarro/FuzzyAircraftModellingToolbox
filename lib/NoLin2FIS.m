function [ FIS ] = NoLin2FIS(param)
%% Description
% This function return a FIS struct with all the non-linearities of the
% classic model transformed on fuzzy models.
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
%param.dim : aircraft dimension parameters 
            % mig.Sref
            % mig.L
%param.lim : variable struct with inputs maximum and minimums. Every
%struct should be an 1x2 vector, where first column is the maximun and the
%second the minimum.
    %alpha --> lim.a
    %beta  --> lim.b
    %p/Va  --> lim.pVa
    %q/Va  --> lim.qVa
    %r/Va  --> lim.rVa
    %Va^2    --> lim.Va2
    %Vaz/Vax   --> lim.VazVax
    %Vay/Va   --> lim.VayVa
    %Hlg   --> lim.Hlg
    
%% Output
%FIS: struct with fuzzy model parameters.
      %mf --> membership functions
      %c  --> consecuent
      %r  --> number of rules
%% Code
param=DefaultMaxMin(param);
%% Angle of attack
%a=atan(Vaz/Vax)
FIS.alpha.mf=[1,param.lim.alpha(1),param.lim.alpha(2)
          4,param.lim.VazVax(1),param.lim.VazVax(2)];
FIS.alpha.c=[{'constant'},1*param.lim.VazVax(1)
         {'constant'},1*param.lim.VazVax(2)
         {'constant'},0
         {'constant'},0];
FIS.alpha.r=4;
%% Beta
%b=asin(Vay/Va)
FIS.beta.mf=[2,param.lim.beta(1),param.lim.beta(2)
          4,param.lim.VayVa(1),param.lim.VayVa(2)];
FIS.beta.c=[{'constant'},param.lim.beta(1)*param.lim.VayVa(1)
         {'constant'},param.lim.beta(1)*param.lim.VayVa(2)
         {'constant'},1*param.lim.VayVa(1)
         {'constant'},1*param.lim.VayVa(2)];
FIS.beta.r=4;
%% Va=sqrt(Vax^2+Vay^2+Vaz^2)
FIS.Va.mf=[3,param.lim.Va2(1),0];
FIS.Va.c=[{'constant'},param.lim.Va2(1)
          {'constant'},0];
FIS.Va.r=2;      
%% Lift Coeficients
%CL1=L/Va*CLq*q
FIS.CL1.mf=[4, param.lim.qVa(1), param.lim.qVa(2)];
FIS.CL1.c=[{'constant'},param.mig.Lref*param.coef.CLq*param.lim.qVa(1)
            {'constant'},param.mig.Lref*param.coef.CLq*param.lim.qVa(2)];
FIS.CL1.r=2;

%CL2=CLh*e^(-lambdal*Hlg)
FIS.CL2.mf=[5, exp(-param.coef.lambdal*param.lim.Hlg(2)),exp(-param.coef.lambdal*param.lim.Hlg(1))];
FIS.CL2.c=[{'lineal'}, param.coef.CLh*(-1),param.coef.CLh*1
            {'lineal'},0,0];
FIS.CL2.r=2;

%% Drag Coeficients
%CD2=CDa2*a^2
FIS.CD2.mf=[6,param.lim.alpha(1),param.lim.alpha(2)];
FIS.CD2.c=[{'lineal'},param.coef.CDa2*param.lim.alpha(1),0
           {'lineal'},param.coef.CDa2*param.lim.alpha(2),0];
FIS.CD2.r=2;

%% Roll Coeficients
%Cl1=L/Va*Clp*p
FIS.Cl1.mf=[4, param.lim.pVa(1), param.lim.pVa(2)];
FIS.Cl1.c=[{'constant'},param.mig.Lref*param.coef.Clp*param.lim.pVa(1)
            {'constant'},param.mig.Lref*param.coef.Clp*param.lim.pVa(2)];
FIS.Cl1.r=2;

%Cl2=L/Va*r*(Clr0+Clra*a)
FIS.Cl2.mf=[4, param.lim.pVa(1), param.lim.pVa(2)
            7,param.lim.alpha(1),param.lim.alpha(2)];
FIS.Cl2.c=[{'constant'}, param.mig.Lref*param.lim.pVa(1)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.alpha(1))
           {'constant'}, param.mig.Lref*param.lim.pVa(1)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.alpha(2))
           {'constant'}, param.mig.Lref*param.lim.pVa(2)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.alpha(1))
           {'constant'}, param.mig.Lref*param.lim.pVa(2)*...
                            (param.coef.Clr0+param.coef.Clra*param.lim.alpha(2))];
FIS.Cl2.r=4;

%% Pitch Coeficients
%Cm1=L/Va*Cmq*q
FIS.Cm1.mf=[4, param.lim.qVa(1), param.lim.qVa(2)];
FIS.Cm1.c=[{'constant'},param.mig.Lref*param.coef.Cmq*param.lim.qVa(1)
            {'constant'},param.mig.Lref*param.coef.Cmq*param.lim.qVa(2)];
FIS.Cm1.r=2;

%Cm2=(Cmh0+Cmha*a)e^(-lambdam).Hlg
FIS.Cm2.mf=[5, exp(-param.coef.lambdam*param.lim.Hlg(2)),exp(-param.coef.lambdam*param.lim.Hlg(1))
            7,param.lim.alpha(1),param.lim.alpha(2)];
FIS.Cm2.c=[{'lineal'},(param.coef.Cmh0+param.coef.Cmha*param.lim.alpha(1))*(-1),...
                            (param.coef.Cmh0+param.coef.Cmha*param.lim.alpha(1))*(1)
           {'lineal'},(param.coef.Cmh0+param.coef.Cmha*param.lim.alpha(2))*(-1),...
                            (param.coef.Cmh0+param.coef.Cmha*param.lim.alpha(2))*(1)
           {'lineal'},0,0
           {'lineal'},0,0];
FIS.Cm2.r=4;

%% Yaw coeficients
%Cn1=L/Va*Cnr*r
FIS.Cn1.mf=[4, param.lim.rVa(1), param.lim.rVa(2)];
FIS.Cn1.c=[{'constant'},param.mig.Lref*param.coef.Cnr*param.lim.rVa(1)
           {'constant'},param.mig.Lref*param.coef.Cnr*param.lim.rVa(2)];
FIS.Cn1.r=2;

%Cn2=L/Va*p*(Cnp0+Cnpa*a)
FIS.Cn2.mf=[4, param.lim.pVa(1), param.lim.pVa(2)
            7,param.lim.alpha(1),param.lim.alpha(2)];
FIS.Cn2.c=[{'constant'}, param.mig.Lref*param.lim.pVa(1)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.alpha(1))
           {'constant'}, param.mig.Lref*param.lim.pVa(1)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.alpha(2))
           {'constant'}, param.mig.Lref*param.lim.pVa(2)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.alpha(1))
           {'constant'}, param.mig.Lref*param.lim.pVa(2)*...
                            (param.coef.Cnp0+param.coef.Cnpa*param.lim.alpha(2))];
FIS.Cn2.r=4;

%Cn3=(Cnb0+Cnba*a)*b
FIS.Cn3.mf=[4,param.lim.beta(1),param.lim.beta(2)
            7,param.lim.alpha(1),param.lim.alpha(2)];
FIS.Cn3.c=[{'constant'},param.lim.beta(1)*(param.coef.Cnb0+param.coef.Cnba*param.lim.alpha(1))
           {'constant'},param.lim.beta(1)*(param.coef.Cnb0+param.coef.Cnba*param.lim.alpha(2))
           {'constant'},param.lim.beta(2)*(param.coef.Cnb0+param.coef.Cnba*param.lim.alpha(1))
           {'constant'},param.lim.beta(2)*(param.coef.Cnb0+param.coef.Cnba*param.lim.alpha(2))];
FIS.Cn3.r=4;
end

