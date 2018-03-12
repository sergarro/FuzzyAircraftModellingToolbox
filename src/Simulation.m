function Simulation( src,event )
global Strings
load('../data/CurrentVars')
addpath('../bin')
addpath('../bin/SolveODEs','../bin/quat_functions')
simbar = waitbar(0,'Simulating...');
OM0=[var.p0,var.q0,var.r0];
V0=[var.u0,var.v0,var.w0];
PHI0=[var.phi0,var.theta0,var.psi0];
X0=[var.x0,var.y0,var.z0];
epr0=[var.dp0];
delta0=[var.da0,var.de0,var.dr0];
initcond=[OM0,V0,PHI0,X0];

Quat0=[cos(PHI0(1)/2)*cos(PHI0(2)/2)*cos(PHI0(3)/2)+...
    sin(PHI0(1)/2)*sin(PHI0(2)/2)*sin(PHI0(3)/2)
    -cos(PHI0(1)/2)*sin(PHI0(2)/2)*sin(PHI0(3)/2)+...
    cos(PHI0(2)/2)*cos(PHI0(3)/2)*sin(PHI0(1)/2)
    cos(PHI0(1)/2)*cos(PHI0(3)/2)*sin(PHI0(2)/2)+...
    sin(PHI0(1)/2)*cos(PHI0(2)/2)*sin(PHI0(3)/2)
    cos(PHI0(1)/2)*cos(PHI0(2)/2)*sin(PHI0(3)/2)-...
    sin(PHI0(1)/2)*cos(PHI0(3)/2)*sin(PHI0(2)/2)];

initcondf=[OM0,V0,Quat0',X0];
waitbar(0.1);
for i=1:length(Strings.ButtonNames)
    if(strcmp(Strings.ButtonNames{i},'coef'))
       for j=1:length(Strings.coef.labels)
          for k = 1:length(Strings.coef.(Strings.coef.labels{j}).labels)
             param.coef.(Strings.coef.(Strings.coef.labels{j}).labels{k}) = ...
                 var.(Strings.coef.(Strings.coef.labels{j}).labels{k});
          end
       end
    else
       for j=1:length(Strings.(Strings.ButtonNames{i}).labels)
           param.(Strings.ButtonNames{i}).(Strings.(Strings.ButtonNames{i}).labels{j}) = ...
               var.(Strings.(Strings.ButtonNames{i}).labels{j});
       end
    end
end
waitbar(0.3);
param.act.tau = [var.a_tau,var.e_tau,var.r_tau];
param.act.RL = [var.a_RL,var.e_RL,var.r_RL];
param.act.ML = [var.a_ML,var.e_ML, var.r_ML];
param.mig.I    = [var.Ixx 0 var.Ixz ; 0 var.Iyy 0 ; var.Ixz 0 var.Izz];
param.mig.J    = inv(param.mig.I);
param.rwy.elevation = 0;
aleron=StepAct(var.simtime,var.Aileron_Steptime,var.Aileron_Step_Duration,...
               var.Aileron_Amplitude*pi/180);
elevador=StepAct(var.simtime,var.Elevator_Steptime,var.Elevator_Step_Duration,...
               var.Elevator_Amplitude*pi/180);
rudder=StepAct(var.simtime,var.Rudder_Steptime,var.Rudder_Step_Duration,...
               var.Rudder_Amplitude*pi/180);
palanca=StepAct(var.simtime,var.Throttle_Steptime,var.Throttle_Step_Duration,...
               var.Throttle_Amplitude);
           
delta_1=[aleron.Data,elevador.Data,rudder.Data];
ep=palanca.Data;
t1=aleron.Time;
waitbar(0.5);
param.waitbar = 1;
param.tf = t1(end);
tm=(t1(1):0.05:t1(end))';
[delta]=ode1(@actuators,t1(1),0.05,t1(end),[0,0,0],t1,delta_1,param)+...
    [delta0(1)*ones(length(tm),1),delta0(2)*ones(length(tm),1),delta0(3)*ones(length(tm),1)];
epr=ode1(@engines,t1(1),0.05,t1(end),0,t1,ep,param)+epr0*ones(length(tm),1);

W=zeros(3,length(epr));
input_u=[epr,delta,W'];

load('../data/FuzzyVars')
param.FIS = FIS;
param.FIS.a = FIS.alpha;
param.FIS.b = FIS.beta;
waitbar(0.7);
Yf=ode1(@dFuzzyModeldt,t1(1),0.05,t1(end),initcondf,tm,input_u,param);
Q=Yf(:,7:10);
[phi,theta,psi]=Quat2Euler(Q);
Yf1=[Yf(:,1:6),phi,theta,psi,Yf(:,11:end)];
waitbar(1);
close(simbar);

save('../data/SimResults','Yf1','input_u','tm')

end

