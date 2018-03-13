function defaultlimits( source,event)

addpath('lib')
param.off=0;
param = DefaultMaxMin(param);
load('data/CurrentVars')
var.alpha = param.lim.alpha;
var.beta = param.lim.beta;
var.pVa = param.lim.pVa;
var.qVa = param.lim.qVa;
var.rVa = param.lim.rVa;
var.Va2 = param.lim.Va2;
var.VazVax = param.lim.VazVax;
var.VayVa = param.lim.VayVa;
var.Hlg = param.lim.Hlg;

save('data/CurrentVars','var')

CreateFuzzyPanel(source,event)
end

