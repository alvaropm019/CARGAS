
%% INICIALIZACIÓN
clc
clear
close all

addpath('Modelo Estructural')
addpath('Modelo Estructural/secciones')
addpath('CroquisAvion')
addpath('Representaciones')
addpath('Resultados')
addpath('Simulacion Tiempo')


%% GEOMETRÍA ALA EMPOTRADA

%imshow("CroquisAvion/figura_SeccionesEstructurales.png" )
% ALA (SUPERFICIE DE SUSTENTACIÓN)
b  = 9.1;... envergadura [m]
cr = 1.50;... cuerda en la raíz [m]
ct = 1.50;... cuerda en punta de ala [m]






%% IMPORTAMOS GEOMETRÍA BARRAS/NODOS ======================================
ESTRUCTURA.CuerdaRaiz  = cr;   ... cuerda en la raíz (m)
ESTRUCTURA.CuerdaPunta = ct;   ... cuerda en punta de ala (m)
ESTRUCTURA.Envergadura =  b;   ... envergadura (m)

[Nodes, Conn, LayerInfo] = ExtraerNodosConectividadDXF('modelo_estructura.dxf');



% Matriz de nodos ------------------
N_nodos = size(Nodes,1);
ESTRUCTURA.CoordNodos = [Nodes, zeros(N_nodos, 1)];
ESTRUCTURA.NumNodos   = N_nodos;



% Matriz de gdl ---------------------
ESTRUCTURA.NumGDL = 3 * N_nodos;
vector_fila_gdl= 1:ESTRUCTURA.NumGDL;
ESTRUCTURA.GDL = (reshape(vector_fila_gdl,[3, N_nodos]))';


% Matriz de conectividad ------------
ESTRUCTURA.Conect = Conn(:,1:2);
ESTRUCTURA.NumElem = size(Conn, 1);
ESTRUCTURA.LayerInfo = LayerInfo;


% Capas (layers) de elementos: Tipo de elemento
NumTipos = size(LayerInfo(:,1),1);
ESTRUCTURA.ID_elem = Conn(:,3);


% Tipos de nodos
% Nodos del fuselaje: "3" -----------------------------------------------------
ESTRUCTURA.ID_nodos = 3 * ones(N_nodos,1);



% Asignar los nodos de referencia para deformar la SUPERFICIES SPLINE
Xnodos = ESTRUCTURA.CoordNodos(:,1);
labels_nodos = 1:length(Xnodos);      % etiquetas numéricas: [1 2 3 4 ....]

% Nodos del ala: "1" -----------------------------------------------------
id = (Xnodos < 3) & (Xnodos > 1.4);  % condición lógica
nodos_filtrados = labels_nodos(id);  % nodos que cumplen la condición
ESTRUCTURA.Splines.NodosReferencia.Ala = nodos_filtrados;
ESTRUCTURA.ID_nodos(nodos_filtrados) = 1;
ESTRUCTURA.NodoEjemplo = [];


% Nodos del estabilizador: "2" -------------------------------------------
id = (Xnodos > 5.75);  % condición lógica
nodos_filtrados = labels_nodos(id);  % nodos que cumplen la condición
ESTRUCTURA.Splines.NodosReferencia.Estabilizador = nodos_filtrados;
ESTRUCTURA.ID_nodos(nodos_filtrados) = 2;
% disp(nodos_filtrados)


% REPRESENTACIÓN ESTRUCTURA
% Dibujo del emparrillado 2D (plano XY)
t = [-1,1]';... vector de discretización de cada elemento
% Representacion elementos
ESTRUCTURA.Representacion.Elementos           = 'on';
ESTRUCTURA.Representacion.LabelsElementos     = 'off';
ESTRUCTURA.Representacion.LabelsNodos         = 'on';
ESTRUCTURA.Representacion.LabelsFamilia       = 'off'; 
ESTRUCTURA.Representacion.CondContorno_nodo   = 'on';
ESTRUCTURA.Representacion.CondContorno_gdl    = 'off';
ESTRUCTURA.Representacion.DeformadaEstructura = 'on';
ESTRUCTURA.Representacion.DeformadaSplines    = 'on';
ESTRUCTURA.Representacion.AnimacionArmonica   = 'on';


% Representacion de los modos de vibracion
ESTRUCTURA.Representacion.Modos               = 'on';


% Estructura sin CC: libre-libre
ESTRUCTURA.CondContorno = [ ];... vector con los GDL nulos


%DibujoEstructura(ESTRUCTURA)
% 
% 
%  
% %% PROPIEDADES MECÁNICAS Y MÁSICAS
% 
% % Crear la función "PropiedadesEstructura" --> para K
[ESTRUCTURA] = PropiedadesEstructurav2(ESTRUCTURA);


% Crear la función "PropiedadesMasas" --> para M
[ESTRUCTURA] = PropiedadesMasas(ESTRUCTURA);
% 
% 
% % Cálculo del peso estructural de los elementos
Peso_pul_elementos = ESTRUCTURA.PropiedadesMecanicas(:,4);
Longitud_elementos = ESTRUCTURA.PropiedadesMecanicas(:,7);
masa_estructural = sum(Peso_pul_elementos .* Longitud_elementos);
% 
% 
% % DESCOMPOSICIÓN MODAL
% % Para la optención de las ecuaciones del movimiento
% id_modos = [1:50];
% ESTRUCTURA.DescomposicionModal = id_modos;
%  
% % 
% % 
% % % REPRESENTACIÓN ESTRUCTURA
% DibujoEstructura(ESTRUCTURA)
% %DibujoMasas(ESTRUCTURA)
% 
% 
K = Rigidez(ESTRUCTURA);
% 
M = Masa(ESTRUCTURA);
% 
% 
% %% MODOS DE SÓLIDO RÍGIDO
% % Construir esta función es opcional: permite crear los 3 modos de sólido
% % rígido de forma artificial: desplazamiento,cabeceo,alabeo 
% 
% % [SOLIDO_RIGIDO] = ModosSolidoRigido(ESTRUCTURA)
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% [V, J] = eig(K, M);
% n = size(J, 1);
% 
% w = sqrt(diag(J));
% [w, id] = sort(w);
% V = V(:,id);