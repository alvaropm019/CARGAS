function f = f_Sin 
% FUNCIÓN EXCITACIÓN, f(t)
% RAMPA - ESCALON - RAMPA


% Frecuencia
w0 = 6;        ... frecuencia inicial
% Periodo
T = 2*pi/w0;
% Number of periods
n = 6;
% Interval with sin(t-t0)
% initial
t0 = 5;
% final
tfin = t0 + n * T;

% magnitud maxima
f0 = 1;


% Valor de la funcion
f = @(t) f0 * (heaviside(t-t0) - heaviside(t-tfin)) .* sin(w0 * (t-t0));

end
