function CreateFuzzyModel( source,event )
global Strings
addpath('../lib');
load('../data/CurrentVars')
for i=1:length(Strings.coef.labels)
    for j=1:length(Strings.coef.(Strings.coef.labels{i}).labels)
        param.coef.(Strings.coef.(Strings.coef.labels{i}).labels{j})=...
            var.(Strings.coef.(Strings.coef.labels{i}).labels{j});
    end
end

for i=1:length(Strings.mig.labels)
    param.mig.(Strings.mig.labels{i})=...
        var.(Strings.mig.labels{i});
end

for i=1:length(Strings.fuzzylim.labels)
    param.lim.(Strings.fuzzylim.labels{i})=...
        var.(Strings.fuzzylim.labels{i});
end

FIS = NoLin2FIS(param);
save('../data/FuzzyVars','FIS')


end

