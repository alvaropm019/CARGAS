% =========================================================================
% SCRIPT PRINCIPAL: COMPARATIVA RK vs FFT (MODELO 2D)
% =========================================================================
clearvars -except ESTRUCTURA; close all; clc;
addpath("Modelo Estructural\")
addpath("Representaciones\")
addpath("Simulacion Tiempo\")
%% 1. INPUTS DE USUARIO (Configuración)
% Definición de nodos de interés
nodo_fuerza = 20;                % Nodo donde se aplica la carga
nodos_observacion = [1, 20, 77]; % Nodos a graficar
direccion_gdl = 3;               

% Función temporal
f_exc = f_Chirp; % Obtenemos el handle

% Parámetros de simulación
tmax = 30;                      % Tiempo total de simulación [s]
N_fft = 2^15;                    % Muestras para FFT (32768)

% --- SELECCIÓN DE MODOS (CORRECCIÓN 2D) ---
% Problema 2D -> 3 Modos de Sólido Rígido (1, 2, 3)
% Empezamos desde el modo 4.
modo_max = 30;                   % Hasta qué modo queremos incluir
rango_modos = 4:modo_max;        % <--- CAMBIO AQUÍ: Del 4 en adelante

%% 2. PREPARACIÓN DEL MODELO
fprintf('Inicializando modelo estructural 2D...\n');
if ~exist('ESTRUCTURA','var'), main_datos; end

K = Rigidez(ESTRUCTURA);
M = Masa(ESTRUCTURA);
n_gdl_total = ESTRUCTURA.NumGDL;
gdl_por_nodo = 3; % Asumimos 3 GDL por nodo en tu modelo 2D

% Cálculo de modos
[V, D] = eig(K, M);
w_nat = sqrt(diag(D));
[w_nat, id] = sort(real(w_nat)); % Ordenar frecuencias
V = V(:, id);                    % Ordenar modos

% Normalización Masa-Unitaria (phi' * M * phi = 1)
for j = 1 : n_gdl_total
    norm_factor = 1 / sqrt(V(:,j)' * M * V(:,j));
    V(:,j) = V(:,j) * norm_factor;
end

% Recorte de matrices (Proyección Modal)
wm = w_nat(rango_modos);
Vm = V(:, rango_modos);

% Definición de Amortiguamiento
% Extendemos el vector base a todo el tamaño para evitar errores de índice
zeta_base = 0.0290 * ones(n_gdl_total, 1);
zeta_valores_bajos = [0.0020; 0.0025; 0.0030; 0.0035; 0.0042; 0.0048; 
                      0.0055; 0.0063; 0.0072; 0.0080; 0.0090; 0.0100; 
                      0.0115; 0.0130; 0.0145; 0.0160; 0.0178; 0.0195; 
                      0.0215; 0.0230; 0.0245; 0.0260; 0.0275; 0.0290];
% Asignamos los valores conocidos a los primeros modos
zeta_base(1:length(zeta_valores_bajos)) = zeta_valores_bajos;

% Seleccionamos SOLO los amortiguamientos correspondientes a los modos elásticos elegidos
zeta = zeta_base(rango_modos);

%% 3. CONFIGURACIÓN DE LA FUERZA
% Vector espacial de fuerza
gdl_f = zeros(n_gdl_total, 1);
idx_fuerza = (nodo_fuerza - 1) * gdl_por_nodo + direccion_gdl;
gdl_f(idx_fuerza) = 1;



%% 4. CÁLCULO: MÉTODO RK (ODE45)
fprintf('Calculando respuesta temporal (Runge-Kutta)...\n');
tic;
[t_rk, u_rk] = Solucion_MetodoRK(wm, Vm, zeta, tmax, gdl_f, f_exc);
tiempo_rk = toc;
fprintf(' -> RK completado en %.2f s\n', tiempo_rk);

%% 5. CÁLCULO: MÉTODO FFT (ESPECTRAL)
fprintf('Calculando respuesta espectral (FFT)...\n');
tic;
[t_fft, u_fft] = Solucion_MetodoFFT(wm, Vm, zeta, tmax, gdl_f, f_exc, N_fft);
tiempo_fft = toc;
fprintf(' -> FFT completada en %.2f s\n', tiempo_fft);

%% 6. VISUALIZACIÓN COMPARATIVA (3 SUBPLOTS)
figure('Name', 'Comparativa RK vs FFT (Modelo 2D)', 'Color', 'w', 'Position', [100, 100, 1000, 800]);

nombres_nodos = {'Fuselaje', 'Ala', 'Estabilizador' };

for i = 1:3
    nodo_actual = nodos_observacion(i);
    idx_col = (nodo_actual - 1) * gdl_por_nodo + direccion_gdl;
    
    subplot(3, 1, i);
    
    % Graficar RK (Azul sólido)
    plot(t_rk, u_rk(:, idx_col), 'b-', 'LineWidth', 1.5); hold on;
    
    % Graficar FFT (Rojo discontinuo)
    plot(t_fft, u_fft(:, idx_col), 'r--', 'LineWidth', 1.5);
    
    grid on;
    ylabel('Desplazamiento [m]'); % Etiqueta genérica por si la dirección cambia
    
    title(sprintf('Nodo %d (%s)', nodo_actual, nombres_nodos{i}), 'FontWeight', 'bold');
    
    if i == 1
        legend('Método RK', 'Método FFT', 'Location', 'northeast');
    end
end

xlabel('Tiempo [s]');
linkaxes(findall(gcf,'type','axes'), 'x');

fprintf('\nProceso finalizado.\n');


AnimacionTiempo(ESTRUCTURA,u_rk',50)