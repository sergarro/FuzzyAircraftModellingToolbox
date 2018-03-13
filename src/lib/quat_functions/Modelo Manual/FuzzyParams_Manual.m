%% Load Fuzzy (max & min) Parameters

%% Drag coeficient (SISO)
ParamFuzzy.CD.min=-pi/2;
ParamFuzzy.CD.max=pi/2;
%% Lif Coeficient

% Due to q & Va
ParamFuzzy.CL1.min=1;
ParamFuzzy.CL1.max=-1;
% Ground effect
ParamFuzzy.CL2.min=0;
ParamFuzzy.CL2.max=30000;

%% Roll moment coeficient

%Due to p & Va
ParamFuzzy.Cl1.min=-1;
ParamFuzzy.Cl1.max=1;

%Due to r, Va & alpha
ParamFuzzy.Cl2.min=[-1,-pi/2];
ParamFuzzy.Cl2.max=[1,pi/2];

%% Pitch moment coeficient
% Due to q & Va
ParamFuzzy.Cm1.min=-1;
ParamFuzzy.Cm1.max=1;

% Ground effect

ParamFuzzy.Cm2.min=[0, -pi/2];
ParamFuzzy.Cm2.max=[30000,pi/2];
                    
%% Yaw moment coeficient

% due to r & Va
ParamFuzzy.Cn1.min=-1;
ParamFuzzy.Cn1.max=1;

% due to Va, alpha & p

ParamFuzzy.Cn2.min=[-1,-pi/2];
ParamFuzzy.Cn2.max=[1,pi/2];

% due to alpha & beta
ParamFuzzy.Cn3.min=[-pi/2, -pi/2];
ParamFuzzy.Cn3.max=[pi/2, pi/2];

