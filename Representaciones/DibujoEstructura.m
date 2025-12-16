function DibujoEstructura(ESTRUCTURA)

%% DESCRIPCIÓN DE LA FUNCIÓN
% DibujaModoVibracion representa la animación del modo de vibración del ala
%
% INPUTS ------------------------------------------------------------------
% t : vector columna con los puntos intermedios t=-1 (nodo 1), t=+1 (nodo 2)
% ESTRUCTURA : estructura de datos con la información del emparrillado
% estructural del ala
%
% OUTPUTS -----------------------------------------------------------------
% Dibujo 2D de la estructura, nodos y elementos

%% OBTENCION DE DATOS E INICIALIZACION DE LA FIGURA

% Datos de la estructura
% n_largueros = ESTRUCTURA.largueros;
% larg_txt = num2str(n_largueros);
% n_costillas = ESTRUCTURA.costillas;
% cuad_txt = num2str(n_costillas);
N = ESTRUCTURA.NumNodos;
N_txt = num2str(N);
Ne = ESTRUCTURA.NumElem;
Ne_txt = num2str(Ne);
ElemConexion = ESTRUCTURA.Conect;
NodosCoord = ESTRUCTURA.CoordNodos;
NumElem = size(ElemConexion,1);

% Inicializamos la figura
fig = figure;

t = [-1, 1];

for i = 1:NumElem
    
    % Identificación del elemento
    e = i;

    % Número de puntos a representar a lo largo del elemento
    p = numel(t);
    
    % El vector columna "t" debe tener la siguiente estructura
    % t = [-1 t_2 t_3 .... t_p-2 t_p-1 +1]' : total "p" elementos
    % con -1 < t_j < 1 , para j=2,...,p-1
    
    % Nudos inicial (n1) y final (np) del elemento "e"
    n1 = ElemConexion(e,1);
    np = ElemConexion(e,2);

   
    plot_elem = ESTRUCTURA.Representacion.Elementos;
    label_elem = ESTRUCTURA.Representacion.LabelsElementos;
    label_ID   = ESTRUCTURA.Representacion.LabelsFamilia;
       
    % Inicialización de la matriz
    Coord_XY = zeros(p,3);
    
    
    %% OBTENCIÓN DE LA GEOMETRÍA
    % Asignamos coordenadas nodos inicial y final
    X1 = NodosCoord(n1,1);
    Y1 = NodosCoord(n1,2);
    Z1 = NodosCoord(n1,3);
    Xp = NodosCoord(np,1);
    Yp = NodosCoord(np,2);
    Zp = NodosCoord(n1,3);
    
    Coord_XY(1,1) = X1;
    Coord_XY(1,2) = Y1;
    Coord_XY(1,3) = Z1;
    Coord_XY(p,1) = Xp;
    Coord_XY(p,2) = Yp;
    Coord_XY(p,3) = Zp;
    
    for j = 2:(p-1)
        % Funciones de forma lineales
        N1 = (1/2)*(1 - t(j));
        Np = (1/2)*(1 + t(j));
        Coord_XY(j,1) = X1 * N1 + Xp * Np;
        Coord_XY(j,2) = Y1 * N1 + Yp * Np;
        Coord_XY(j,3) = Z1 * N1 + Zp * Np;
    end
    
    
    % REPRESENTACIÓN ELEMENTS
    
    plot(Coord_XY(:,1),Coord_XY(:,2),... Puntos
                                     '-o',...
                                     'Color','b',...
                                     'LineWidth',1,...
                                     'MarkerEdgeColor','k',...
                                     'MarkerFaceColor','w',...
                                     'MarkerSize',3,...
                                     'Visible',plot_elem);
%     plot3(Coord_XY(:,1),Coord_XY(:,2),Coord_XY(:,3),... Puntos
%                                      '-o',...
%                                      'Color','b',...
%                                      'LineWidth',1,...
%                                      'MarkerEdgeColor','k',...
%                                      'MarkerFaceColor','w',...
%                                      'MarkerSize',3,...
%                                      'Visible',plot_elem);

    xlabel('$x$ [m]',...
       'Interpreter','LaTex',...
       'FontSize',14)
    ylabel('$y$ [m]',...
       'Interpreter','LaTex',...
       'FontSize',14)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    daspect([1 1 1])
    ax.View = [90,90];
    ax.View = [130,30];
    hold on
    grid on
    box on

    TextoTitulo = ['Emparrillado de la estructura: ' N_txt ' nodos y ' Ne_txt ' elementos.'  ];
    title(TextoTitulo,...
    'Interpreter','LaTex',...
    'FontSize',12); 

    % REPRESENTACÓN LABEL
    % identification nodes
    nodo1 = ESTRUCTURA.Conect(e,1);
    nodo2 = ESTRUCTURA.Conect(e,2);

    id_elem = ESTRUCTURA.ID_elem(e);
    
    % coordinates nodes
    x1 = ESTRUCTURA.CoordNodos(nodo1,1);
    y1 = ESTRUCTURA.CoordNodos(nodo1,2);
    x2 = ESTRUCTURA.CoordNodos(nodo2,1);
    y2 = ESTRUCTURA.CoordNodos(nodo2,2);

    xm = (x1+x2)/2;
    ym = (y1+y2)/2;    

    % label element
    text_elem_label = text(xm,ym,num2str(e));
    text_elem_label.Color = 'r';
    text_elem_label.FontSize = 10;
    text_elem_label.Interpreter = "latex";
    text_elem_label.HorizontalAlignment = "center";
    text_elem_label.VerticalAlignment = "middle";
    text_elem_label.Units = "data";
    text_elem_label.Visible = label_elem;    

    % label structure/component
    % plot id elements: ala(1), est(2), fus(3)
    text_elem_label = text(xm,ym,num2str(id_elem));
    text_elem_label.Color = 'r';
    text_elem_label.FontSize = 10;
    text_elem_label.Interpreter = "latex";
    text_elem_label.HorizontalAlignment = "left";
    text_elem_label.VerticalAlignment = "bottom";
    text_elem_label.Units = "data";
    text_elem_label.Visible = label_ID;    


end

% Plot example nodes


for j = 1:length(ESTRUCTURA.NodoEjemplo)
    id_elem = ESTRUCTURA.NodoEjemplo(j);
    x = ESTRUCTURA.CoordNodos(id_elem,1);
    y = ESTRUCTURA.CoordNodos(id_elem,2);
    gdl = ESTRUCTURA.GDL(id_elem,3)
    plot(x,y,... Puntos
        '.',...
         'Color','r',...
         'LineWidth',1,...
         'MarkerEdgeColor','r',...
         'MarkerFaceColor','w',...
         'MarkerSize',12);
    % label of node "j"
    node_label = text(x,y,num2str(gdl));
    node_label.Color = 'r';
    node_label.FontSize = 10;
    node_label.Interpreter = "latex";
    node_label.HorizontalAlignment = "left";
    node_label.VerticalAlignment = "bottom";
    node_label.Units = "data";
    node_label.Visible = "on";
end

% Plot labels of nodes
for j = 1:ESTRUCTURA.NumNodos   

    
    
    label_node = ESTRUCTURA.Representacion.LabelsNodos;
    label_ID   = ESTRUCTURA.Representacion.LabelsFamilia;
    


    x = ESTRUCTURA.CoordNodos(j,1);
    y = ESTRUCTURA.CoordNodos(j,2);

    id_nodo = ESTRUCTURA.ID_nodos(j);    

    % label of node "j"
    node_label = text(x,y,num2str(j));
    node_label.Color = 'r';
    node_label.FontSize = 10;
    node_label.Interpreter = "latex";
    node_label.HorizontalAlignment = "left";
    node_label.VerticalAlignment = "bottom";
    node_label.Units = "data";
    node_label.Visible = label_node;

    % label of component associated to the node "j"
    node_label = text(x,y,num2str(id_nodo));
    node_label.Color = 'b';
    node_label.FontSize = 12;
    node_label.Interpreter = "latex";
    node_label.HorizontalAlignment = "left";
    node_label.VerticalAlignment = "bottom";
    node_label.Units = "data";
    node_label.Visible = label_ID;
    node_label.Visible = "off";

   

end



% DIBUJAMOS CONDICIONES DE CONTORNO

for cont = 1:length(ESTRUCTURA.CondContorno)
    
    [id_CondContorno_nodo,id_CondContorno_gdl] = find(ESTRUCTURA.GDL == ESTRUCTURA.CondContorno(cont));

    plot_CondContorno_node = ESTRUCTURA.Representacion.CondContorno_nodo;
    plot_CondContorno_gdl  = ESTRUCTURA.Representacion.CondContorno_gdl;
  
    x = ESTRUCTURA.CoordNodos(id_CondContorno_nodo,1);
    y = ESTRUCTURA.CoordNodos(id_CondContorno_nodo,2);
    plot(x,y,... Puntos
         'sk',...
         'Color','k',...
         'LineWidth',0.5,...
         'MarkerEdgeColor','k',...
         'MarkerFaceColor','k',...
         'MarkerSize',6,...
         'Visible',plot_CondContorno_node);
    %id_nodo = ESTRUCTURA.ID_nodos(j);    

    % label of node with boundary conditions
    node_label = text(x,y,num2str(id_CondContorno_gdl));
    node_label.Color = 'k';
    node_label.FontSize = 15;
    node_label.Interpreter = "latex";
    node_label.HorizontalAlignment = "left";
    node_label.VerticalAlignment = "bottom";
    node_label.Units = "data";
    node_label.Visible = plot_CondContorno_gdl;

end

ax.XLim = [0,8];
ax.YLim = [-5,5];


% TÍTULO GRÁFICO  ============================================================

NombreArchivo = 'Representaciones/figura_ModeloEstructural.eps';
ImageSize = [0 0 28 20];

% saveas(figura_malla,'figura.eps','epsc');
% NombreArchivo = 'figura.eps';

fig.PaperUnits = 'centimeters';
fig.PaperPosition = ImageSize;
%set(gcf,'renderer','opengl');   ... calidad baja de imágenes
%set(gcf,'renderer','painters'); ... calidad alta de imágenes
%saveas(fig,NombreArchivo,'epsc');
set(gcf,'renderer','painters');   ... calidad baja de imágenes
%set(gcf,'renderer','painters'); ... calidad alta de imágenes
%print(fig,NombreArchivo,'-depsc','-r1000');
print(fig,NombreArchivo,'-depsc','-r1000');




















