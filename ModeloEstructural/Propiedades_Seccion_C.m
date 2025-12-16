function [A_C, Iy_C, Iz_C, Ix_C] = Propiedades_Seccion_C(parametros_C)


% ------------------------------------------------
%           ------------    (2)
%           |    |     |
%           |
%           |               (1)
%           |
%           |    |     |
%           ------------    (3)
% ------------------------------------------------

t = parametros_C.t;
b = parametros_C.b;
h = parametros_C.h;
tpiel = parametros_C.tpiel;

if isfield(parametros_C, 'Larguerillos')
    % El campo 'Larguerillos' SÍ existe en parametros_C
    Larguerillos = parametros_C.Larguerillos;
    Areas = Larguerillos.Areas;
    y_l = Larguerillos.Coord(:,1);
    z_l = Larguerillos.Coord(:,2);
else
    Areas = [];
    y_l = [];
    z_l = [];
end

A1 = h * t;
A2 = b * tpiel;
A3 = b * tpiel;
A_C = A1 + A2 + A3 + sum(Areas);

yc = (b/2*(A2 + A3) + sum(z_l .* Areas)) / A_C;
zc = (b/2*(A2 - A3) + sum(z_l .* Areas)) / A_C;

y1 = 0;
z1 = 0;
y2 = b/2;
z2 = h/2;
y3 = b/2;
z3 = -h/2;

Iy_C = 1/12 * h^3 * t + 2 * b * tpiel * (h/2)^2 + sum(Areas .* (zc -z_l).^2);
Iz_C = 2/12 * b^3 * tpiel + +sum(Areas .* (yc - y_l).^2);
Ix_C = Iy_C + Iz_C;

end