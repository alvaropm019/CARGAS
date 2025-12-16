function ESTRUCTURA = PropiedadesMasas(ESTRUCTURA)

% Creación de los diferentes campos con la asignación de las masas
% puntuales a cada nodo usando la función getMasasPuntuales().

ESTRUCTURA.MasasPuntuales.Ala = getMasasPuntuales(ESTRUCTURA, 'Ala');
ESTRUCTURA.MasasPuntuales.Tren = getMasasPuntuales(ESTRUCTURA, 'Tren');
ESTRUCTURA.MasasPuntuales.Estabilizador = getMasasPuntuales(ESTRUCTURA, 'Estabilizador');
ESTRUCTURA.MasasPuntuales.Motor = getMasasPuntuales(ESTRUCTURA, 'Motor');
ESTRUCTURA.MasasPuntuales.Cargo = getMasasPuntuales(ESTRUCTURA, 'Cargo');
ESTRUCTURA.MasasPuntuales.Combustible = getMasasPuntuales(ESTRUCTURA, 'Combustible');
ESTRUCTURA.MasasPuntuales.DerivaVertical = getMasasPuntuales(ESTRUCTURA, 'DerivaVertical');


end