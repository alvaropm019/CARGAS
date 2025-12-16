function [ElementoInicial,ElementoDeformado] = DeformadaElemento(e,... 
                                  ElemConexion,NodosCoord,NodosGdl,d,t,h)
%% DESCRIPCIÓN DE LA FUNCIÓN
% DeformadaElemento calcula la deformada de cada elemento del emparrillado
% estructural a partir de la solución de los gdl obtenida
%
% El vector d = [U1,V1,g1,....U(nd),V(nd),g(nd)] tiene la solución de 
% movimientos y giros de la estructura.
%
% Las coordenadas inicales se representan por (X,Y)
% Las coordenadas deformadas se representan por (x,y)
% y se calculan como 
%                   x(j) = X(j) +  U(j)
%                   y(j) = Y(j) +  V(j)
% donde j = 1...nd (nd=Número de nodos)
% Mediante esta función no solo obtendremos la deformada de los nodos
% inicial y final del elemetno sino de una serie de puntos intermedios.
%
% INPUTS ------------------------------------------------------------------
% e : identificación de elemento
% ElemConexion : matriz de conectividad de la estructura
% NodosCoord : matriz con las coordenadas de cada nodo (Nn x 3)
% NodosGdl : matriz de grados de libertad de la estructura (Nn x 3)
% d : solución de los gdl (movimientos y giros)
% t : vector columna con los puntos intermedios t=-1 (nodo 1), t=+1 (nodo 2)
% h : factor de escala
%
% OUTPUTS -----------------------------------------------------------------
% ElementoInicial : coordenadas originales elemento
% ElementoDeformado : coordenadas del elemento deformado

%% DATOS NECESARIOS
% Número de puntos a representar a lo largo del elemento
p = numel(t);

% El vector columna "t" debe tener la siguiente estructura
% t = [-1 t_2 t_3 .... t_p-2 t_p-1 +1]' : total "p" elementos
% con -1 < t_j < 1 , para j=2,...,p-1

% Nudos inicial (n1) y final (np) del elemento "e"
n1 = ElemConexion(e,1);
np = ElemConexion(e,2);

% Inicialización de la matriz "ElementoInicial"
Coord_XY = zeros(p,3);
% Inicialización de la matriz "ElementoDeformado"
Coord_xy = zeros(p,3);


%% OBTENCIÓN DE LA GEOMETRÍA INICIAL
% Asignamos coordenadas nodos inicial y final
X1 = NodosCoord(n1,1);
Y1 = NodosCoord(n1,2);
Z1 = 0;
Xp = NodosCoord(np,1);
Yp = NodosCoord(np,2);
Zp = 0;

Coord_XY(1,1) = X1;
Coord_XY(1,2) = Y1;
Coord_XY(1,3) = Z1;
Coord_XY(p,1) = Xp;
Coord_XY(p,2) = Yp;
Coord_XY(p,3) = Zp;

for j=2:(p-1)
    % Funciones de forma lineales
    N1 = (1/2)*(1 - t(j));
    Np = (1/2)*(1 + t(j));
    Coord_XY(j,1) = X1 * N1 + Xp * Np;
    Coord_XY(j,2) = Y1 * N1 + Yp * Np;
    Coord_XY(j,3) = Z1 * N1 + Zp * Np;
end

ElementoInicial = Coord_XY;



%% OBTENCIÓN DE LA GEOMETRÍA DEFORMADA
% Obtenemos los índices de los gdl asociados al nudo 1
gdl_1 = NodosGdl(n1,:);
gdl_p = NodosGdl(np,:);

% Obtenemos los resultados de cada nudo (globales)
A1 = d(gdl_1);
Ap = d(gdl_p);

% Longitud del elemento
dX = Xp - X1;
dY = Yp - Y1;    
% L = sqrt( dX^2 + dY^2 );
    
% Ángulo del elemento
% a = atan(dY / dX);

[a,L] = cart2pol(dX,dY);

for j=1:p
    % Funciones de forma globales
    [N1g,N2g] = FuncionesFormaGlobales(t(j),... Variable adimensional -1<t<1
                                       L,... Longitud del elemento
                                       a);... Ángulo del elemento [-pi,pi],(rad)
    % Desplazamientos (W)=D(3)
    D = N1g * A1 + N2g * Ap; %Globales

    % Coordenadas de los puntos deformados
    Coord_xy(j,1) = Coord_XY(j,1);
    Coord_xy(j,2) = Coord_XY(j,2);
    Coord_xy(j,3) = Coord_XY(j,3) + h*D(3);
   
end

ElementoDeformado = Coord_xy;
                                           
    



                              
                              
    
                                                                