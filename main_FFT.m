% MAIN FFT (Respuesta en Frecuencia)
clearvars -except ESTRUCTURA; close all; clc;

%% DATOS GEOMÉTRICOS Y ESTRUCTURALES
if ~exist('ESTRUCTURA','var')
    main_datos % Carga los datos solo si no existen
end

%% CÁLCULO DE MODOS DE VIBRACIÓN
K = Rigidez(ESTRUCTURA);
M = Masa(ESTRUCTURA);
n = ESTRUCTURA.NumGDL;

% Cálculo de autovalores/autovectores
[V, D] = eig(K, M);

% Ordenar las frecuencias (tomamos real para evitar ruido numérico complejo)
w_nat = sqrt(diag(D));
[w_nat, id] = sort(real(w_nat));
V = V(:, id);

% Normalización con la matriz de masa (Masa-Unitaria)
for j = 1 : n
    xj = V(:,j);
    % Factor de escala para que phi' * M * phi = 1
    a = 1 / sqrt(xj' * M * xj); 
    V(:,j) = a * xj;
end

%% DEFINICIÓN DE LA EXCITACIÓN Y AMORTIGUAMIENTO
n = ESTRUCTURA.NumGDL;
modo_max = 27; % Número de modos a utilizar en la superposición

% Definición del vector de fuerza espacial
nodo_aplicacion = 55;
gdl = 3;            
gdl_por_nodo = 3;   % GDLs por nodo 

gdl_f = zeros(n, 1);
idx_fuerza = gdl_por_nodo * (nodo_aplicacion - 1) + gdl;
gdl_f(idx_fuerza) = 1;

% Ratios de amortiguamiento
zeta = 0.0290 * ones(n, 1); 
zeta(1:24) = [
    0.0020; 0.0025; 0.0030; ... 
    0.0035; 0.0042; 0.0048; ... 
    0.0055; 0.0063; 0.0072; ... 
    0.0080; 0.0090; 0.0100; ... 
    0.0115; 0.0130; 0.0145; ... 
    0.0160; 0.0178; 0.0195; ... 
    0.0215; 0.0230; 0.0245; ... 
    0.0260; 0.0275; 0.0290
];

% Recorte de vectores al número de modos elegidos
wm_cut = w_nat(4:modo_max);
Vm_cut = V(:, 4:modo_max);
zeta_cut = zeta(4:modo_max);

%% PARÁMETROS DE SIMULACIÓN Y FFT
tmax = 100;
f = f_Chirp; 

% Número de muestras para la FFT (Potencia de 2 recomendada)
% Para tmax=100s, N=2^15 (32768) da dt = 0.003s -> Fs = 327Hz -> Nyquist = 163Hz
% Esto es suficiente si tu Chirp llega hasta ~120Hz.
N = 2^15; 

%% RESOLUCIÓN MEDIANTE MÉTODO ESPECTRAL (FFT)
fprintf('Calculando respuesta mediante FFT con %d modos...\n', modo_max);

[t_out, u_out] = Solucion_MetodoFFT(wm_cut, Vm_cut, zeta_cut, tmax, gdl_f, f, N);

%% PROCESADO DE RESULTADOS (Puntos Críticos)
% Selección de nodos a visualizar
nodo_ala = 55;           % Punta del ala derecha
nodo_estabilizador = 67; % Punta del estabilizador trasero
nodo_fuselaje = 1;       % Morro del avión

% Cálculo de índices de columna en u_out
idx_ala   = (nodo_ala - 1) * gdl_por_nodo + gdl;
idx_estab = (nodo_estabilizador - 1) * gdl_por_nodo + gdl;
idx_fus   = (nodo_fuselaje - 1) * gdl_por_nodo + gdl;

% Extracción de datos
desp_ala   = u_out(:, idx_ala);
desp_estab = u_out(:, idx_estab);
desp_fus   = u_out(:, idx_fus);


%% Plots
figure('Name', 'Respuesta FFT Separada', 'Color', 'w');

% --- Fila 1: Ala ---
subplot(3, 1, 1);
plot(t_out, desp_ala, 'b', 'LineWidth', 1.2);
grid on;
ylabel('Desp. Vertical [m]');
title(['Respuesta en Ala (Nodo ' num2str(nodo_ala) ')']);
xlim([0, tmax]);

% --- Fila 2: Estabilizador ---
subplot(3, 1, 2);
plot(t_out, desp_estab, 'r', 'LineWidth', 1.2);
grid on;
ylabel('Desp. Vertical [m]');
title(['Respuesta en Estabilizador (Nodo ' num2str(nodo_estabilizador) ')']);
xlim([0, tmax]);

% --- Fila 3: Fuselaje ---
subplot(3, 1, 3);
plot(t_out, desp_fus, 'k', 'LineWidth', 1.2);
grid on;
ylabel('Desp. Vertical [m]');
xlabel('Tiempo [s]'); % El eje X solo hace falta abajo del todo
title(['Respuesta en Fuselaje (Nodo ' num2str(nodo_fuselaje) ')']);
xlim([0, tmax]);

% Opcional: Vincular el zoom de los ejes X para que si haces zoom en uno, se muevan todos
linkaxes(findall(gcf,'type','axes'), 'x');