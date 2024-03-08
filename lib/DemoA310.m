%% A310 Demo

%% Adding solvers and quaternions functions
addpath('SolveODEs','quat_functions')

%% Calculating trim values (for the initial conditions)
clc; clear all;
syms x y z u v w p q r phi theta Psi real; 
syms epr delta_a delta_e delta_r Windx Windy Windz real;
syms MASS XCG gamGLD T0 WX altRWY gamRWY real;

states = [x y z u v w p q r phi theta Psi];
inputs = [epr delta_a delta_e delta_r Windx Windy Windz];
flight = [MASS XCG gamGLD T0 WX altRWY gamRWY];
disp('Loading Model...')
[deriv,out] = modelo;
disp('Model Loaded')
clear flightpar
flightpar.MASS=150;
flightpar.XCG=21;
flightpar.VC=2.572+0.5144*max(119*sqrt(flightpar.MASS/140),118);
flightpar.WX=0;
flightpar.altRWY=0;
flightpar.gamRWY=0;
flightpar.T0=15;
flightpar.Z=500;
flightpar.gamK=-3;
flightpar.gamGLD=-3;
flightpar.dZ=-30;
flightpar.dY=50;


disp('Calculating Trim Values...')
p_eq = eq_point(deriv,out,flightpar,states,inputs,flight);
OM0=p_eq(7:9);
V0=p_eq(4:6);
PHI0=p_eq(10:12);
X0=p_eq(1:3);
epr0=p_eq(13);
delta0=p_eq(14:16);
disp('OK')
varinit='p q r u v w phi theta psi x y z epr0 da de dr';
initcond=[OM0,V0,PHI0,X0];%epr0,delta0];
printmat([initcond,epr0,delta0], 'Init_Values','var0',varinit) ;

Quat0=[cos(PHI0(1)/2)*cos(PHI0(2)/2)*cos(PHI0(3)/2)+...
    sin(PHI0(1)/2)*sin(PHI0(2)/2)*sin(PHI0(3)/2)
    -cos(PHI0(1)/2)*sin(PHI0(2)/2)*sin(PHI0(3)/2)+...
    cos(PHI0(2)/2)*cos(PHI0(3)/2)*sin(PHI0(1)/2)
    cos(PHI0(1)/2)*cos(PHI0(3)/2)*sin(PHI0(2)/2)+...
    sin(PHI0(1)/2)*cos(PHI0(2)/2)*sin(PHI0(3)/2)
    cos(PHI0(1)/2)*cos(PHI0(2)/2)*sin(PHI0(3)/2)-...
    sin(PHI0(1)/2)*cos(PHI0(3)/2)*sin(PHI0(2)/2)];
initcondf=[OM0,V0,Quat0',X0];
disp('Initializing parameters...')
%% Initialize parameters
param = ParamsInput( flightpar.MASS,flightpar.XCG,flightpar.altRWY,flightpar.T0);
disp('OK')
%% Inputs simulation
disp('Initializing inputs values...')
dt=1; %sample time
tfin=20;
aleron=StepAct(tfin,[1,7,12,15],[2,2,2,2],...
    [10*pi/180,-5*pi/180,-10*pi/180,10*pi/180]);
elevador=StepAct(tfin,[2,5,10,14],[2,2,2,2],...
    [15*pi/180,-10*pi/180,-15*pi/180,5*pi/180]);
rudder=StepAct(tfin,[3,6,13,16],[2,2,2,2],...
    [20*pi/180,0*pi/180,-10*pi/180,10*pi/180]);
palanca=StepAct(tfin,4,8,...
    0.4);
delta_1=[aleron.Data,elevador.Data,rudder.Data];
ep=palanca.Data;
t1=aleron.Time;
disp('OK')
disp('Calculating actuators response')
tm=(t1(1):0.05:t1(end))';
[delta]=ode1(@actuators,t1(1),0.05,t1(end),[0,0,0],t1,delta_1,param)+...
    [delta0(1)*ones(length(tm),1),delta0(2)*ones(length(tm),1),delta0(3)*ones(length(tm),1)];
epr=ode1(@engines,t1(1),0.05,t1(end),0,t1,ep,param)+epr0*ones(length(tm),1);
W=zeros(3,length(epr));
input_u=[epr,delta,W'];
%% Fuzzy Modeling
disp('Calculating fuzzy paramters model')
param.FIS=NoLin2FIS(param);
param.FIS.a = param.FIS.alpha;
param.FIS.b = param.FIS.beta;
disp('Done')
%% Differential Equation Solution
disp('Calculating classic Diferential equation solution...')
Ym=ode1(@dNoLindt,t1(1),0.05,t1(end),initcond,tm,input_u,param);
disp('¡Solution Success!')
disp('Calculating Defuzzyfication for the validation...')
Yf=ode1(@dFuzzyModeldt,t1(1),0.05,t1(end),initcondf,tm,input_u,param);
disp('¡Solution Success!')
disp('Ploting validation results')

Q=Yf(:,7:10);
[phi,theta,psi]=Quat2Euler(Q);
%% Ploting results
yaxis=[{'p (rad/s)'},{'q (rad/s)'},{'r (rad/s)'},{'u (m/s)'},{'v (m/s)'}...
    ,{'w (m/s)'},{'\phi (rad)'},{'\theta (rad)'}, {'\psi (rad)'}, {'X (m)'}...
    , {'Y (m)'}, {'Z (m)'}];
Yf1=[Yf(:,1:6),phi,theta,psi,Yf(:,11:end)];
%% Ploting data validation
figure
title('Data validation')
for i=1:6
subplot(3,2,i)
plot(tm,Ym(:,i))
hold on
plot(tm,Yf1(:,i),'--')
ylabel(yaxis{i})
xlabel('Time (s)')
legend('Non-lineal model','Fuzzy model')
end

figure
title('Data validation')
for i=1:6
subplot(3,2,i)
plot(tm,Ym(:,i+6))
hold on
plot(tm,Yf1(:,i+6),'--')
ylabel(yaxis{i+6})
xlabel('Time (s)')
legend('Non-lineal model','Fuzzy model')
end

%% Ploting inputs
figure
title('Actuators and engine inputs')
plot(tm,input_u(:,1:4))
xlabel('Time (s)')
legend('EPR','Aileron','Elevators','Rudders')

%% Ploting membership functions
fisnames=fieldnames(param.FIS);
for i=1:length(fieldnames(param.FIS))
figure
mfplot(param.FIS.(fisnames{i}).mf,fisnames{i})
end
VAF=zeros(12,1);
for i=1:12
VAF(i)=diag(100*(eye(size(Ym(:,i),2))-cov(Ym(:,i)-Yf1(:,i))./cov(Ym(:,i))));
end
vars={'p','q','r','u','v','w','phi','theta','psi','X','Y','Z'};
table(VAF,'RowNames',vars')