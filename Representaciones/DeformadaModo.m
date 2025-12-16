function DeformadaModo(ESTRUCTURA,u,fHz,h)

%% DESCRIPCIÓN DE LA FUNCIÓN
% DibujaModoVibracion representa la animación del modo de vibración del ala
%
% INPUTS ------------------------------------------------------------------
% modo : modo a representar
% ESTRUCTURA : estructura de datos con la información del emparrillado
% estructural del ala
% fHz : frecuencia natural del modo a representar (Hz)
% u : autovector del modo a representar
% h : factor de escala
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

% Nuevo vector con los grados de libertad activos
% Eliminamos los nulos con la función de MATLAB setdiff
Gdl_Activos = setdiff(1:NumGdl,CondContorno);
d(Gdl_Activos) = u;  


X = [];
Y = [];
Z = [];

%% DEFORMADA ESTRUCTURA ================================================
for e=1:NumElem
    % Configuración Deformada -------------------------------------------
    % Calculamos puntos intermedios para tener más resolución
    t = [-1:0.1:1]';
    [~,... Coordenadas originales elemento
     Coord_xy] = ... Coordenadas elemento deformado
                DeformadaElemento(e,... Identificación elemento
                                  ElemConexion,...   Matriz de conexión de elementos
                                  NodosCoord,...     Matriz de coordenadas en los nodos
                                  NodosGdl,...       Matriz con gdls de cada nodo
                                  d,... Solución de los gdl (movimientos y giros)
                                  t,h);... Vector columna con los puntos intermedios
                                         
    X = [X Coord_xy(:,1)];
    Y = [Y Coord_xy(:,2)];
    Z = [Z Coord_xy(:,3)];
end






%% FIGURA

Show_estructura = ESTRUCTURA.Representacion.DeformadaEstructura;
Show_animacion  = ESTRUCTURA.Representacion.AnimacionArmonica;





figura_modo = figure;
figura_modo.Color = 'w';
hold on           



% deformada esqueleto estructura

if strcmp(Show_estructura,'on')
    graf_def = plot3(X,Y,Z,'-','Color','k','LineWidth',1.5);
end


% estructura sin deformar
color_sindeformar = [0.9,0.9,0.9];
color_sindeformar = 'b';
graf_undeformed = plot3(X,Y,0*Z,'--','Color',color_sindeformar,'LineWidth',1.0);






xlabel('$x$ [m]', 'Interpreter','LaTex','FontSize',14)
ylabel('$y$ [m]','Interpreter','LaTex','FontSize',14)
zlabel('Despl. modal','Interpreter','LaTex','FontSize',14)
ax = gca;
ax.TickLabelInterpreter = 'latex';
ax.XLim = [-1,9];
ax.YLim = [-7,7];
ax.ZLim = [-2,2];
daspect([1 1 1])
ax.View = [130,30];
grid on
box on   
%TextoTitulo = ['Deformada'];
TextoTitulo = ['Modo vibraci\''on, $\omega_f$ = ' num2str(fHz,'%.2f') ' Hz'];
% TextoTitulo_flameo = ['Modo flameo, $\omega_f$ = ' num2str(w_m,'%.2f') ' Hz'];
title(TextoTitulo,'Interpreter','LaTex','FontSize',12);
hold on


% simulación
dt = 5E-3;
tmin = 0;
tmax = 3;
t = tmin:dt:tmax;
w = 20;

if strcmp(Show_animacion,'on')
    for j=1:1:length(t)
        Zt = Z * sin(w * t(j));
        for e = 1:numel(graf_def)
            graf_def(e).ZData = Zt(:, e);
        end
        pause(0.001)
    end
end


ImageSize = [0 0 12 10];

% saveas(figura_malla,'figura.eps','epsc');
NombreArchivo = ['Representaciones\figura_Modo_f=',num2str(fHz,3),'Hz.eps'];

figura_modo.PaperUnits = 'centimeters';
figura_modo.PaperPosition = ImageSize;
%set(gcf,'renderer','opengl');   ... calidad baja de imágenes
%set(gcf,'renderer','painters'); ... calidad alta de imágenes
%saveas(fig,NombreArchivo,'epsc');
set(gcf,'renderer','painters');   ... calidad baja de imágenes
%set(gcf,'renderer','painters'); ... calidad alta de imágenes
%print(fig,NombreArchivo,'-depsc','-r1000');
print(figura_modo,NombreArchivo,'-depsc','-r1000');










end

