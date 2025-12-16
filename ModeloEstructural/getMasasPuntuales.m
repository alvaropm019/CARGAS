function masas_puntuales = getMasasPuntuales(ESTRUCTURA, parte)

MatrizGDLNodos = ESTRUCTURA.GDL;
NumGdl = ESTRUCTURA.NumGDL;
% 
switch parte
    case 'Ala'
    nodos = [76, 44, 43, 42, 41, 40, 39, 18, 15, 28, 29, 30, 31, 32, 33, 75]; 
    MasaTotal = 50;

    case 'Tren'
    nodos = [2, 22, 39, 40, 50, 20, 28, 29, 45]; 
    MasaTotal = 60; 
    
    case 'Estabilizador'
    nodos = [59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 72, 73, 74, 77];
    MasaTotal = 30;
    
    case 'Motor'
    nodos = [1, 2]; 
    MasaTotal = 150;

    case 'Cargo'
    nodos = [2, 3, 4, 5, 6, 7]; 
    MasaTotal = 300;
    
    case 'Combustible'
    nodos = [16, 17, 18, 21, 22, 39, 34, 50, 40, 13, 14, 15, 19, 20, 28, 23, 45, 29]; 
    MasaTotal = 140;
    
    case 'DerivaVertical'
    nodos = [11, 12, 71]; 
    MasaTotal = 40;
end
    


% Masas a la diagonal principal de la matriz de masas en las posiciones
id_gdl_despl_z = MatrizGDLNodos(nodos,3);

Masa_por_nodo = MasaTotal / numel(nodos);

masas_puntuales = zeros(NumGdl,1);
masas_puntuales(id_gdl_despl_z) = Masa_por_nodo;

end