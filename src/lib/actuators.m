function  [ddeltadt]  = actuators( t,delta,input_t,input_u,param)
%% Description
% This function returns the differential equation with respect the
% actuators dynamic (aileron, elevator and rudder)
%% Inputs
% t : instant time value
% delta: 1x3 vector with the actuators deflections as delta=[da,de,dr]
% input_t : column time input vector
% input_u : column actuators deflection input vector
% param   : struct with actuators parameters as 
%            -> param.act.tau : time constant vector [tau_da,tau_de,tau_dr]
%            -> param.act.RL  : rate limit vector [RL_da,RL_de,RL_dr]

%% Outputs
% ddeltadt : derivative of the actuators with respect the time.
%% Code
ddeltadt=zeros(1,3);    
for i=1:3
        u=interp1(input_t,input_u(:,i),t);
        if (u-delta(i))/param.act.tau(i)>param.act.RL(i)
            ddeltadt(i)=param.act.RL(i); 
        elseif (u-delta(i))/param.act.tau(i)<-param.act.RL(i)
            ddeltadt(i)=-param.act.RL(i);
        else
            ddeltadt(i)=(u-delta(i))/param.act.tau(i);
        end
end

if (param.waitbar)
   waitbar(0.5+0.2*(t/param.tf))
end


