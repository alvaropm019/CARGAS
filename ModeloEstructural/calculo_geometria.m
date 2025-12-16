function ESTRUCTURA = calculo_geometria(ESTRUCTURA)
    % 1. Extraer coordenadas X e Y de todos los nodos
    % Solo leemos columnas 1 y 2, ignorando Z si existe.
    X = ESTRUCTURA.CoordNodos(:, 1);
    Y = ESTRUCTURA.CoordNodos(:, 2);
    
    % 2. Identificar nodos iniciales y finales usando la matriz de conectividad
    % ESTRUCTURA.Conect es [NumElem x 2]
    nodos_ini = ESTRUCTURA.Conect(:, 1);
    nodos_fin = ESTRUCTURA.Conect(:, 2);

    % 3. Calcular diferencias de coordenadas (Vectorizado)
    % Restamos la coordenada del nodo final menos la del inicial
    dX = X(nodos_fin) - X(nodos_ini);
    dY = Y(nodos_fin) - Y(nodos_ini);

    % 4. Usar cart2pol para obtener Ángulo y Longitud simultáneamente
    % Sintaxis: [theta, rho] = cart2pol(x, y)
    % theta corresponde a alpha (ángulo en radianes)
    % rho corresponde a L (longitud o radio)
    [alpha, L] = cart2pol(dX, dY);

    % 5. Asignar a la matriz PropiedadesMecanicas
    % Columna 7 = L, Columna 8 = alpha
    ESTRUCTURA.PropiedadesMecanicas(:, 7) = L;
    ESTRUCTURA.PropiedadesMecanicas(:, 8) = alpha;

end