# Fuzzy Modelling Matlab Toolbox for Aircraft Systems
Nowadays, there is an important reliance on automatic control systems in aviation. Some of the critical phases of the flight, like the final approach, induce that many variables should be controlled simultaneously.  Therefore, the improvement of control algorithms combined with navigation systems, directly contributes to have a secure flight. These results have a common source before being implemented: a reliable aircraft dynamic model. 


The classic aircraft dynamic models are on the most part composed by 15 non-lineal differential equations, which are not the best option in order to adjust the control laws. The most common solution for this model identification, is by transfers functions methods, but there are also some inconvenient. These methods work due to a model linearisation  from an equilibrium point, and for a normal flight, there are many different stages with one equilibrium point for each one. The outcome is a considerable number of different controllers.

This is the main fact for investigate a different dynamic model using a methodology based on fuzzy logic. These Fuzzy Models, have a considerable advantage in front of classic model, because it can be implemented one unified control system for all the model. They are composed by a combination of consequent and membership functions, which turn out into a sum of rules. Therefore this method is better than classic ones as it reduces computing costs.

The main objective will be the research of another version of conventional aircraft dynamic model, using Fuzzy Logic methods. 

The main goal of this toolbox is to provide a general dynamic model based on fuzzy logic for aircraft systems, using a clear interface to maximize the user experience. The toolbox provides a complete definition and simulation environment for Fuzzy Aircraft Models based on Takagi-Sugeno structure. 

In "\doc" folder, user will find a detailed description of the classic aircraft dynamic models based on  15 non-lineal differential equations. 

# Toolbox Installation
The installation is straightforward and it does not require any changes to your system settings. The user should create a sub-directory to copy into all the toolbox files. If the toolbox was provided as a zip file, unzip it in this directory. Once all ready, the user should run "MAIN.m" script for begin to work with the graphical environment (GUI).

[For more information check the User Manual ](Toolbox_Documentation.pdf)
