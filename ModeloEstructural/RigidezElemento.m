function [K] = RigidezElemento(GJ,EI,L,a)

%% DESCRIPCIÓN DE LA FUNCIÓN
% RigidezElemento calcula la matriz de local de cada elemento
%
% INPUTS ------------------------------------------------------------------
% GJ : rigidez a torsión del elemento (Nm2)
% EI : rigidez a flexión del elemento (Nm2)
% L : longitud del elemento (m)
% a : ángulo del elemento (rad) (a = 0  (i)------------(j) ----> Eje X)
%
% OUTPUTS -----------------------------------------------------------------
% K : matriz de rigidez de elemento (Ngdl x Ngdl)

%% MATRIZ DE RIGIDEZ BARRA HORIZONAL (a=0)
%
%    K0 = [K11   K12
%         K21   K22] 
%    K12 = K21'

    K11= [GJ/L           0            0  ;...
            0       4*EI/L     6*EI/L^2  ;...
            0     6*EI/L^2    12*EI/L^3] ;

    K12= [-GJ/L           0            0 ;...
              0      2*EI/L    -6*EI/L^2 ;...
              0    6*EI/L^2   -12*EI/L^3];  

    %K21= K12';      

    K22= [GJ/L            0            0 ;...
            0        4*EI/L    -6*EI/L^2 ;...
            0     -6*EI/L^2    12*EI/L^3];
%end
    

    
    
%% MATRIZ DE CAMBIO DE BASE
% Cosenos y senos del ángulo de giro
ca = cos(a);
sa = sin(a);

% Matriz de cambio
T = [ca  +sa   0 ;...
     sa  -ca   0 ;...
      0    0   1 ];
  
  
%% MATRIZ DE RIGIDEZ BARRA INCLINADA (a <> 0)
%
% K11a = T * K11 * T'
% K12a = T * K12 * T'
% K21a = T * K21 * T'
% K22a = T * K22 * T'

K11a = T * K11 * T';
K12a = T * K12 * T';
K21a = K12a';
K22a = T * K22 * T';

K = [K11a  K12a ; K21a  K22a]; % Globales
    


        
                               
                           