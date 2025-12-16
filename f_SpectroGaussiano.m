function f = f_SpectroGaussiano 
% FUNCIÓN EXCITACIÓN, f(t)
% Spectro Gaussiano: tiene una distribucion de frecuencias Gaussiana
% alrededor de la frecuencia "w0" y con desv. "sigma"
% La señal está centrada en el instante t=t0;


% Insante maximo (media)
t0 = 10.0;        ... instante maximo
w0 = 5;         ... frecuencia centrada en el espectro
sigma = 0.1*w0; ... % Desviacion tipica en frecuencia


% magnitud
f0 = 4;


% Valor de la funcion
f = @(t) f0 * cos(w0 * (t - t0)) .* (sigma/sqrt(2*pi)) .* exp(- sigma^2 .* (t - t0).^2/2);

end
