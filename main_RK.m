% MAIN RK
%% DATOS GEOMÉTRICOS Y ESTRUCTURALES
main_datos

%% CÁLCULO DE MODOS DE VIBRACIÓN
K = Rigidez(ESTRUCTURA);
M = Masa(ESTRUCTURA);

n = ESTRUCTURA.NumGDL;
[V, D] = eig(K, M);
%  V = [v1, v2, ..., vn] 
% vj' * M * vj = 1 --> está normalizado con la matriz de masa
Mmodal = V' * M * V; % Debería ser la identidad

% Ordenar las frecuencias
w_nat = sqrt(diag(D));
[w_nat, id] = sort(real(w_nat));
V = V(:,id);

% Normalización con la masa
for j = 1 : n
    xj = V(:,j);
    a = 1 / sqrt(xj' * M * xj);
    vj = a * xj;
    % El nuevo autovector verifica vj' * M * vj = 1
    V(:,j) = vj;
end

Mmodal = V' * M * V;

n = ESTRUCTURA.NumGDL;

nodo_aplicacion = 55;
gdl = 3; % Desplazamiento vertical
gdl_por_nodo = 3;

gdl_f = zeros(n,1);
gdl_f(gdl_por_nodo*(nodo_aplicacion-1)+gdl) = 1;

% Ratios de amortiguamiento (para más allá del modo 24 se toma el
% amortiguamiento de este último)
zeta = 0.0290 * ones(n,1); 
zeta(1:24) = [
    0.0020; 0.0025; 0.0030; ... % Modos 1, 2, 3
    0.0035; 0.0042; 0.0048; ... % Modos 4, 5, 6
    0.0055; 0.0063; 0.0072; ... % Modos 7, 8, 9
    0.0080; 0.0090; 0.0100; ... % Modos 10, 11, 12
    0.0115; 0.0130; 0.0145; ... % Modos 13, 14, 15
    0.0160; 0.0178; 0.0195; ... % Modos 16, 17, 18
    0.0215; 0.0230; 0.0245; ... % Modos 19, 20, 21
    0.0260; 0.0275; 0.0290      % Modos 22, 23, 24
];

tmax = 100;

f = f_Chirp;

modo_max = 27;
zeta = zeta(1:modo_max);


[t_out, u_out] = Solucion_MetodoRK(w_nat(4:modo_max),V(:,4:modo_max),zeta(4:modo_max),tmax,gdl_f,f);

% figure; plot(t_out, u_out);
% title('Respuesta en el tiempo (Prueba)'); 
% xlabel('Tiempo [s]'); ylabel('Desplazamiento [m]');

% Selección de nodos según tu imagen
nodo_ala = 55;          % Punta del ala derecha
nodo_estabilizador = 67; % Punta del estabilizador trasero
nodo_fuselaje = 1;      % Morro del avión

% Cálculo de los índices en el vector de 231 elementos
% Fórmula: (Nodo - 1) * 3 + Dirección
idx_ala = (nodo_ala - 1) * gdl_por_nodo + gdl;
idx_estab = (nodo_estabilizador - 1) * gdl_por_nodo + gdl;
idx_fus = (nodo_fuselaje - 1) * gdl_por_nodo + gdl;

% Extracción de datos de la matriz u_out
desp_ala = u_out(:, idx_ala);
desp_estab = u_out(:, idx_estab);
desp_fus = u_out(:, idx_fus);

%% Plots
figure('Name', 'Respuesta RK Separada', 'Color', 'w');

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