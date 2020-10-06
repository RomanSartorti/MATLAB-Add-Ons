# MATLAB-Add-Ons
Custom Matlab Add-Ons for nice things.
This repository contains two major parts:
1.  General purpose scripts
1.  Solvers for ordinary differential equations (ODEs)

## 1. Generally useful files
Those codes are made for general purpose. 

### TerminalList
This is just a small snippet that creates a list in the terminal from given data. Usefull for iteration routines to see the progress. The GIF below is just an example.
```
clc;
lst = terminalList({'stress','strain','failure index','error'});
for i = 1:10;
  lst.setData(i*[1,2,3,4]);
  pause(0.5)
end
```
![TerminalList_GIF](Miscellaneous/GIF/terminalList.gif)

### GenerateTerminalMsg
Generates a terminal message sourrounded by a box. Sometimes useful for long running code to give an update when starting a new section, for instance.
```
generateTerminalMessage('EXAMPLE,Message,take care of COMMA seperation!')
```
![generateTerminamMsg_PNG](Miscellaneous/PNG/generateTerminalMessage.png)

### CreateFcnHeader
Simply creates a function header. Useful if you want your function header being consistent through all of your created functions.
```
createFcnHeader('[a,b] = myfun(x,y,z)')
```
![creteFcnHeader_PNG](Miscellaneous/PNG/createFcnHeader.png)

### NewtonCotes/NewtonCotes2D
Just an integration method using weighted function evaluations

## 2. ODE solver
This is class contains mainly two different types of solver. First, a solver for Runge-Kutta-Methods (RKMs) and second linear multistep methods (LMMs). Both can be used to solve ODEs with initial conditions. For LMMs you might need to prescribe inital values for multiple steps. However, this can also be done by the method itself. But if you know them, you better use them.

Sadly until now, DAEs can be solved with the method. This feature will be implemented by some time.
