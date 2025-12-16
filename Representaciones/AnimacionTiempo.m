function AnimacionTiempo(ESTRUCTURA,u,h)

%% DESCRIPCIÓN DE LA FUNCIÓN
% Animación en el tiempo de la matriz u
%
% u =
% [u1(t1) ... u1(tp);
%  u2(t1) ... u2(tp);
%       ..........  ;
%  un(t1) ... un(tp)]
%

% INPUTS ------------------------------------------------------------------

% ESTRUCTURA : estructura de datos con la información del emparrillado
% estructural del ala
% Matriz u
%
% OUTPUTS -----------------------------------------------------------------
% Animación del modo de vibración

%% DATOS NECESARIOS DE LA ESTRUCTURA Y PANELES

% ESTRUCTURA
ElemConexion = ESTRUCTURA.Conect;
NodosGdl     = ESTRUCTURA.GDL;
NodosCoord   = ESTRUCTURA.CoordNodos;
CondContorno = ESTRUCTURA.CondContorno;
id_nodos     = ESTRUCTURA.ID_nodos;... identificador de los nodos



%% REPRESENTACIÓN

% Número de grados de libertad de la estructura (antes de aplicar las
% condiciones de contorno)
    NumGdl   = numel(NodosGdl); 
    NumElem = size(ElemConexion,1);

% d: Vector con grados de libertad activos+nulos

d = zeros(NumGdl,1);

n = NumGdl;    ... numero de gdl = size(u,1)
p = size(u,2); ... numero de instantes de tiempo

% Nuevo vector con los grados de libertad activos
% Eliminamos los nulos con la función de MATLAB setdiff
% Gdl_Activos = setdiff(1:NumGdl,CondContorno);
% d(Gdl_Activos) = vec_m;  


X = cell(p,1);
Y = cell(p,1);
Z = cell(p,1);

% DEFORMADA ESTRUCTURA
for t = 1:p
    for e=1:NumElem
        % Configuración Deformada -------------------------------------------
        % Calculamos puntos intermedios para tener más resolución
        xi = [-1:0.5:1]';
        [       ~,   ... Coordenadas originales elemento
         Coord_xy] = ... Coordenadas elemento deformado
                    DeformadaElemento(e,... Identificación elemento
                                      ElemConexion,...   Matriz de conexión de elementos
                                      NodosCoord,...     Matriz de coordenadas en los nodos
                                      NodosGdl,...       Matriz con gdls de cada nodo
                                      u(:,t),... Solución de los gdl (movimientos y giros)
                                      xi,h);... Vector columna con los puntos intermedios
                                             
        X{t} = [X{t} Coord_xy(:,1)];
        Y{t} = [Y{t} Coord_xy(:,2)];
        Z{t} = [Z{t} Coord_xy(:,3)];
    end

end



figure

graf = plot3(X{1},Y{1},Z{1},'-','Color','k','LineWidth',1.0);

xlabel('$x$ [m]', 'Interpreter','LaTex','FontSize',14)
ylabel('$y$ [m]','Interpreter','LaTex','FontSize',14)
zlabel('Def. modal $\omega$ [-]','Interpreter','LaTex','FontSize',14)
ax = gca;
ax.TickLabelInterpreter = 'latex';
ax.XLim = [-2,7];
ax.YLim = [-6,6];
ax.ZLim = [-2,2];
daspect([1 1 1])
ax.View = [-60,15];
grid on
box on  
hold on
TextoTitulo = ['Time domain simulation'];


% TextoTitulo_flameo = ['Modo flameo, $\omega_f$ = ' num2str(w_m,'%.2f') ' Hz'];
title(TextoTitulo,'Interpreter','LaTex','FontSize',12);

tmax = p;
t_text = text(0.0,0.0,['$t/T=$',sprintf('%2.1f',0/tmax),'$\%$']);
t_text.Interpreter = "latex";
t_text.Units = "normalized";
t_text.Position = [0.1,0.9];

set(groot, 'DefaultFigureRenderer', 'painters')  % más estable en Mac ARM

pause(5);
for t = 1:6:p
    Zt = Z{t} ;
    for e = 1:numel(graf)
        graf(e).ZData = Zt(:, e);
    end
    t_text.String = ['$t/T=$',sprintf('%2.1f',100*t/tmax),'$\%$'];
%     for e = 1:numel(graf2)
%         graf2(e).ZData = Zt2(:, e);
%     end
    pause(0.1);
end




end

