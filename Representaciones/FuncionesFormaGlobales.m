function [N1g,N2g] = FuncionesFormaGlobales(t,L,a)

%% DESCRIPCIÓN DE LA FUNCIÓN
% FuncionesFormaGlobales obtiene las funciones de forma globales de la 
% estructura
%
% INPUTS ------------------------------------------------------------------
% a : angulo del elemento [-pi,pi],(rad)
% L : longitud del elemento
% t: variable adimensional -1<t<1
%
% OUTPUTS -----------------------------------------------------------------
% N1g : función de forma en nudo 1
% N2g : función de forma en nudo 2
%
% D = {Theta(t),dw/dt(t),w(t)}' Vector columna con desplazamientos y giros locales en barra
% a1 = {Theta1,dw1/dt,w1}' Vector columna con gdl globales en nudo 1
% a2 = {Theta2,dw2/dt,w2}' Vector columna con gdl globales en nudo 2
%
% Función de interpolación: D(t) = N1g(t) * A1  +  N2g(t) * A2
%
% Con:
%
% N1g = T * N1 * T' 
% N2g = T * N2 * T' 

%% CALCULO DE LAS FUNCIONES DE FORMA GLOBALES
% Funciones de forma locales
[N1,N2] = FuncionesFormaLocales(t,L);

% Matriz de giro. Importante: "a" en [rad]
T = [cos(a)   sin(a) 0 ; ...
     sin(a)  -cos(a) 0 ; ...
          0        0 1 ];


% Funciones de forma globales
N1g = T * N1 * T';
N2g = T * N2 * T';
