function PlotResults( src,event )
global Strings
load('../data/SimResults')
pop = findobj('Tag','SelectStatesVar');

figure('Name','Simulation Results')
subplot(2,1,1)
plot(tm,Yf1(:,pop.Value),'LineWidth',2)
set(gca,'fontsize',11)
xlabel('Time [s]'),ylabel([Strings.StatesVar.labels{pop.Value},' ',Strings.StatesVar.units{pop.Value}])
title(['Dynamic Response of ',Strings.StatesVar.labels{pop.Value}])
subplot(2,1,2)
plot(tm,input_u(:,1:4),'LineWidth',2)
set(gca,'fontsize',11)
title('Actuators Response')
xlabel('Time [s]')
legend('EPR','AILERONS [rad]','ELEVATOR [rad]','RUDDER [rad]')

end

