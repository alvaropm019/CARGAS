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
[w_nat, id] = sort(w_nat);
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



% Visualización
modo_visualizar = 4;
frecuencia_Hz = w_nat(modo_visualizar) / (2 * pi);
escala = 5;
v_modo = V(:,modo_visualizar);
DeformadaModo(ESTRUCTURA, v_modo, frecuencia_Hz, escala);


%% CÁLCULO DE FUNCIÓN DE RESPUESTA EN FRECUENCIA

% Matriz H(w)
nodo1 = 19;
gdl1 = ESTRUCTURA.GDL(nodo1,3);

nodo2 = 9;
gdl2 = ESTRUCTURA.GDL(nodo2,3);

i = gdl1;
j = gdl2;

% Inicialización Hij(w)

% Rango de frecuencias
dw = 0.5;
w_min = 0;
w_max = 300*2*pi; ... 300 Hz
w = w_min:dw:w_max;

Hij = zeros(length(w),1);

% Elección del rango de modos
modo_max = 27;

% Ratios de amortiguamiento (para más allá del modo 24 se toma el
% amortiguamiento de este último)
dseta = 0.0290 * ones(n,1); 
dseta(1:24) = [
    0.0020; 0.0025; 0.0030; ... % Modos 1, 2, 3
    0.0035; 0.0042; 0.0048; ... % Modos 4, 5, 6
    0.0055; 0.0063; 0.0072; ... % Modos 7, 8, 9
    0.0080; 0.0090; 0.0100; ... % Modos 10, 11, 12
    0.0115; 0.0130; 0.0145; ... % Modos 13, 14, 15
    0.0160; 0.0178; 0.0195; ... % Modos 16, 17, 18
    0.0215; 0.0230; 0.0245; ... % Modos 19, 20, 21
    0.0260; 0.0275; 0.0290      % Modos 22, 23, 24
];
% Función de respuesta en frecuencia
for freq = 1 : length(w)
    R = zeros(n, n);
    for modo = 1 : modo_max
        R = V(:,modo) * V(:,modo)'; % Matriz phi_j * phi_j'
        denominador = - w(freq)^2 + 2 * w(freq) * w_nat(modo) * dseta(modo) * (1i) + w_nat(modo)^2;
        Hij(freq) = Hij(freq) + R(i,j) / denominador;
    end
end


%% Representación FRF
figure 
ejes  = gca 
hold on 
plot(w/(2*pi), abs(Hij), '-k');
% plot(w/(2*pi), abs(Hijtruncado), '--r');
grid on
ejes.YScale = "log";
ejes.XLim = [0,300]; %Escala lineal en Hz
ejes.YLim = [1e-10, 1e-5];
title(['FRF gdl-',num2str(gdl1),'-',num2str(gdl2)])

figure 
ejes  = gca ;
hold on 
plot(w/(2*pi), angle(Hij), '-k');
% plot(w/(2*pi), angle(Hijtruncado), '--r');
grid on
ejes.YScale = "linear";
ejes.XLim = [0,300]; %Escala lineal en Hz
ejes.YLim = [-pi, pi];
title(['FRF gdl-',num2str(gdl1),'-',num2str(gdl2)])