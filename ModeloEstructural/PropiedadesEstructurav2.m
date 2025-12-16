function ESTRUCTURA = PropiedadesEstructurav2(ESTRUCTURA)


% Definición de Constantes y Carga
E = 7.0E10; G = 2.6E10; rho = 2.7E3;
    
% Cargamos TODOS los datos geométricos definidos fuera
[F, W, ES] = ObtenerParametrosSecciones();

%% FUSELAJE

% ------F1------
parametrosF1 = F.F1;
% Área y Momentos de Inercia
[A_F1, Iy_F1, Iz_F1, Ix_F1] = Propiedades_Seccion_O(parametrosF1);
% Momento Polar
parametrosF1 = momentopolar(parametrosF1);
J_F1 = parametrosF1.Jtotal;

% ------F2------
parametrosF2 = F.F2;
[A_F2, Iy_F2, Iz_F2, Ix_F2] = Propiedades_Seccion_O(parametrosF2);
parametrosF2 = momentopolar(parametrosF2);
J_F2 = parametrosF2.Jtotal;

% ------F3------
parametrosF3 = F.F3;
[A_F3, Iy_F3, Iz_F3, Ix_F3] = Propiedades_Seccion_O(parametrosF3);
parametrosF3 = momentopolar(parametrosF3);
J_F3 = parametrosF3.Jtotal;

% ------F4------
parametrosF4 = F.F4;
[A_F4, Iy_F4, Iz_F4, Ix_F4] = Propiedades_Seccion_O(parametrosF4);
parametrosF4 = momentopolar(parametrosF4);
J_F4 = parametrosF4.Jtotal;

% ------F5------
parametrosF5 = F.F5;
[A_F5, Iy_F5, Iz_F5, Ix_F5] = Propiedades_Seccion_O(parametrosF5);
parametrosF5 = momentopolar(parametrosF5);
J_F5 = parametrosF5.Jtotal;


%% WING
%----------W2--------------
parametrosW2 = W.W2;
% LL
parametrosW2LL = W.W2.LL;
[A_W2LL, Iy_W2LL, Iz_W2LL, Ix_W2LL] = Propiedades_Seccion_C(parametrosW2LL);
J_W2LL = parametrosW2.Jtotal * parametrosW2LL.b / 2 / parametrosW2.b;

% LC
parametrosW2LC = W.W2.LC;
[A_W2LC, Iy_W2LC, Iz_W2LC, Ix_W2LC] = Propiedades_Seccion_I(parametrosW2LC);
J_W2LC = parametrosW2.Jtotal * parametrosW2LC.b / 2 / parametrosW2.b;

% CO
parametrosW2CO = W.W2.CO;
% Área y Momentos de Inercia
[A_W2CO, Iy_W2CO, Iz_W2CO, Ix_W2CO] = Propiedades_Seccion_I(parametrosW2CO);
J_W2CO = parametrosW2.Jtotal * parametrosW2CO.st / 2 / parametrosW2.b;

%-----------W1-------------
parametrosW1 = W.W1;

% LL
parametrosW1LL = W.W1.LL;
[A_W1LL, Iy_W1LL, Iz_W1LL, Ix_W1LL] = Propiedades_Seccion_C(parametrosW1LL);
J_W1LL = parametrosW1.Jtotal * parametrosW1LL.b / 2 / parametrosW1.b;

% LC 
parametrosW1LC = W.W1.LC;
[A_W1LC, Iy_W1LC, Iz_W1LC, Ix_W1LC] = Propiedades_Seccion_I(parametrosW2LC);
J_W1LC = parametrosW1.Jtotal * parametrosW1LC.b / 2 / parametrosW1.b;

% CO
parametrosW1CO = W.W1.CO;
[A_W1CO, Iy_W1CO, Iz_W1CO, Ix_W1CO] = Propiedades_Seccion_I(parametrosW1CO);
J_W1CO = parametrosW1.Jtotal * parametrosW1CO.st / 2 / parametrosW1.b;

%% ESTABILIZADOR
parametrosES = ES;

% Larguero (LA)
parametrosESLA = ES.LA;
[A_ESLA, Iy_ESLA, Iz_ESLA, Ix_ESLA] = Propiedades_Seccion_C(parametrosESLA);
J_ESLA = parametrosES.Jtotal * parametrosESLA.b / 2 / parametrosES.b;

% Costilla (CO)
parametrosESCO = ES.CO;
[A_ESCO, Iy_ESCO, Iz_ESCO, Ix_ESCO] = Propiedades_Seccion_I(parametrosESCO);
J_ESCO = parametrosES.Jtotal * parametrosESCO.st / 2 / parametrosES.b;

%% ENSAMBLAJE Matriz ESTRUCTURA.PropiedadesMecanicas
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

end