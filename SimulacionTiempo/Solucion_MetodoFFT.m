function [t, u] = Solucion_MetodoFFT(wm, Vm, zeta, tmax, gdl_f, f, N)
% SOLUCION_METODOFFT Calcula la respuesta temporal mediante método espectral (FFT).
%
%   [t, u] = Solucion_MetodoFFT(wm, Vm, zeta, tmax, N, gdl_f, f)
%
%   Argumentos:
%       wm    : Vector (m x 1) de frecuencias naturales [rad/s].
%       Vm    : Matriz modal (n x m) con autovectores masa-unitarios.
%       zeta  : Vector (m x 1) con los ratios de amortiguamiento.
%       tmax  : Tiempo total de simulación [s].
%       gdl_f : Vector (n x 1) de localización de fuerza.
%       f     : Handle de función f(t) que define la excitación temporal.
%       N     : Número de muestras (potencia de 2 recomendada, ej. 2^10).
%
%   Salidas:
%       t     : Vector de tiempos (N x 1).
%       u     : Matriz de respuesta física (N x n).
%

    %% 1. Definición del dominio temporal y frecuencial
    % Vector de tiempos t = linspace(0, tmax, N)
    t = linspace(0, tmax, N)'; 
    dt = t(2) - t(1);
    
    % Vector de frecuencias centrado (w_n)
    % Resolución en frecuencia: dw = 2*pi / T [cite: 263]
    dw = 2 * pi / tmax;
    
    % Rango centrado: -N/2, ..., 0, ..., N/2-1 [cite: 267]
    wn_centrada = (-N/2 : N/2 - 1)' * dw;

    %% 2. Transformada de Fourier de la Fuerza (FFT)
    % Evaluamos la función escalar de fuerza f(t)
    f_val = f(t);
    
    % Aplicamos ventana
    
    % FFT y Centrado
    Fn_natural = fft(f_val, N);
    Fn_centrada = fftshift(Fn_natural); % Centramos espectro en w=0
    
    % Proyección espacial de la fuerza a coordenadas modales
    % Fuerza modal P_j = phi_j^T * F_fisica. 
    % Como F_fisica(t) = gdl_f * f(t), entonces P = Vm' * gdl_f
    P_modal = Vm' * gdl_f; % Vector (m x 1) con la participación de fuerza por modo

    %% 3. Cálculo de la Respuesta en Frecuencia (FRF) Modal
    % Inicializamos matriz de respuestas modales en frecuencia (N muestras x m modos)
    Q_modal_centrada = zeros(N, length(wm));
    
    % Bucle sobre cada modo 'j' para aplicar la Ec. (9) y (10) 
    for j = 1:length(wm)
        w_j = wm(j);      % Frecuencia natural del modo j
        z_j = zeta(j);    % Amortiguamiento del modo j
        p_j = P_modal(j); % Factor de fuerza modal del modo j
        
        % Receptancia dinámica del modo j (masa unitaria asumida en Vm)
        % H_j(w) = 1 / (-w^2 + 2*i*z*w_n*w + w_n^2)
        denom = -wn_centrada.^2 + (1i * 2 * z_j * w_j) .* wn_centrada + w_j^2;
        H_j = 1 ./ denom;
        
        % Respuesta modal en frecuencia: Q_j(w) = H_j(w) * P_j * F(w)
        Q_modal_centrada(:, j) = H_j .* (p_j * Fn_centrada);
    end

    %% 4. Reconstrucción de la Respuesta Física en Frecuencia
    % U(w) = Suma( phi_j * Q_j(w) ) -> Operación matricial
    % Q_modal_centrada es (N x m) y Vm' es (m x n) -> Resultado (N x n)
    Un_centrada = Q_modal_centrada * Vm';

    %% 5. Transformada Inversa (iFFT) para volver al tiempo    
    % 1. Descentrar frecuencias (ifftshift) para formato estándar de MATLAB
    Un_natural = ifftshift(Un_centrada, 1); % El '1' asegura shift por columnas
    
    % 2. iFFT
    u_complejo = ifft(Un_natural, N, 1);
    
    % 3. Tomar parte real (la parte imaginaria debe ser despreciable/ruido numérico)
    u = real(u_complejo);

end