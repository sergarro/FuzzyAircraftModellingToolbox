function [ Act ] = StepAct( t,tini,dt,A)
%This function returns step input forms

%% Inputs
%t:Total Time simulation
%tini: time in seconds when output jumps, it can be a vector with different
%      times for each step.
%dt  : Step duration, it can be a vector with each step
%A   : Step amplitude, can be also a vector.
%% Outputs
%Act: Timeseries input step.

%% Code
input=0;
for i=1:length(tini)
input=input+frest.createStep('StepTime',tini(i),'StepSize',A(i),'FinalTime',t)...
    -frest.createStep('StepTime',tini(i)+dt(i),'StepSize',A(i),'FinalTime',t);
end
Act=input;
end

