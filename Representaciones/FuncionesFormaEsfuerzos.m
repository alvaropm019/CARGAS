function [H1g,H2g] = FuncionesFormaEsfuerzos(t,L,a,EI,GJ)

%% DESCRIPCIÓN DE LA FUNCIÓN
%--------------------------------------------------------------------------
% FUNCIONESFORMAESFUERZOS.M
%
% Descripción:
% Esta función calcula las funciones de forma globales asociadas a los 
% esfuerzos internos (torsor, momento flector y fuerza cortante) en un 
% elemento estructural de tipo viga, considerando flexión y torsión.
% A partir de las funciones de forma locales y de la orientación del 
% elemento (ángulo 'a'), se obtiene la interpolación de los esfuerzos en 
% coordenadas globales.
%
% La formulación se basa en un vector de desplazamientos y giros locales 
% de tipo {theta, psi, w}, asociados a los grados de libertad en los 
% nudos inicial y final del elemento. La transformación a coordenadas 
% globales se realiza mediante una matriz de giro 2D.
%
% Entradas:
%   - t  : coordenada adimensional local (-1 < t < 1)
%   - L  : longitud del elemento
%   - a  : ángulo de orientación del elemento respecto al eje global X [rad]
%   - EI : rigidez a flexión del elemento
%   - GJ : rigidez a torsión del elemento
%
% Salidas:
%   - H1g : matriz de funciones de forma globales asociadas al nudo 1
%   - H2g : matriz de funciones de forma globales asociadas al nudo 2
%
% Relación funcional:
%   f(t) = H1g(t) * a1 + H2g(t) * a2
%   donde a1 y a2 son los vectores de grados de libertad globales en los
%   nudos 1 y 2, respectivamente.
%
% Autor: Mario Lázaro
% Fecha: 21/5/2025
%--------------------------------------------------------------------------


%% CALCULO DE LAS FUNCIONES DE FORMA GLOBALES
% Funciones de forma locales
[H1,H2] = FuncionesFormaLocales(t,L,EI,GJ);

% Matriz de giro. Importante: "a" en [rad]
T = [cos(a)   sin(a) 0 ; ...
     sin(a)  -cos(a) 0 ; ...
          0        0 1 ];


% Funciones de forma globales: 
% Transforma gdl A1, A2 en ejes globales en esfuerzos en ejes locales
H1g = H1 * T';
H2g = H2 * T';










%% FUNCIONES DE FORMA DE LOS ESFUERZOS CON GDL (LOCALES)

function [H1,H2] = FuncionesFormaLocales(t,L,EI,GJ)

% DESCRIPCIÓN DE LA FUNCIÓN
% FuncionesFormaGlobales obtiene las funciones de forma globales de la 
% estructura
%
% INPUTS ------------------------------------------------------------------
% L : longitud del elemento
% t: variable adimensional -1<t<1
%
% OUTPUTS -----------------------------------------------------------------
% H1 : función de forma en nudo 1
% H2 : función de forma en nudo 2
%
% f_e(t) = {Tx(t),My(t),Vz(t)}';
% f_e(t) = H1(t) * a1 + H2(t) * a2
% a1 = {theta1,psi_1,w1}' Vector columna con gdl locales en nudo 1
% a2 = {theta2,psi_2,w2}' Vector columna con gdl locales en nudo 2
%
% Función de interpolación:     d(t) = N1(t) * a1  +  N2(t) * a2
%
% Con:
%
% H1 = [(2GJ/L)*Ntheta1'(t)                    0                   0
%                        0    (2EI/L)*N_psi1''(t)  (4EI/L^2)N_w1''(t)
%                        0 (4EI/L^2)*N_psi1'''(t) (8EI/L^3)N_w1'''(t)]      
%
% H2 = [(2GJ/L)*Ntheta2'(t)                    0                   0
%                        0    (2EI/L)*N_psi2''(t)  (4EI/L^2)N_w2''(t)
%                        0 (4EI/L^2)*N_psi2'''(t) (8EI/L^3)N_w2'''(t)]   

%% CALCULO DE LAS FUNCIONES DE FORMA LOCALES

% Funciones de forma interp. esfuerzos Torsores,Flectores,Cortantes
dNtheta1 = -1/2;
dNtheta2 = +1/2;

d2Nw1 = +3*t/2;
d2Nw2 = -3*t/2;

d3Nw1 = +3/2;
d3Nw2 = -3/2;

d2Npsi1 = (1/4) * (-2+6*t);
d2Npsi2 = (1/4) * (+2+6*t);

d3Npsi1 = +3/2;
d3Npsi2 = +3/2;



% Montaje de las funciones de forma
H1 = [dNtheta1        0            0 ;...
             0  d2Npsi1  (2/L)*d2Nw1 ;...
             0  d3Npsi1  (2/L)*d3Nw1];      
H2 = [dNtheta2        0            0 ;...
             0  d2Npsi2  (2/L)*d2Nw2 ;...
             0  d3Npsi2  (2/L)*d3Nw2];      


D = [2*GJ/L         0           0 ;...
          0  (2/L)*EI           0 ;...
          0         0  (2/L)^2*EI ];

H1 = D * H1;
H2 = D * H2;



end






end