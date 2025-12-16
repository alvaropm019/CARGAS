% Respuesta en el tiempo de un problema de 1GDL
clear all; close all; clc
% Parámetros
m = 1; ... masa(kg)
zeta = 0.08; ... ratio de amortiguamiento (c = 2 * m * w0 * zeta)
w0 = 3; ... rad/s = frecuencia natural = sqrt(k/m)

k = m * w0^2;

% Ttiempo de simulación
T = 40;

% Función excitación
f = f_Chirp;

% Representación de la excitación
figure
ejes = gca;
tejemplo = 0:0.01:T;
plot(tejemplo, f(tejemplo))
grid on


% Coeficientes de Fourier de f(t) t = dt * [0,1,2,..., M-1]
M = 2^8;
t = linspace(0,T,M)';
dt = t(2) - t(1);

% Frecuencias wn = 2 *pi * n /T, n = 0,1,2,...,M-1: lista de frecuencias en
% orden natural
% Frecuencias wn = 2 * pi * n / T, n = -M/2,...,-1,0,1,...,M/2: Lista de
% frecuencias en orden centrado
dw = 2 * pi / T; ... resolución en frecuencia en (rad/s)
df = dw / (2*pi); ... resolución en frecuencia en (Hz) df = 1/T
wn_natural =  (0:M-1)' * dw; ...lista de frecuencias en orden natural
wn_centrada = (-M/2:M/2-1)' * dw; ... lista de frecuencias en orden centrado

Fn_natural = fft(f(t),M);
Fn_centrada = fftshift(Fn_natural);

% Representación espectro de la fuerza f(t)
figure
ejes = gca;
plot(wn_natural, abs(Fn_natural),'-ok')
hold on
plot(wn_centrada, abs(Fn_centrada),'-sr')
xlabel('$\omega_n = \frac{2 \pi n}{T}$, rad/s','Interpreter','Latex')
ylabel('$\left|F_n\right|$','Interpreter','Latex')
grid on


wnyq = 2 * pi / T * M / 2; % wnyq * dt = pi

% Función de respuesta en frecuencia para cada frecuencia CENTRADA
Hn =  1 ./ (-wn_centrada.^2 + 2*(1i) * w0 * wn_centrada * zeta + w0^2);
Hn = (1/m) * Hn;

% Representación
figure
ejes = gca;
plot(wn_centrada, abs(Hn),'-sb')
xlabel('$\omega_n = \frac{2 \pi n}{T}$, rad/s','Interpreter','Latex')
ylabel('$\left|F_n\right|$','Interpreter','Latex')
grid on


% Coeficientes de Fourier de respuesta Un
Un_centrada = Hn .* Fn_centrada;

% Reconstrucción de u(t)
% Descentrado: devolvemos los un al orden natural
Un_natural = ifftshift(Un_centrada);
u = ifft(Un_natural);
% Representación
figure
ejes = gca;
plot(t,u,'-k')
xlabel('$t$, (s)','Interpreter','Latex')
ylabel('$u(t)$','Interpreter','Latex')
grid on