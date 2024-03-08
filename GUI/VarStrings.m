%% Strings

Strings.ButtonNames=[{'mig'},{'coef'},{'atm'},...
    {'eng'},{'act'}];

Strings.PanelTitles=[{'Mass and Geometry'},...
                     {'Aerodynamic Coefficients'},...
                     {'Atmosphere'},...
                     {'Engines'},...
                     {'Actuators'}];
                 
Strings.mig.labels = [{'Sref'},{'Lref'},{'Mass'},...
    {'Ixx'},{'Iyy'},{'Izz'},{'Ixz'},{'XCG'},{'dxg'},{'dze'}];
Strings.mig.units = [{'m^2'},{'m'},{'kg'},...
    {'kg.m^2'},{'kg.m^2'},{'kg.m^2'},{'kg.m^2'},{'m'},{'m'},{'m'}];

Strings.coef.labels = [{'Lift'},{'Lat'},{'Drag'},{'Roll'},{'Pitch'},{'Yaw'}];
Strings.coef.Lift.labels = [{'CL0'},{'CLa'},{'CLq'},{'CLh'},{'lambdal'},{'CLde'}];
Strings.coef.Lift.units = [{'-'},{'-'},{'-'},{'-'},{'-'},{'-'}];
Strings.coef.Lat.labels = [{'CYb'},{'CYdr'}];
Strings.coef.Lat.units = [{'-'},{'-'}];
Strings.coef.Drag.labels = [{'CD0'},{'CDa'},{'CDa2'}];
Strings.coef.Drag.units = [{'-'},{'-'},{'-'},{'-'},{'-'},{'-'}];
Strings.coef.Roll.labels = [{'Clb'},{'Clp'},{'Clr0'},{'Clra'},{'Clda'},{'Cldr'}];
Strings.coef.Roll.units = [{'-'},{'-'},{'-'},{'-'},{'-'},{'-'}];
Strings.coef.Pitch.labels = [{'Cm0'},{'Cma'},{'Cmq'},{'Cmh0'},{'Cmha'},{'lambdam'},{'Cmde'}];
Strings.coef.Pitch.units = [{'-'},{'-'},{'-'},{'-'},{'-'},{'-'},{'-'}];
Strings.coef.Yaw.labels = [{'Cnb0'},{'Cnba'},{'Cnp0'},{'Cnpa'},{'Cnr'},{'Cnda'},{'Cndr'}];
Strings.coef.Yaw.units = [{'-'},{'-'},{'-'},{'-'},{'-'},{'-'},{'-'}];

Strings.atm.labels = [{'T0'},{'rho_0'},{'T_rwy'},{'va2vc'},{'va2M'},{'alt'}];
Strings.atm.units = [{'K'},{'kg/m^3'},{'K'},{'-'},{'-'},{'m'}];

Strings.eng.labels = [{'Ga'},{'Gb'},{'tau'},{'UML'},{'LML'},{'RL'}];
Strings.eng.units = [{'-'},{'-'},{'s'},{'-'},{'-'},{'s^-1'}];

Strings.act.labels = [{'a_tau'},{'a_ML'},{'a_RL'}...
                      {'e_tau'},{'e_ML'},{'e_RL'}...
                      {'r_tau'},{'r_ML'},{'r_RL'}];
Strings.act.units = [{'s'},{'º'},{'º/s'},...
                     {'s'},{'º'},{'º/s'},...
                     {'s'},{'º'},{'º/s'}];
                 
Strings.fuzzylim.labels = [{'alpha'},{'beta'},{'pVa'},{'qVa'},{'rVa'},...
                           {'Va2'},{'VazVax'},{'VayVa'},{'Hlg'}];
Strings.fuzzylim.units = [{'rad'},{'rad'},{'rad/m'},{'rad/m'},{'rad/m'},...
                           {'m^2/s^2'},{'-'},{'-'},{'m'}];
                       
Strings.StatesVar.labels = [{'p'},{'q'},{'r'},{'u'},{'v'},{'w'},{'phi'},...
                            {'theta'},{'psi'},{'X'},{'Y'},{'Z'}];
Strings.StatesVar.units = [{'rad/s'},{'rad/s'},{'rad/s'},{'m/s'},{'m/s'},{'m/s'},{'rad'},...
                            {'rad'},{'rad'},{'m'},{'m'},{'m'}];  
              
Strings.mf.labels = [{'alpha'},{'beta'},{'Va'},{'CL1'},{'CL2'},{'CD2'},{'Cl1'},...
                     {'Cl2'},{'Cm1'},{'Cm2'},{'Cn1'},{'Cn2'},{'Cn3'}];

Strings.statevars.labels = [{'X'},{'Y'},{'Z'},{'u'},{'v'},{'w'},{'p'},{'q'},...
                            {'r'},{'phi'},{'theta'},{'psi'}];
Strings.statevars.units = [{'m'},{'m'},{'m'},{'m/s'},{'m/s'},{'m/s'},{'rad/s'},{'rad/s'},...
                            {'rad/s'},{'rad'},{'rad'},{'rad'}];
                        
Strings.actuators.labels=[{'Aileron'},{'Elevator'},{'Rudder'},{'Throttle'}];
Strings.actuators.units=[{'rad'},{'rad'},{'rad'},{'-'}];
Strings.actuators.inputs = [{'Amplitude'},{'Steptime'},{'Step_Duration'}];
Strings.actuators.inputunits = [{'rad'},{'s'},{'s'}];

Strings.Init.labels = [{'X0'},{'V0'},{'OM0'},{'PHI0'},{'Delta0'},{'EPR0'}];
Strings.X0.labels =[{'x0'},{'y0'},{'z0'}];
Strings.V0.labels =[{'u0'},{'v0'},{'w0'}];
Strings.OM0.labels =[{'p0'},{'q0'},{'r0'}];
Strings.PHI0.labels =[{'phi0'},{'theta0'},{'psi0'}];
Strings.Delta0.labels =[{'da0'},{'de0'},{'dr0'}];
Strings.EPR0.labels =[{'dp0'}];