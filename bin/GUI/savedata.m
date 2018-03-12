function  savedata( source,event )

load('../data/CurrentVars');
varName = source.Tag;
value = str2num(source.String);

if (isempty(strfind(varName,'max'))==0)
    var.(varName(1:(strfind(varName,'max')-2)))(1)=value;
elseif (isempty(strfind(varName,'min'))==0)
    var.(varName(1:(strfind(varName,'min')-2)))(2)=value;
else
    var.(varName)=value;
end
    save('../data/CurrentVars','var');
    
end

