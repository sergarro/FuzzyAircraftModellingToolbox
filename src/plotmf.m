function  plotmf( source,event)
global Strings
addpath('../bin')
load('../data/FuzzyVars')

pop = findobj('Tag','mfvar');
varname = Strings.mf.labels{pop.Value};

mf = FIS.(varname).mf;
figure('Name','Membership Function Plot')
mfplot(mf,varname);

end

