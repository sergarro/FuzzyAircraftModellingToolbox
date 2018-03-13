%% Copy and Protect code to bin folder
copyfile data ../bin/data
copyfile doc ../bin/doc
copyfile GUI ../bin/GUI
copyfile resources ../bin/resources
copyfile MAIN.m ../bin
copyfile lib/SolveODEs ../bin/lib/SolveODEs

pcode('lib/*.m')
movefile *.p ../bin/lib

pcode('lib/quat_functions/*.m')
movefile *.p ../bin/lib/quat_functions