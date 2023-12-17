# reinforcement-learning-of-a-Fuzzy-inference-system-
This is a personal project of FIS (fuzzy inference system) optimisation. Using Particle swarm optimization and genetic algorithm

To use this project, you need to have a simulink file, with a fuzzy controller to optimize. You need a first FIS different from the one inside your simulink. It will be the initial FIS. And you need of course and obective function to optimize. This system doesn't optimize the number of partition or the type of membership funtion. It optimizes :
- Kernel and support of your membership function (this only works for trapezoidal membership function)
- The conclusion of your rules.

This project is not mature. There are plenty modifications to do and I advice you to not use it for your project but you can use some of this code to build a self optimizer of FIS object. To run this project, you need the fuzzy system module of matlab.

The current main program of this project is : "PSO_Fuzzy_Partition". Indeed, for the moment, just this option is implemented.
