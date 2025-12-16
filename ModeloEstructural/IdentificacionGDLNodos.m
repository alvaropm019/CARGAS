function id = IdentificacionGDLNodos(e, MatrizConexion, MatrizGdlNodos)

% e                 es el número del elemento,

% MatrizConexion    indica qué nodos pertenecen al elemento,
%                   Es una matriz [Ne x 2], donde la primera columna denota
%                   el nodo inicial del elemento y la segunda el final.


% MatrizGdlNodos    asigna los gdl a cada nodo. Es una matriz [Nn x 3]. 
%                   Cada fila, correspondiente al nodo con el índice de la
%                   fila, contiene la posición en el vector de GDL globales
%                   que le corresponde a dicho nodo

% id indica que grados de libertad corresponden al elemento 'e'

id = zeros(1,6);

nodos = MatrizConexion(e,:);
nodo_inicial = nodos(1);
nodo_final = nodos(2);

gdls_nodo_inicial = MatrizGdlNodos(nodo_inicial,:);
gdls_nodo_final = MatrizGdlNodos(nodo_final,:);

id = [gdls_nodo_inicial, gdls_nodo_final];
end