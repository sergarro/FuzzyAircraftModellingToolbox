%% Testing Fuzzy Model

clear all;
addpath('c:\Users\cpoh\Desktop\Fuzzy_brusola\CALC')
%addpath('/Users/PBrusola/Google Drive/Beca_col/Fuzzy_brusola/CALC') %Ruta casa
%addpath('CALC')
global ACSP
initACSP;
initALS;

% ----------------------------------------------------------
% SIMULATION #1 : Nominal Case without wind
% ----------------------------------------------------------

clear flightpar
flightpar.MASS=150;
flightpar.XCG=21;
flightpar.VC=2.572+0.5144*max(119*sqrt(flightpar.MASS/140),118);
flightpar.WX=0;
flightpar.altRWY=0;
flightpar.gamRWY=0;
flightpar.T0=15;
flightpar.Z=1500;
flightpar.gamK=-3;
flightpar.gamGLD=-3;
flightpar.dZ=-30;
flightpar.dY=50;
ACStrim(flightpar);

ACSP.X0.QUAT=[cos(ACSP.X0.PHI(1)/2)*cos(ACSP.X0.PHI(2)/2)*cos(ACSP.X0.PHI(3)/2)+...
    sin(ACSP.X0.PHI(1)/2)*sin(ACSP.X0.PHI(2)/2)*sin(ACSP.X0.PHI(3)/2)
    -cos(ACSP.X0.PHI(1)/2)*sin(ACSP.X0.PHI(2)/2)*sin(ACSP.X0.PHI(3)/2)+...
    cos(ACSP.X0.PHI(2)/2)*cos(ACSP.X0.PHI(3)/2)*sin(ACSP.X0.PHI(1)/2)
    cos(ACSP.X0.PHI(1)/2)*cos(ACSP.X0.PHI(3)/2)*sin(ACSP.X0.PHI(2)/2)+...
    sin(ACSP.X0.PHI(1)/2)*cos(ACSP.X0.PHI(2)/2)*sin(ACSP.X0.PHI(3)/2)
    cos(ACSP.X0.PHI(1)/2)*cos(ACSP.X0.PHI(2)/2)*sin(ACSP.X0.PHI(3)/2)-...
    sin(ACSP.X0.PHI(1)/2)*cos(ACSP.X0.PHI(3)/2)*sin(ACSP.X0.PHI(2)/2)];

FuzzyParams_Manual;
dt=1; %sample time
ts=dt; %sample time simulink 
tfin=200;
w=2*pi/13;
tsin=50;
t=(0:dt:tsin);
%% Rates limits
a=[-55 55]*pi/180;
e=[-25 25]*pi/180;
r=[-30 30]*pi/180;
dp=[0.95 1.6];

%% Amplitudes
A=(a(2)-a(1))/2;
E=(e(2)-e(1))/2;
R=(r(2)-r(1))/2;
DP=(dp(2)-dp(1))/2;

%% Translación
tA=(a(2)-ACSP.U0.delta(1))-A;
tE=(e(2)-ACSP.U0.delta(2))-E;
tR=(r(2)-ACSP.U0.delta(1))-R;
tDP=(dp(2)-ACSP.U0.epr)-DP;

%% Desfase
alpha_ep=asin(-tDP/DP);
alpha_a=asin(-tA/A);
alpha_e=asin(-tE/E);
alpha_r=asin(-tR/R);



dr=[0*ones(1,tfin+1)];
ep=[zeros(1,tfin/4) DP*sin(w*t+alpha_ep)+tDP zeros(1,tfin-tfin/4-tsin)];
da=[zeros(1,tfin/2)  A*sin(w*t)  zeros(1,tfin-tfin/2-tsin)];
de=[zeros(1,tfin-tfin/4)  E*sin(w*t) zeros(1,tfin/4-tsin)];

% dr=[R*sin(w*t) 0*ones(1,tfin-tsin)];
% de=[zeros(1,tfin/4) E*sin(w*t) zeros(1,tfin-tfin/4-tsin)];
% da=[zeros(1,tfin/2)  A*sin(w*t)  zeros(1,tfin-tfin/2-tsin)];
% ep=[zeros(1,tfin-tfin/4) DP*sin(w*t+alpha_ep)+tDP zeros(1,tfin/4-tsin)];

% da=[A*sin(w*t) 0*ones(1,tfin-tsin)];
% dr=[zeros(1,tfin/4) R*sin(w*t) zeros(1,tfin-tfin/4-tsin)];
% ep=[zeros(1,tfin/2) DP*sin(w*t+alpha_ep)+tDP  zeros(1,tfin-tfin/2-tsin)];
% de=[zeros(1,tfin-tfin/4) E*sin(w*t) zeros(1,tfin/4-tsin)];

% dr=[R*sin(w*t) 0*ones(1,tfin-tsin)];
% da=[zeros(1,tfin/4) A*sin(w*t) zeros(1,tfin-tfin/4-tsin)];
% ep=[zeros(1,tfin/2) DP*sin(w*t+alpha_ep)+tDP  zeros(1,tfin-tfin/2-tsin)];
% de=[zeros(1,tfin-tfin/4) E*sin(w*t) zeros(1,tfin/4-tsin)];

% ep=[DP*sin(w*t+alpha_ep)+tDP 0*ones(1,tfin-tsin)];
% dr=[zeros(1,tfin/4) R*sin(w*t) zeros(1,tfin-tfin/4-tsin)];
% da=[zeros(1,tfin/2) A*sin(w*t)  zeros(1,tfin-tfin/2-tsin)];
% de=[zeros(1,tfin-tfin/4) E*sin(w*t) zeros(1,tfin/4-tsin)];

t1=(0:dt:tfin);

eprc.time=t1';
eprc.signals.values=ep';
varda.time=t1';
varda.signals.values=da';
varde.time=t1';
varde.signals.values=de';
vardr.time=t1';
vardr.signals.values=dr';

wind=[0,0,0];
ILSnoise=[0,0];

sim('ACS_test');

sim('Modelo_Fuzzy_Manual');

titles.V=[{'Vx'},{'Vy'},{'Vz'}];
figure(1)
for i=1:3
subplot(3,1,i)
plot(tFuzzy,Vfuzzy(:,i),'LineWidth',2)
hold on
plot(tNoLin,Xnolin(:,i),'--','LineWidth',2)
title(titles.V(i))
title(['Comparación de' titles.V(i) 'del modelo fuzzy (linea continua) y del modelo no lineal'])
xlabel('Time [s]')
ylabel([titles.V(i) '[m/s]'])
end

titles.OM=[{'\Omega_x'},{'\Omega_y'},{'\Omega_z'}];
figure(2)
for i=1:3
subplot(3,1,i)
plot(tFuzzy,OMfuzzy(:,i),'LineWidth',2)
hold on
plot(tNoLin,Xnolin(:,3+i),'--','LineWidth',2)
title(['Comparación de',titles.OM(i),'del modelo fuzzy (linea continua) y del modelo no lineal'])
xlabel('Time [s]')
ylabel([titles.OM(i) '[rad/s]'])
end

titles.X=[{'X'},{'Y'},{'Z'}];
figure(3)
for i=1:3
subplot(3,1,i)
plot(tFuzzy,Xfuzzy(:,i),'LineWidth',2)
hold on
plot(tNoLin,Xnolin(:,6+i),'--','LineWidth',2)
title(['Comparación de',titles.X(i),'del modelo fuzzy (linea continua) y del modelo no lineal'])
xlabel('Time [s]')
ylabel([titles.X(i) 'm'])
end

titles.PHI=[{'\phi'},{'\theta'},{'\psi'}];
figure(4)
for i=1:3
subplot(3,1,i)
plot(tFuzzy,phifuzzy(:,i),'LineWidth',2)
hold on
plot(tNoLin,Xnolin(:,9+i),'--','LineWidth',2)
title(['Comparación de',titles.PHI(i),'del modelo fuzzy (linea continua) y del modelo no lineal'])
xlabel('Time [s]')
ylabel([titles.PHI(i) '[rad]'])
end

