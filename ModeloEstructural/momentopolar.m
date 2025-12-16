function parametros = momentopolar(parametros)
% MOMENTOPOLAR Calcula el área encerrada y el momento polar Jtotal
% para una sección de pared delgada cerrada.
%
%   parametros = momentopolar(parametros)
%
%   Campos de entrada esperados en 'parametros':
%       .Coords      -> matriz Nx2 con las coordenadas [x_i, y_i]
%       .espesores   -> vector con los espesores t_i de cada tramo
%
%   Campos añadidos de salida:
%       .Areatotal   -> área encerrada por el contorno
%       .Jtotal      -> Jtotal = 4*A^2 / sum( L_i / t_i )

    % Extraer datos
    Coords = parametros.Coords;
    t_in   = parametros.espesores(:);      % asegurar columna

    nPuntos = size(Coords, 1);

    % --- Área encerrada usando polyarea (cierra el polígono automáticamente) ---
    x = Coords(:,1);
    y = Coords(:,2);
    A = polyarea(x, y);    % área positiva

    % --- Longitudes de cada tramo L_i ---
    % Cerrar el contorno: del último punto al primero
    Coords_cerradas = [Coords; Coords(1,:)];
    diffs = diff(Coords_cerradas, 1, 1);          % diferencias entre puntos consecutivos
    Li = sqrt(diffs(:,1).^2 + diffs(:,2).^2);     % vector de longitudes

    % --- Ajuste de espesores al número de tramos ---
    nTramos = numel(Li);
    nEsp    = numel(t_in);

    if nEsp == nTramos
        t = t_in;
    elseif nEsp == nTramos - 1
        % Si hay un espesor menos, asumimos que el último tramo
        % tiene el mismo espesor que el último dato dado
        t = [t_in; t_in(end)];
    else
        error('El número de espesores (%d) no es compatible con el número de tramos (%d).', ...
               nEsp, nTramos);
    end

    % --- Cálculo de Jtotal ---
    suma_Li_ti = sum(Li ./ t);
    Jtotal = 4 * A^2 / suma_Li_ti;

    % --- Guardar resultados en el struct ---
    parametros.Areatotal = A;
    parametros.Jtotal    = Jtotal;
end
