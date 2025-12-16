function f = f_ImpactoGaussiano 
% FUNCIÓN EXCITACIÓN, f(t)
% RAMPA - ESCALON - RAMPA


% Insante maximo (media)
t0 = 5;

% Desviacion tipica
sig = 0.05*t0;

% Impulso (area bajo la curva f(t))
I0 = 1;
% magnitud maxima
f0 = I0 / (sqrt(2*pi) * sig);


% Valor de la funcion
f = @(t) f0 * exp(- (t - t0).^2 / (2 * sig^2));

end
