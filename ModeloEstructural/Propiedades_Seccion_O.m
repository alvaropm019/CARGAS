function [A_O, Iy_O, Iz_O, Ix_O] = Propiedades_Seccion_O(parametros)


% ------------------------------------------------
%                            (1)   
%           ·-----------------·--·    
%           |/                 \ | 
%           |                   \|
%           |                    ·    (2)
%           |                    |
%           |                    |
%           |                    | 
%           |                    |
%           |                    |
%           |                    ·    (3)
%           |                   /|
%           |\                 / |
%           ·----------------·---·    
%                           (4)
% ------------------------------------------------
%
% Los / o \ son secciones circulares
% Se darán la base, altura y radios superior e inferior de la sección
% Los elementos serán enumerados empezando por el tramo vertical derecho,
% continuando en sentido horario primero con los lados recta y continuando
% (seria el 5 elemento) con el arco de arriba derecha y continuando con los
% arcos en sentido horario

b = parametros.b;
h = parametros.h;
rsup = parametros.rsup;
rinf = parametros.rinf;
tpiel = parametros.tpiel;


if isfield(parametros, 'Larguerillos')
    % El campo 'Larguerillos' SÍ existe en parametros
    Larguerillos = parametros.Larguerillos;
    AreasL = Larguerillos.Areas;
    y_l = Larguerillos.Coord(:,1);
    z_l = Larguerillos.Coord(:,2);
else
    AreasL = [];
    y_l = [];
    z_l = [];
end

L1 = h - rsup - rinf;
L2 = b - 2 * rinf;
L3 = L1;
L4 = b - 2 * rsup;
L5 = 0.5 * pi * rsup;
L6 = 0.5 * pi * rinf;
L7 = L6;
L8 = L5;

Lvec = [L1;L2;L3;L4;L5;L6;L7;L8];
Avec = tpiel * Lvec;

A1 = L1*tpiel;
A2 = L2*tpiel;
A3 = A1;
A4 = L4*tpiel;
A5 = L5*tpiel;
A6 = L6*tpiel;
A7 = A6;
A8 = A5;

% Centroides elementos
% Elementos rectos
y01 = b/2;
z01 = 0;

y02 = 0;
z02 = -h/2;

y03 = -b/2;
z03 = 0;

y04 = 0;
z04 = h/2;

% Arcos
% Cálculo de centros de arcos
yc5 = b/2 - rsup;
zc5 = h/2 - rsup;
% Cálculo centroide
y05 = yc5 + 2 * rsup / pi;
z05 = zc5 + 2 * rsup / pi;

yc6 = b/2 - rinf;
zc6 = -(h/2 - rinf);
y06 = yc6 + 2 * rinf / pi;
z06 = zc6 - 2 * rinf / pi;

y07 = -y06;
z07 = z06;

y08 = -y05;
z08 = z05;

y0 = [y01;y02;y03;y04;y05;y06;y07;y08];
z0 = [z01;z02;z03;z04;z05;z06;z07;z08];

Area = sum(Avec);
yc = (sum(Avec .* z0) + sum(AreasL .* z_l)) / (Area + sum(AreasL));
zc = (sum(Avec .* y0) + sum(AreasL .* y_l)) / (Area + sum(AreasL));




% Momentos de inercia de cada elemento
Iy1p = 1/12 * L1^3 * tpiel;
Iz1p = 0;

Iy2p = 0;
Iz2p = 1/12 * L2^3 * tpiel;

Iy3p = Iy1p;
Iz3p = Iz1p;

Iy4p = 0;
Iz4p = 1/12 * L4^3 * tpiel;

Iy5p = pi/4 * ((rsup + tpiel/2)^4 - (rsup - tpiel/2)^4);
Iz5p = pi/4 * ((rsup + tpiel/2)^4 - (rsup - tpiel/2)^4);

Iy6p = pi/4 * ((rinf + tpiel/2)^4 - (rinf - tpiel/2)^4);
Iz6p = pi/4 * ((rinf + tpiel/2)^4 - (rinf - tpiel/2)^4);

Iy7p = Iy6p;
Iz7p = Iz6p;

Iy8p = Iy5p;
Iz8p = Iz5p;

Iyp = [Iy1p; Iy2p; Iy3p; Iy4p; Iy5p; Iy6p; Iy7p; Iy8p];
Izp = [Iz1p; Iz2p; Iz3p; Iz4p; Iz5p; Iz6p; Iz7p; Iz8p];

Iy_O = sum(Iyp) + sum(Avec .* (zc - z0).^2) + sum(AreasL .* (zc - z_l).^2);
Iz_O = sum(Izp) + sum(Avec .* (yc - y0).^2) + sum(AreasL .* (yc - y_l).^2);
Ix_O = Iy_O + Iz_O;
A_O = Area + sum(AreasL);

end