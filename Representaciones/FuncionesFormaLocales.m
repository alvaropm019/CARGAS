function [N1,N2] = FuncionesFormaLocales(t,L)

%% DESCRIPCIÓN DE LA FUNCIÓN
% FuncionesFormaGlobales obtiene las funciones de forma globales de la 
% estructura
%
% INPUTS ------------------------------------------------------------------
% L : longitud del elemento
% t: variable adimensional -1<t<1
%
% OUTPUTS -----------------------------------------------------------------
% N1 : función de forma en nudo 1
% N2 : función de forma en nudo 2
%
% d = {Theta(t),dw/dt(t),w(t)}' Vector columna con desplazamientos y giros locales en barra
% a1 = {Theta1,dw1/dt,w1}' Vector columna con gdl locales en nudo 1
% a2 = {Theta2,dw2/dt,w2}' Vector columna con gdl locales en nudo 2
%
% Función de interpolación:     d(t) = N1(t) * a1  +  N2(t) * a2
%
% Con:
%
% N1 = [H1(t)        0          0
%        0        A1(t)  (L/2)B1(t)
%        0  (2/L)A1'(t)      B1'(t)]      
%
% N2 = [H2(t)        0          0
%        0        A2(t) (L/2)B2(t) 
%        0  (2/L)A2'(t)     B2'(t)]      

%% CALCULO DE LAS FUNCIONES DE FORMA LOCALES
% Funciones de forma interpolación movimientos TORSIONALES
H1 = (1/2)*(1 - t);
H2 = (1/2)*(1 + t);

% Funciones de forma interp. movimientos y giros transversales
A1 = (1/4)*(2 - 3*t + t^3);
dA1 = (1/4)*(- 3 + 3*t^2);
B1 = (1/4)*(1 - t - t^2 + t^3);
dB1 = (1/4)*(0 - 1 - 2*t + 3*t^2);
A2 = (1/4)*(2 + 3*t - t^3);
dA2 = (1/4)*(0 + 3 - 3*t^2);
B2 = (1/4)*(-1 - t + t^2 + t^3);
dB2 = (1/4)*(0 - 1 + 2*t + 3*t^2);


% Montaje de las funciones de forma
N1 = [H1         0          0   ;...
        0       dB1     (2/L)*dA1 ;...
        0   (L/2)*B1     A1]   ;      
N2 = [H2         0          0   ;...
        0       dB2     (2/L)*dA2 ;...
        0   (L/2)*B2     A2]   ;   



