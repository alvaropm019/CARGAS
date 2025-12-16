function [K0,K] = Rigidez(ESTRUCTURA)

%% DESCRIPCIÓN DE LA FUNCIÓN
% RigidezEstructura calcula la matriz de rigidez de la estructura
%
% INPUTS ------------------------------------------------------------------
% ESTRUCTURA : estructura de datos que contiene los datos del modelo de
% emparrillado estructural de elementos viga Euler-Bernoulli
%
% OUTPUTS -----------------------------------------------------------------
% K : matriz de rigidez de la estructura (Ngdl x Ngdl)

ElemConexion = ESTRUCTURA.Conect;
NodosGdl = ESTRUCTURA.GDL;
CondContorno = ESTRUCTURA.CondContorno;


% Número de grados de libertad totales
NumGdl   = numel(NodosGdl);     

% Número de elementos
NumElem = size(ElemConexion,1);





%% MATRIZ DE RIGIDEZ CON TODOS LOS GDL
% Inicialización
K0 = zeros(NumGdl,NumGdl);

MatrizPropiedades = ESTRUCTURA.PropiedadesMecanicas;
MatrizConexion = ESTRUCTURA.Conect;
MatrizGDLNodos = ESTRUCTURA.GDL;

% Estructura MatrizPropiedades
%
% Columna:        1        2         3         4         5         6
% -----------------------------------------------------------------------
% Elem "e"     Familia   EI(m2N)   GJ(m2N)  rhoA(kg/m)  L(m)   angle(rad)  


for e=1:NumElem
    % Propiedades del elemento
    EI = MatrizPropiedades(e,2);
    GJ = MatrizPropiedades(e,3);
    L = MatrizPropiedades(e,7);
    a = MatrizPropiedades(e,8);

    % Matriz Rigidez del elemento
    K_elemento = RigidezElemento(GJ,EI,L,a);

    % GDL asociados
    id = IdentificacionGDLNodos(e, MatrizConexion, MatrizGDLNodos);

    % Asignar a matriz de rigidez global
    K0(id, id) = K0(id, id) + K_elemento;


    % aquí calculamos por acumulación la matriz de rigidez global
    % llamaremos iterativamente a RigidezElemento(...)
    % colocaremos sus elementos en las posiciones asociadas a sus gdl's
    ...
end



%% MATRIZ DE RIGIDEZ CON GDL ACTIVOS
% ELIMINAMOS LOS GDL NULOS DE LA MATRIZ DE RIGIDEZ
% Nuevo vector con los grados de libertad activos
% Eliminamos los nulos con la función de MATLAB setdiff
Gdl_Activos = setdiff(1:NumGdl,CondContorno);


% La matriz de rigidez que recoge únicamente los activos es
K = K0(Gdl_Activos,Gdl_Activos);

end
