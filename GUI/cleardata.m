function  cleardata( src,event)
global Strings
load('data/CurrentVars','var');

for i=1:length(Strings.ButtonNames)
    if(strcmp(Strings.ButtonNames{i},'coef'))
        for j=1:length(Strings.coef.labels)
            for k=1:length(Strings.coef.(Strings.coef.labels{j}).labels)
            var.(Strings.coef.(Strings.coef.labels{j}).labels{k})='0';
            end
        end
    else
        for j=1:length(Strings.(Strings.ButtonNames{i}).labels)
            var.(Strings.(Strings.ButtonNames{i}).labels{j}) = '0';
        end
    end
end
save('data/CurrentVars');
source = findobj('Tag','mig');
event=0;
SelectPanel(source,event)