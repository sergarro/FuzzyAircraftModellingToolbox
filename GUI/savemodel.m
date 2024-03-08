function savemodel( src,event )

[file,path]=uiputfile('*.mat','Save file name');
load('data/CurrentVars','var');
save([path,file],'var');


end

