function [t, u] = Solucion_MetodoRK(wm, Vm, zeta, tmax, gdl_f, f)
% SOLUCION_METODORK Calcula la respuesta temporal mediante integración paso a paso.
%
%   [t, u] = Solucion_MetodoRK(wm, Vm, zeta, tmax, gdl_f, f)
%
%   Entradas:
%       wm    : Vector (mx1) de frecuencias naturales [rad/s].
%       Vm    : Matriz modal (Nxm) con autovectores (masa-unitarios).
%       zeta  : Vector (mx1) con los ratios de amortiguamiento modales.
%       tmax  : Tiempo total de simulación [s].
%       gdl_f : Vector (Nx1) de localización de fuerza (ceros excepto en el GDL forzado).
%       f     : Handle de función anónima f(t) que define la excitación temporal.
%
%   Salidas:
%       t     : Vector de tiempos devuelto por ode45.
%       u     : Matriz de respuesta física (t x N).
%


    %% 1. Preparación de matrices modales
    % Número de modos (m) y grados de libertad físicos (N)
    m = length(wm); 
    
    % Matriz de rigidez modal (Diagonal de frecuencias al cuadrado) [cite: 166]
    Omega2 = diag(wm.^2);
    
    % Matriz de amortiguamiento modal C' = 2*Z*Omega [cite: 164]
    % Se asume amortiguamiento proporcional o modal desacoplado.
    C_prime = diag(2 * zeta .* wm);

    %% 2. Construcción del Espacio de Estado
    % Definición de la matriz A del sistema según la Ec. (19) 
    % A = [ 0      I ]
    %     [-w^2  -C' ]
    A = [zeros(m),      eye(m); 
        -Omega2,       -C_prime];

    %% 3. Proyección de la Fuerza Física al Espacio Modal
    % La fuerza física es F_phys(t) = gdl_f * f(t).
    % La fuerza modal es Q(t) = Vm' * F_phys(t) = (Vm' * gdl_f) * f(t).
    P = Vm' * gdl_f; 

    %% 4. Integración Numérica (ode45)
    % Definimos el sistema dinámico dv/dt = A*v + g(t) 
    % v = [q; q_dot] (vector de estado de tamaño 2m)
    g_vec = @(t) [zeros(m, 1); P * f(t)];
    ode_fun = @(t, v) A * v + g_vec(t);
    
    
    % Condiciones iniciales: Reposo u(0)=0, u_dot(0)=0 -> v0 = 0 
    v0 = zeros(2*m, 1);
    
    % Configuración e integración
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8); % Tolerancias estándar
    [t, v_response] = ode45(ode_fun, [0, tmax], v0, options);

    %% 5. Reconstrucción de la Respuesta Física
    % v_response tiene dimensiones [pasos_tiempo x 2m].
    % Las primeras 'm' columnas corresponden a las coordenadas modales q(t).
    q = v_response(:, 1:m); % Dimensiones: [pasos_tiempo x m]
    
    % Recuperamos el desplazamiento físico u(t) = Phi * q(t) 
    % Transponemos q para operar: Vm (Nxm) * q' (mxSteps) = u' (NxSteps)
    u_transposed = Vm * q';
    
    % Devolvemos u en formato [Steps x N] para coincidir con el vector t
    u = u_transposed';

end