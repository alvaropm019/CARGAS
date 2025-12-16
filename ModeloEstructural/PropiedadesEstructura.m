function ESTRUCTURA = PropiedadesEstructura(ESTRUCTURA)

%% Obtención de las propiedades mecánicas de las familias de elementos
% Funciones que determinan las propiedades mecánicas de cada sección
% [A_I, Iy_I, Iz_I, Ix_I] = Propiedades_Seccion_I(parametros);
% [A_C, Iy_C, Iz_C, Ix_C] = Propiedades_Seccion_C(parametros);
% [A_Tub, Iy_Tub, Iz_Tub, Ix_Tub] = Propiedades_Seccion_Tubular(parametros);
%% Propiedades del material
E= 7.0E10;
G = 2.6E10;
rho = 2.7E3;

%% SECCIÓN W2
parametrosW2.Coords = [1600    619.5;...
                       1600    452  ;...
                       1350.5  446.5;...
                       1100    450  ;...
                       850     456.5;...
                       596.5   486  ;...
                       505     520  ;...
                       505     554.5;...
                       596.5   606  ;...
                       850     670.5;...
                       1100    681.5;...
                       1350    666]*1e-3;
parametrosW2.espesores = [2 1 1 1 1 1 1 1 1 1 1]*1e-3;
parametrosW2.b = (350 + 500 + 247)*1e-3;
parametrosW2 = momentopolar(parametrosW2);

    % Sección W2_LL
    % de momento suponemos que delante y detras es igual. Larguerillos
    % considerando seccion de atras y resto de valores son las medias.
    parametrosW2LL.t = 2e-3;
    parametrosW2LL.b = 0.5 * (247 + 350) * 1e-3; % base
    parametrosW2LL.h = 0.5 * (240 + 169) * 1e-3; % altura
    parametrosW2LL.tpiel = 1e-3 ;
    parametrosW2LL.Larguerillos.Areas = [50; 50]*1e-6;
    parametrosW2LL.Larguerillos.Coord = [128*1e-3 parametrosW2LL.b/2;...
                                         128*1e-3 -parametrosW2LL.b/2];
    % Área y Momentos de Inercia
    [A_W2LL, Iy_W2LL, Iz_W2LL, Ix_W2LL] = Propiedades_Seccion_C(parametrosW2LL);
    % Momento Polar (El módulo de torsión es GJ)
    J_W2LL = parametrosW2.Jtotal * parametrosW2LL.b / 2 / parametrosW2.b;

    

    % Sección W2LC
    parametrosW2LC.t = 4e-3;
    parametrosW2LC.b = 0.5;
    parametrosW2LC.h = 0.24;
    parametrosW2LC.tpiel = 1e-3;
    parametrosW2LC.Larguerillos.Areas = 50e-6 * ones(8,1);
    parametrosW2LC.Larguerillos.Coord = [75*1e-3 parametrosW2LC.b/2;...
                                        -75*1e-3 parametrosW2LC.b/2;...
                                        75*1e-3 -parametrosW2LC.b/2;...
                                        -75*1e-3 -parametrosW2LC.b/2;...
                                        188*1e-3 parametrosW2LC.b/2;...
                                        -188*1e-3 parametrosW2LC.b/2;...
                                        188*1e-3 -parametrosW2LC.b/2;...
                                        -188*1e-3 -parametrosW2LC.b/2];
    % Área y Momentos de Inercia
    [A_W2LC, Iy_W2LC, Iz_W2LC, Ix_W2LC] = Propiedades_Seccion_I(parametrosW2LC);
    % Momento Polar (El módulo de torsión es GJ)
    J_W2LC = parametrosW2.Jtotal * parametrosW2LC.b / 2 / parametrosW2.b;

    % Sección W2_CO
    parametrosW2CO.t = 2e-3;
    parametrosW2CO.st = 0.5588;
    parametrosW2CO.b = parametrosW2CO.st; % base
    parametrosW2CO.h = 0.5 * (240 + 169) * 1e-3; % altura
    parametrosW2CO.tpiel = 1e-3 ;
    

    % Área y Momentos de Inercia
    [A_W2CO, Iy_W2CO, Iz_W2CO, Ix_W2CO] = Propiedades_Seccion_I(parametrosW2CO);
    % Momento Polar (El módulo de torsión es GJ)
    J_W2CO = parametrosW2.Jtotal * parametrosW2CO.st / 2 / parametrosW2.b;

A_W2 = A_W2LC + 2 * A_W2LL + A_W2CO;
Iy_W2 = Iy_W2LC + 2 * Iy_W2LL + Iy_W2CO;
Iz_W2 = Iz_W2LC + 2 * Iz_W2LL + Iz_W2CO;
Ix_W2 = Ix_W2LC + 2 * Ix_W2LL + Ix_W2CO;

%% SECCIÓN W1  
parametrosW1.Coords = [1600    619.5;...
                       1600    452  ;...
                       1350.5  446.5;...
                       1100    450  ;...
                       850     456.5;...
                       596.5   486  ;...
                       505     520  ;...
                       505     554.5;...
                       596.5   606  ;...
                       850     670.5;...
                       1100    681.5;...
                       1350    666]*1e-3;
parametrosW1.espesores = [2 1 1 1 1 1 1 1 1 1 1]*1e-3;
parametrosW1.b = (350 + 500 + 247)*1e-3;
parametrosW1 = momentopolar(parametrosW1);



    % Sección W1_LL
    % de momento suponemos que delante y detras es igual. Larguerillos
    % considerando seccion de atras y resto de valores son las medias.
    parametrosW1LL.t = 2e-3;
    parametrosW1LL.b = 0.5 * (247 + 350) * 1e-3; % base
    parametrosW1LL.h = 0.5 * (240 + 169) * 1e-3; % altura
    parametrosW1LL.tpiel = 1e-3 ;
    parametrosW1LL.Larguerillos.Areas = [50; 50]*1e-6;
    parametrosW1LL.Larguerillos.Coord = [128*1e-3 parametrosW1LL.b/2;...
                                         128*1e-3 -parametrosW1LL.b/2];
    % Área y Momentos de Inercia
    [A_W1LL, Iy_W1LL, Iz_W1LL, Ix_W1LL] = Propiedades_Seccion_C(parametrosW1LL);
    % Momento Polar (El módulo de torsión es GJ)
    J_W1LL = parametrosW1.Jtotal * parametrosW1LL.b / 2 / parametrosW1.b;

    % Sección W1LC
    parametrosW1LC.t = 10e-3;
    parametrosW1LC.b = 0.5;
    parametrosW1LC.h = 0.24;
    parametrosW1LC.tpiel = 1e-3;
    parametrosW1LC.Larguerillos.Areas = 50e-6 * ones(8,1);
    parametrosW1LC.Larguerillos.Coord = [75*1e-3 parametrosW1LC.b/2;...
                                        -75*1e-3 parametrosW1LC.b/2;...
                                        75*1e-3 -parametrosW1LC.b/2;...
                                        -75*1e-3 -parametrosW1LC.b/2;...
                                        188*1e-3 parametrosW1LC.b/2;...
                                        -188*1e-3 parametrosW1LC.b/2;...
                                        188*1e-3 -parametrosW1LC.b/2;...
                                        -188*1e-3 -parametrosW1LC.b/2];
    % Área y Momentos de Inercia
    [A_W1LC, Iy_W1LC, Iz_W1LC, Ix_W1LC] = Propiedades_Seccion_I(parametrosW2LC);
    % Momento Polar (El módulo de torsión es GJ)
    J_W1LC = parametrosW1.Jtotal * parametrosW1LC.b / 2 / parametrosW1.b;

    % Sección W2_CO
    parametrosW1CO.t = 2e-3;
    parametrosW1CO.st = 0.5588;
    parametrosW1CO.b = parametrosW1CO.st; % base
    parametrosW1CO.h = 0.5 * (240 + 169) * 1e-3; % altura
    parametrosW1CO.tpiel = 1e-3 ;
    

    % Área y Momentos de Inercia
    [A_W1CO, Iy_W1CO, Iz_W1CO, Ix_W1CO] = Propiedades_Seccion_I(parametrosW1CO);
    % Momento Polar (El módulo de torsión es GJ)
    J_W1CO = parametrosW1.Jtotal * parametrosW1CO.st / 2 / parametrosW1.b;

%% SECCIÓN ES 
% Primera aproximación como 2 secciones C
parametrosES.Coords = [1353.5  1242   ;...
                       1353.5  1157   ;...
                       1153.5  1147   ;...
                       953.5   1150   ;...
                       899     1156   ;...
                       815.5   1179   ;...
                       793.5   1199   ;...
                       815.5   1221.5 ;...
                       899     1244.5 ;...
                       953.5   1249   ;...
                       1153.5  1253]*1e-3;
parametrosES.espesores = [4 1 1 1 1 1 1 1 1 1]*1e-3;
parametrosES.b = (560)*1e-3;
parametrosES = momentopolar(parametrosES); %% Para esta config, el larguero principal del ES no está siendo considerado



    % Sección ES_LA
    parametrosESLA.t = 4e-3;
    parametrosESLA.b = 200e-3;
    parametrosESLA.h = 0.5 * (99 + 85)*1e-3;
    parametrosESLA.tpiel = 1e-3; %%%%% CUIDADO, NO SALE VALOR

    % Área y Momentos de Inercia
    [A_ESLA, Iy_ESLA, Iz_ESLA, Ix_ESLA] = Propiedades_Seccion_C(parametrosESLA);
    % Momento Polar (El módulo de torsión es GJ)
    J_ESLA = parametrosES.Jtotal * parametrosESLA.b / 2 / parametrosES.b;

    % Sección ES_CO
    parametrosESCO.t = 2e-3;
    parametrosESCO.st = 0.375;
    parametrosESCO.b = parametrosESCO.st; % base
    parametrosESCO.h = 0.5 * (99 + 85) * 1e-3; % altura
    parametrosESCO.tpiel = 1e-3 ;
    

    % Área y Momentos de Inercia
    [A_ESCO, Iy_ESCO, Iz_ESCO, Ix_ESCO] = Propiedades_Seccion_I(parametrosESCO);
    % Momento Polar (El módulo de torsión es GJ)
    J_ESCO = parametrosES.Jtotal * parametrosESCO.st / 2 / parametrosES.b;

%% SECCIONES FUSELAJE
% Sección F1
parametrosF1.b = 1010e-3;
parametrosF1.h = 800e-3;
parametrosF1.rsup = 180e-3;
parametrosF1.rinf = 50e-3;
parametrosF1.tpiel = 2e-3;
parametrosF1.Coords = coord_fuselaje(parametrosF1);
parametrosF1.espesores = parametrosF1.tpiel * ones(1,size(parametrosF1.Coords,1));

% Área y Momentos de Inercia
[A_F1, Iy_F1, Iz_F1, Ix_F1] = Propiedades_Seccion_O(parametrosF1);
% Momento Polar
parametrosF1 = momentopolar(parametrosF1);
J_F1 = parametrosF1.Jtotal;

% Sección F2
parametrosF2.b = 1200e-3;     % <--- Modificar valor si es distinto a F1
parametrosF2.h = 1200e-3;      % <--- Modificar valor
parametrosF2.rsup = 400e-3;   % <--- Modificar valor
parametrosF2.rinf = 82.5e-3;    % <--- Modificar valor
parametrosF2.tpiel = 2e-3;    % <--- Modificar valor
parametrosF2.Coords = coord_fuselaje(parametrosF2);
parametrosF2.espesores = parametrosF2.tpiel * ones(1,size(parametrosF2.Coords,1));

% Área y Momentos de Inercia
[A_F2, Iy_F2, Iz_F2, Ix_F2] = Propiedades_Seccion_O(parametrosF2);
% Momento Polar
parametrosF2 = momentopolar(parametrosF2);
J_F2 = parametrosF2.Jtotal;

% Sección F3
parametrosF3.b = 1000e-3;
parametrosF3.h = 1000e-3;
parametrosF3.rsup = 220e-3;
parametrosF3.rinf = 59.5e-3;
parametrosF3.tpiel = 2e-3;
parametrosF3.Coords = coord_fuselaje(parametrosF3);
parametrosF3.espesores = parametrosF3.tpiel * ones(1,size(parametrosF3.Coords,1));

% Área y Momentos de Inercia
[A_F3, Iy_F3, Iz_F3, Ix_F3] = Propiedades_Seccion_O(parametrosF3);
% Momento Polar
parametrosF3 = momentopolar(parametrosF3);
J_F3 = parametrosF3.Jtotal;

% Sección F4
parametrosF4.b = 800e-3;
parametrosF4.h = 800e-3;
parametrosF4.rsup = 167.5e-3;
parametrosF4.rinf = 54e-3;
parametrosF4.tpiel = 2e-3;
parametrosF4.Coords = coord_fuselaje(parametrosF4);
parametrosF4.espesores = parametrosF4.tpiel * ones(1,size(parametrosF4.Coords,1));

% Área y Momentos de Inercia
[A_F4, Iy_F4, Iz_F4, Ix_F4] = Propiedades_Seccion_O(parametrosF4);
% Momento Polar
parametrosF4 = momentopolar(parametrosF4);
J_F4 = parametrosF4.Jtotal;

% Sección F5
parametrosF5.b = 500e-3;
parametrosF5.h = 600e-3;
parametrosF5.rsup = 170e-3;
parametrosF5.rinf = 55.5e-3;
parametrosF5.tpiel = 2e-3;
parametrosF5.Coords = coord_fuselaje(parametrosF5);
parametrosF5.espesores = parametrosF5.tpiel * ones(1,size(parametrosF5.Coords,1));

% Área y Momentos de Inercia
[A_F5, Iy_F5, Iz_F5, Ix_F5] = Propiedades_Seccion_O(parametrosF5);
% Momento Polar
parametrosF5 = momentopolar(parametrosF5);
J_F5 = parametrosF5.Jtotal;
%% Objetivo final: Matriz ESTRUCTURA.PropiedadesMecanicas
% Matriz de tamaño: Num_elementos x 8
% Propiedades asociadas a elementos W2_LC

propiedades = zeros(14,8);

% --- FUSELAJES (F1 - F5) ---
propiedades(1,:) = [1, E*Iy_F1, G*J_F1, rho*A_F1, rho*Ix_F1, rho*Iy_F1, 0.5574, 0];
propiedades(2,:) = [2, E*Iy_F2, G*J_F2, rho*A_F2, rho*Ix_F2, rho*Iy_F2, 0.5574, 0];
propiedades(3,:) = [3, E*Iy_F3, G*J_F3, rho*A_F3, rho*Ix_F3, rho*Iy_F3, 0.5574, 0];
propiedades(4,:) = [4, E*Iy_F4, G*J_F4, rho*A_F4, rho*Ix_F4, rho*Iy_F4, 0.5574, 0];
propiedades(5,:) = [5, E*Iy_F5, G*J_F5, rho*A_F5, rho*Ix_F5, rho*Iy_F5, 0.5574, 0];

% --- WRIG ---
propiedades(6,:) = [6, 10*E*Iy_W1CO, 10*G*J_W1CO, 10*rho*A_W1CO, 10*rho*Ix_W1CO, 10*rho*Iy_W1CO, 0.5883, 0];

% --- W1 (Wing 1) ---
propiedades(7,:) = [7, E*Iy_W1CO, G*J_W1CO, rho*A_W1CO, rho*Ix_W1CO, rho*Iy_W1CO, 0.5883, 0];
propiedades(8,:) = [8, E*Iy_W1LC, G*J_W1LC, rho*A_W1LC, rho*Ix_W1LC, rho*Iy_W1LC, 0.5, 0];
propiedades(9,:) = [9, E*Iy_W1LL, G*J_W1LL, rho*A_W1LL, rho*Ix_W1LL, rho*Iy_W1LL, 0.5, 0];

% --- W2 (Wing 2) ---
propiedades(10,:) = [10, E*Iy_W2CO, G*J_W2CO, rho*A_W2CO, rho*Ix_W2CO, rho*Iy_W2CO, 0.5883, 0];
propiedades(11,:) = [11, E*Iy_W2LL, G*J_W2LL, rho*A_W2LL, rho*Ix_W2LL, rho*Iy_W2LL, 0.5, 0];
propiedades(12,:) = [12, E*Iy_W2LC, G*J_W2LC, rho*A_W2LC, rho*Ix_W2LC, rho*Iy_W2LC, 0.5, 0];

% --- ES (Estabilizadores) ---
propiedades(13,:) = [13, E*Iy_ESLA, G*J_ESLA, rho*A_ESLA, rho*Ix_ESLA, rho*Iy_ESLA, 0.4, 0];
propiedades(14,:) = [14, E*Iy_ESCO, G*J_ESCO, rho*A_ESCO, rho*Ix_ESCO, rho*Iy_ESCO, 0.375, 0];


% Número total de familias 
num_familias = size(propiedades, 1);

for i = 1:num_familias
    % 1. Extraer la fila de propiedades correspondiente a la familia 'i'
    fila_propiedades = propiedades(i, :);
    
    % 2. Obtener el ID de la familia (está en la columna 1)
    familia_id = fila_propiedades(1);
    
    % 3. Buscar qué elementos de la estructura tienen esa etiqueta
    % Devuelve un vector lógico (true/false)
    labels_elemento_familia = (ESTRUCTURA.ID_elem == familia_id);
    
    % 4. Contar cuántos elementos son (necesario para la matriz de unos)
    numero_elementos_familia = sum(labels_elemento_familia);
    
    % 5. Asignar valores solo si existen elementos de esa familia
    if numero_elementos_familia > 0
        ESTRUCTURA.PropiedadesMecanicas(labels_elemento_familia, :) = ...
            ones(numero_elementos_familia, 1) * fila_propiedades;
    end
end
ESTRUCTURA = calculo_geometria(ESTRUCTURA);

% % ¿Qué elementos pertenecen a la familia de etiqueta "familia"?
% fila_propiedades = [familia, EI, GJ, rho_A, rho_Ix, rho_Iy, L, alpha];
% labels_elemento_familia = (ESTRUCTURA.ID_elem == familia);
% numero_elementos_familia = sum(labels_elemento_familia);
% ESTRUCTURA.PropiedadesMecanicas(labels_elemento_familia,:) = ones(numero_elementos_familia,1) * fila_propiedades;

end