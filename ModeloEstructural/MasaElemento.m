function [M] = MasaElemento(rhoA ,... masa por unidad de long. [kg/m]
                            rhoIx,... Inercia polar por unidad de long.  [kg*m2/m]                             
                            rhoIy,... Inercia flexion por unidad de long.[kg*m2/m]
                            L,...    Longitud barra  [m]
                            a)...    Ángulo de giro  [rad]
                                     

% Función que da la matriz de rigidez en coordenadas globales
%           rhoA,rhoI0,rhoIy: Características sección
%           rho: densidad [t/m3]
%           L: Longitud de la barra
%           a: Ángulo de giro de la barra [-pi,pi]
%               a = 0  (i)------------(j)
%


%% MATRIZ DE MASA BARRA HORIZONAL (a=0)
%
% Estructura emparrillado
% theta_x: giro torsion barra
% theta_y: giro flexion barra
% w      : desplazamiento vertical
% Matriz de masa por desplazamientos u = [theta_x, theta_y, w]
%
%    Mv = [M11v   M12v
%          M21v   M22v]
% 
% M12v= M21v'
%
 
% MATRIZ ASOCIADA A rhoA ----------------------
% ---------------------------------------------

M11w= rhoA*[0            0          0 ;...
            0      L^3/105 11*L^2/210 ;...
            0   11*L^2/210    13*L/35 ]   ;
    
M12w= rhoA*[0            0            0 ;...
            0     -L^3/140  +13*L^2/420 ;...
            0  -13*L^2/420       9*L/70 ] ;  
      
M21w= M12w';      

M22w= rhoA*[0            0            0 ;...
            0      L^3/105  -11*L^2/210 ;...
            0  -11*L^2/210      13*L/35 ]   ;
       

% Matriz de masa por giros de flexion ------------------
%
%    Mg = [M11gy   M12gy
%          M21gy   M22gy]
% 
% M12v= M21v'
%

  
    
M11gy= rhoIy*[ 0       0          0 ;...
               0   2*L/15        1/10 ;...
               0     1/10     6/(5*L) ]   ;
    
M12gy= rhoIy*[0      0       0 ;...
              0   -L/30   -1/10 ;...
              0   +1/10 -6/(5*L)] ;  
      
M21gy= M12gy';      

M22gy= rhoIy*[ 0       0          0 ;...
               0  2*L/15      -1/10 ;...
               0    -1/10    6/(5*L) ]   ;
  
  
% Matriz de masa por giros de torsion
%
%    Mg = [M11gx   M12gx
%          M21gx   M22gx]
% 
% M12gx= M21gx'
%
% Variable auxiliar
% -------------------------------------------

M11gx= rhoIx*[L/3        0          0 ;...
              0          0          0 ;...
              0          0          0 ];
    
M12gx= rhoIx*[L/6        0          0 ;...
              0          0          0 ;...
              0          0          0 ];
      
M21gx= M12gx';      

M22gx= rhoIx*[L/3        0          0 ;...
              0          0          0 ;...
              0          0          0 ];
       
    
    

% Matriz de masa total

M11 = M11w + M11gy + M11gx ;
M12 = M12w + M12gy + M12gx ;
M22 = M22w + M22gy + M22gx ;
    

    
    
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
% M11a = T * M11 * T'
% M12a = T * M12 * T'
% M21a = T * M21 * T'
% M22a = T * M22 * T'

M11a = T * M11 * T';
M12a = T * M12 * T';
M21a = M12a';
M22a = T * M22 * T';

M = [M11a  M12a ; M21a  M22a];



    


        
                               
                           