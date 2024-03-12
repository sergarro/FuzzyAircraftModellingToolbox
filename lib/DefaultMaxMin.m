function [ param ] = DefaultMaxMin( param )
%% Description
    %Set defaults máximums and minimums
%% Inputs
    %alpha --> lim.alpha
    %beta  --> lim.beta
    %p/Va  --> lim.pVa
    %q/Va  --> lim.qVa
    %r/Va  --> lim.rVa
    %Va^2    --> lim.Va2
    %Vaz/Vax   --> lim.VazVax
    %Vay/Va   --> lim.VayVa
    %Hlg   --> lim.Hlg
%% Ouputs
    % The same
if isfield(param,'lim')==0
     param.lim.alpha=[pi/2,-pi/2];
     param.lim.beta=[pi/2,-pi/2]; 
     param.lim.pVa=[1,-1];
     param.lim.qVa=[1,-1];
     param.lim.rVa=[1,-1];
     param.lim.Va2=[500,1];
     param.lim.VazVax=[40,-40];
     param.lim.VayVa=[1,-1];
     param.lim.Hlg=[8000,0];
else
if isfield(param.lim,'alpha')==0
   param.lim.alpha=[pi/2,-pi/2]; 
end

if isfield(param.lim,'beta')==0
   param.lim.beta=[pi/2,-pi/2]; 
end

if isfield(param.lim,'pVa')==0
   param.lim.pVa=[1,-1]; 
end

if isfield(param.lim,'qVa')==0
   param.lim.qVa=[1,-1]; 
end

if isfield(param.lim,'rVa')==0
   param.lim.rVa=[1,-1]; 
end

if isfield(param.lim,'Va2')==0
   param.lim.Va2=[900,1]; 
end

if isfield(param.lim,'VazVax')==0
   param.lim.VazVax=[40,-40]; 
end

if isfield(param.lim,'VayVa')==0
   param.lim.VayVa=[1,-1]; 
end

if isfield(param.lim,'Hlg')==0
   param.lim.Hlg=[40,0]; 
end
end
end
