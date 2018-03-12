    function ActuatorsWindow( src,event )
    global Strings
    a=2/11;
    b=2/13;
    load('../data/CurrentVars')
    fig = figure(2);
    set(fig,'Menubar','none');
    set(fig,'Units','normalized');
    set(fig,'Position',[0.2,0.2,0.5,0.2]);
    set(fig,'Name','Actuators input');
    set(fig,'NumberTitle','off');
    mainpanel = uipanel('Parent',fig,...
        'Units','normalized');
    for j=1:length(Strings.actuators.inputs)
        uicontrol('Parent',mainpanel,...
            'Units','normalized',...
            'Style','text',...
            'String',Strings.actuators.inputs{j},...
            'Position',[2*b+(b+b/2)*(j-1),1-a,b,a])
    end

    for i=1:length(Strings.actuators.labels)
        uicontrol('Parent',mainpanel,...
            'Units','normalized',...
            'Style','text',...
            'String',Strings.actuators.labels{i},...
            'Position',[b/2,1-a*(i+1),b,a])
        for j=1:length(Strings.actuators.inputs)
            uicontrol('Parent',mainpanel,...
                'Units','normalized',...
                'Style','edit',...
                'Position',[2*b+(b+b/2)*(j-1),1-a*(i+1),b,a],...
                'Tag',[Strings.actuators.labels{i},'_',Strings.actuators.inputs{j}],...
                'String',var.([Strings.actuators.labels{i},'_',Strings.actuators.inputs{j}]),...
                'Callback',@savedata)
        end
    end
    end

