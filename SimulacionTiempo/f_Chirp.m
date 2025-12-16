function f = f_Chirp 
% FUNCIÓN EXCITACIÓN, f(t)
% RAMPA - ESCALON - RAMPA


% Insante maximo (media)
wini = 9*2*pi;        ... frecuencia inicial
wfin = 40*2*pi;        ... frecuencia final

% Instante inicial
alpha_0 = 0;    ... initial angle
t0      = 2;    ... initial time
T       = 20;   ... time it takes to sweep from wini to wfin
c       = (wfin - wini) / T; ... chirp rate


% magnitud maxima
f0 = 0.4;


% Valor de la funcion
f = @(t) f0 * (heaviside(t-t0) - heaviside(t-t0-T)) .* sin(alpha_0 + c * (t-t0).^2/2 + wini * (t-t0));

end
