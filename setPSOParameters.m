function [w, p1, p2] = setPSOParameters(k_simu,n_simu,r1,k_point)

% 2 behaviours conservative and social
% These two behaviours depends on both individual and the social groupe
% p1 is the conservative factor and p2 the social factor
% r1 and r2 represent the individual factor
% c1 and c2 represent the social factor
%c1 = ;

% global behaviour factor (p=p1+p2) [3.66 ; 4]
%  F. van den Bergh. An Analysis of Particle Swarm Optimizers. PhD thesis, 
% Department of Computer Science, University of Pretoria, November 2002
% this global behaviour facor is linked to the experience of the population
p = (3.66+(k_simu/n_simu)*0.34)/20;

% we decide to define the inertia with the global behaviour factor. We 
% postulate that in the beginning the particules doesn't have lots of
% experiences and so the move of each particules is before all the fact of
% the precedent state of the particules. So p will increase during the 
% simulation and w will decrease.
w = 1-12/(100*p)+sqrt(abs((20*p)^2-80*p))/2;

%make the cognitive coefficient decreasing while the social coefficient 
% increasing to bring more exploration at the beginning and more exploitation 
% at the end. See, for example, Shi and Eberhart (1998) and Eberhart and Shi (2000).
p1 = r1(k_point)*p;
p2 = p-p1;

end