function M = Masa(ESTRUCTURA)

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
    M_elemento = MasaElemento(rhoA, rhoIx, rhoIy, L, alpha);

    % Ensamblaje
    % GDL elemento
    id = IdentificacionGDLNodos(e, MatrizConexion, MatrizGDLNodos);
    % Actualización matriz global estructura
    M_estructura(id, id) = M_estructura(id, id) + M_elemento;

end

%% Matriz de masas no estructurales
% Diferentes casos : 7 en total
% Ya está definido en ESTRUCTURA mediante PropiedadesMasas(ESTRUCTURA)

% Inicialización
M_no_estructura = zeros(NumGdl, NumGdl);

% Asignación a la Matriz global
nombresCampos = fieldnames(ESTRUCTURA.MasasPuntuales);
for i = 1 : length(nombresCampos)
    campo = nombresCampos{i};
    vector_masas_puntuales = ESTRUCTURA.MasasPuntuales.(campo);
    M_no_estructura  = M_no_estructura + diag(vector_masas_puntuales);
end


%% Sumamos ambas contribuciones
M  = M_estructura + M_no_estructura;

end