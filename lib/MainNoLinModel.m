
%% Description
%Aircraft No Lineal Model.
addpath('SolveODEs')
%% Code

%% Trim values
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
flightpar.Z=5000;
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
disp('Initializing parameters...')
%% Initialize parameters
param = ParamsInput( flightpar.MASS,flightpar.XCG,flightpar.altRWY,flightpar.T0);
disp('OK')
%% Inputs simulation
disp('Initializing inputs values...')
dt=1; %sample time
ts=dt; %sample time simulink 
tfin=200;
w=2*pi/13;
tsin=25;
ts=(0:dt:tsin);

%Rates limits
a=[-55 55]*pi/180;
e=[-25 25]*pi/180;
r=[-30 30]*pi/180;
dp=[0.95 1.6];

%Amplitudes
A=(a(2)-a(1))/2;
E=(e(2)-e(1))/2;
R=(r(2)-r(1))/2;
DP=(dp(2)-dp(1))/2;

%Translación
tA=(a(2)-delta0(1))-A;
tE=(e(2)-delta0(2))-E;
tR=(r(2)-delta0(1))-R;
tDP=(dp(2)-epr0)-DP;

% Desfase
alpha_ep=asin(-tDP/DP);
alpha_a=asin(-tA/A);
alpha_e=asin(-tE/E);
alpha_r=asin(-tR/R);

dr=[zeros(1,tfin/4) R*sin(w*ts) zeros(1,tfin-tfin/4-tsin)];
ep=[DP*sin(w*ts+alpha_ep)+tDP 0*ones(1,tfin-tsin)];
da=[zeros(1,tfin/2) A*sin(w*ts)  zeros(1,tfin-tfin/2-tsin)];
de=[zeros(1,tfin-tfin/4) E*sin(w*ts) zeros(1,tfin/4-tsin)];
delta_1=[da',de',dr'];
t1=(0:dt:tfin);
disp('OK')
disp('Calculating actuators response')
tm=(t1(1):0.05:t1(end))';
[delta]=ode1(@actuators,t1(1),0.05,t1(end),[0,0,0],t1',delta_1,param)+...
    [delta0(1)*ones(length(tm),1),delta0(2)*ones(length(tm),1),delta0(3)*ones(length(tm),1)];
epr=ode1(@engines,t1(1),0.05,t1(end),0,t1',ep',param)+epr0*ones(length(tm),1);
W=zeros(3,length(epr));
input_u=[epr,delta,W'];
%% Differential Equation Solution
disp('Calculating Diferential equation solution...')
param.FIS=NoLin2FIS(param);
Ym=ode1(@dNoLindt,t1(1),0.05,t1(end),initcond,tm,input_u,param);
disp('¡Solution Success!')

%% Ploting results
% subplot(2,1,1)
% plot(tm,Ym(:,8))
% subplot(2,1,2)
% plot(tm,input_u(:,1:4))

plot(tident,va)
hold on
plot(tident,fua,'--')