function selectmodel( src,event )

[FileName,PathName]=uigetfile('*.mat','Select Data Model');
load('data/CurrentVars');
load([PathName,FileName]);
save('data/CurrentVars','var');
source = findobj('Tag','mig');
event=0;
SelectPanel(source,event)
fuzzypanel = findobj('Tag','defaultfuzzy');
CreateFuzzyPanel(fuzzypanel(1),event)
end

