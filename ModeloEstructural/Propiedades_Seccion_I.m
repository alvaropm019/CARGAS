function [A_I, Iy_I, Iz_I, Ix_I] = Propiedades_Seccion_I(parametros_I)


% ------------------------------------------------
%      ----------------------    (2)
%      |    |    |    |     |
%                |
%                |
%                |               (1)
%                |
%                |
%      |    |    |    |     |
%      ----------------------    (3)
% ------------------------------------------------

t = parametros_I.t;
b = parametros_I.b;
h = parametros_I.h;
tpiel = parametros_I.tpiel;

if isfield(parametros_I, 'Larguerillos')
    % El campo 'Larguerillos' SÍ existe en parametros_I
    Larguerillos = parametros_I.Larguerillos;
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
A_I = A1 + A2 + A3 + sum(Areas);

yc = (0*(A2 + A3) + sum(y_l .* Areas)) / A_I;
zc = (b/2*(A2 - A3) + sum(z_l .* Areas)) / A_I;

y1 = 0;
z1 = 0;
y2 = 0;
z2 = h/2;
y3 = 0;
z3 = -h/2;

Iy_I = 1/12 * h^3 * t + + 2 * A2 * (h/2)^2 + sum(Areas .* (zc - z_l).^2);
Iz_I = 2/12 * b^3 * tpiel + A1 * y1^2 + A2 * y2^2 + sum(Areas .* (yc - y_l).^2);
Ix_I = Iy_I + Iz_I;

end