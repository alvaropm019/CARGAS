function M = MatrizMasa(ESTRUCTURA)
% ESTA NO SE USA. Cuando todo este definido borrar



% Matriz de masas
% Dos componentes:
% M = M_estructura + M_no_estructura
% M_estructura se calcula por ensamblaje (como la K)
% M_no_estructura se calcula apartir de las masas puntuales.
%% Inicialización 
NumGdl = ESTRUCTURA.NumGDL;
NumElem = ESTRUCTURA.NumElem;
MatrizPropiedades = ESTRUCTURA.PropiedadesMecanicas;
MatrizConexion  = ESTRUCTURA.Conect;
MatrizGDLNodos = ESTRUCTURA.GDL;

%% Matriz de masas asociadas a los elementos

M_estructura = zeros(NumGdl, NumGdl);

for e = 1 : NumElem
    % Cargo las propiedades del elemento
    rhoA = MatrizPropiedades(e, 4);
    rhoIx = MatrizPropiedades(e, 5);
    rhoIy = MatrizPropiedades(e, 6);
    L = MatrizPropiedades(e, 7);
    alpha = MatrizPropiedades(e, 8);
    
    % Matriz de masa del elemento
    M_elemento = MasaElemento(rhoA, rhoIx, rhoIy, L, a);

    % Ensamblaje
    % GDL elemento
    id = IdentificacionGdlNodos(e, MatrizConexion, MatrizGDLNodos);
    % Actualización matriz global estructura
    M_estructura(id, id) = M_estructura(id, id) + M_elemento;

end

%% Matriz de masas no estructurales
% Diferentes casos : 7 en total

%  ESTRUCTURA.MasasPuntuales.Ala:
%  ESTRUCTURA.MasasPuntuales.Tren:
%  ESTRUCTURA.MasasPuntuales.Estabilizador:
%  ESTRUCTURA.MasasPuntuales.Motor:
%  ESTRUCTURA.MasasPuntuales.Cargo:
%  ESTRUCTURA.MasasPuntuales.Combustible:
%  ESTRUCTURA.MasasPuntuales.DerivaVertical:

% ALA
ESTRUCTURA.MasasPuntuales.Ala = getMasasPuntuales(MatrizGDLNodos, 'Ala');
ESTRUCTURA.MasasPuntuales.Tren = getMasasPuntuales(MatrizGDLNodos, 'Tren');
ESTRUCTURA.MasasPuntuales.Estabilizador = getMasasPuntuales(MatrizGDLNodos, 'Estabilizador');
ESTRUCTURA.MasasPuntuales.Motor = getMasasPuntuales(MatrizGDLNodos, 'Motor');
ESTRUCTURA.MasasPuntuales.Cargo = getMasasPuntuales(MatrizGDLNodos, 'Cargo');
ESTRUCTURA.MasasPuntuales.Combustible = getMasasPuntuales(MatrizGDLNodos, 'Combustible');
ESTRUCTURA.MasasPuntuales.DerivaVertical = getMasasPuntuales(MatrizGDLNodos, 'DerivaVertical');



% Inicialización
M_no_estructura = zeros(NumGdl, NumGdl);

% Asignación a la Matriz global
nombresCampos = fieldnames(ESTRUCTURA.MasasPuntuales);
for i = 1 : numel(ESTRUCTURA.MasasPuntuales)
    vector_masas_puntuales = nombresCampos{i};
    M_no_estructura  = M_no_estructura + diag(vector_masas_puntuales);
end


%% Sumamos ambas contribuciones
M  = M_estructura + M_no_estructura;

end