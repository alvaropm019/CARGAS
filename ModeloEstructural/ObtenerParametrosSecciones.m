function [F, W, ES] = ObtenerParametrosSecciones()

%% FUSELAJE
% Sección F1
F.F1.b = 1010e-3;
F.F1.h = 800e-3;
F.F1.rsup = 260.5e-3;
F.F1.rinf = 76e-3;
F.F1.tpiel = 2e-3;
F.F1.Coords = coord_fuselaje(F.F1);
F.F1.espesores = F.F1.tpiel * ones(1,size(F.F1.Coords,1));
F.F1.Larguerillos.Coord = [246e-3    374e-3;...
                              -246e-3   374e-3;
                              482.5e-3  144.5e-3;
                              -482.5e-3 144.5e-3;
                              482.5e-3  -267.5e-3;
                              -482.5e-3 -267.5e-3;
                              246e-3    -376.5e-3;
                              -246e-3   -376.5e-3];
F.F1.Larguerillos.Areas = 300e-6 * ones(size(F.F1.Larguerillos.Coord,1),1);

% Sección F2
F.F2.b = 1200e-3;     
F.F2.h = 1200e-3;      
F.F2.rsup = 400e-3;   
F.F2.rinf = 82.5e-3;   
F.F2.tpiel = 2e-3;   
F.F2.Coords = coord_fuselaje(F.F2);
F.F2.espesores = F.F2.tpiel * ones(1,size(F.F2.Coords,1));
F.F2.Larguerillos.Coord = [242e-3    571e-3;...
                              -242e-3   571e-3;
                              577.5e-3  342.5e-3;
                              -577.5e-3 342.5e-3;
                              577.5e-3  -58e-3;
                              -577.5e-3 -58e-3;
                              577.5e-3  -479.5e-3;
                              -577.5e-3 -479.5e-3;
                              242e-3    -575e-3;
                              -242e-3   -575e-3];
F.F2.Larguerillos.Areas = 300e-6 * ones(size(F.F2.Larguerillos.Coord,1),1);


% Sección F3
F.F3.b = 1000e-3;
F.F3.h = 1000e-3;
F.F3.rsup = 220e-3;
F.F3.rinf = 59.5e-3;
F.F3.tpiel = 2e-3;
F.F3.Coords = coord_fuselaje(F.F3);
F.F3.espesores = F.F3.tpiel * ones(1,size(F.F3.Coords,1));
F.F3.Larguerillos.Coord = [244e-3    473e-3;...
                              -244e-3   473e-3;
                              479e-3    268.5e-3;
                              -479e-3   268.5e-3;
                              479e-3    -352.5e-3;
                              -479e-3   -352.5e-3;
                              244e-3    -478e-3;
                              -244e-3   -478e-3];
F.F3.Larguerillos.Areas = 300e-6 * ones(size(F.F3.Larguerillos.Coord,1),1);

% Sección F4
F.F4.b = 800e-3;
F.F4.h = 800e-3;
F.F4.rsup = 167.5e-3;
F.F4.rinf = 54e-3;
F.F4.tpiel = 2e-3;
F.F4.Coords = coord_fuselaje(F.F4);
F.F4.espesores = F.F4.tpiel * ones(1,size(F.F4.Coords,1));
F.F4.Larguerillos.Coord = [336e-3    335e-3;...
                              -336e-3   335e-3;
                              314e-3    -376e-3;
                              -314e-3   -376e-3];
F.F4.Larguerillos.Areas = 300e-6 * ones(size(F.F4.Larguerillos.Coord,1),1);


% Sección F5
F.F5.b = 500e-3;
F.F5.h = 600e-3;
F.F5.rsup = 170e-3;
F.F5.rinf = 55.5e-3;
F.F5.tpiel = 2e-3;
F.F5.Coords = coord_fuselaje(F.F5);
F.F5.espesores = F.F5.tpiel * ones(1,size(F.F5.Coords,1));
F.F5.Larguerillos.Coord = [181.5e-3    231.5e-3;...
                              -181.5e-3   231.5e-3;
                              181.5e-3    -276e-3;
                              -181.5e-3   -276e-3];
F.F5.Larguerillos.Areas = 300e-6 * ones(size(F.F5.Larguerillos.Coord,1),1);

%% WING

% ------------------W2-----------------------
W.W2.Coords = [1600    619.5;...
                       1600    452  ;...
                       1350.5  446.5;...
                       1100    450  ;...
                       850     456.5;...
                       596.5   486  ;...
                       505     520  ;...
                       505     554.5;...
                       596.5   606  ;...
                       850     670.5;...
                       1100    681.5;...
                       1350    666]*1e-3;
W.W2.espesores = [2 1 1 1 1 1 1 1 1 1 1]*1e-3;
W.W2.b = (350 + 500 + 247)*1e-3;
W.W2 = momentopolar(W.W2);

    % Sección W2_LL
    % de momento suponemos que delante y detras es igual. Larguerillos
    % considerando seccion de atras y resto de valores son las medias.
    W.W2.LL.t = 2e-3;
    W.W2.LL.b = 0.5 * (247 + 350) * 1e-3; % base
    W.W2.LL.h = 0.5 * (240 + 169) * 1e-3; % altura
    W.W2.LL.tpiel = 1e-3 ;
    W.W2.LL.Larguerillos.Areas = [50; 50]*1e-6;
    W.W2.LL.Larguerillos.Coord = [128*1e-3 W.W2.LL.h/2;...
                                         128*1e-3 -W.W2.LL.h/2];
   

    

    % Sección W2LC
    W.W2.LC.t = 4e-3;
    W.W2.LC.b = 0.5;
    W.W2.LC.h = 0.24;
    W.W2.LC.tpiel = 1e-3;
    W.W2.LC.Larguerillos.Areas = 50e-6 * ones(8,1);
    W.W2.LC.Larguerillos.Coord = [75*1e-3 W.W2.LC.h/2;...
                                        -75*1e-3 W.W2.LC.h/2;...
                                        75*1e-3 -W.W2.LC.h/2;...
                                        -75*1e-3 -W.W2.LC.h/2;...
                                        188*1e-3 W.W2.LC.h/2;...
                                        -188*1e-3 W.W2.LC.h/2;...
                                        188*1e-3 -W.W2.LC.h/2;...
                                        -188*1e-3 -W.W2.LC.h/2];
    

    % Sección W2_CO
    W.W2.CO.t = 2e-3;
    W.W2.CO.st = 0.5588;
    W.W2.CO.b = W.W2.CO.st; % base
    W.W2.CO.h = 0.5 * (240 + 169) * 1e-3; % altura
    W.W2.CO.tpiel = 1e-3 ;

% ------------------W1-----------------------
W.W1.Coords = [1600    619.5;...
                       1600    452  ;...
                       1350.5  446.5;...
                       1100    450  ;...
                       850     456.5;...
                       596.5   486  ;...
                       505     520  ;...
                       505     554.5;...
                       596.5   606  ;...
                       850     670.5;...
                       1100    681.5;...
                       1350    666]*1e-3;
W.W1.espesores = [2 1 1 1 1 1 1 1 1 1 1]*1e-3;
W.W1.b = (350 + 500 + 247)*1e-3;
W.W1 = momentopolar(W.W1);



    % Sección W1_LL
    % de momento suponemos que delante y detras es igual. Larguerillos
    % considerando seccion de atras y resto de valores son las medias.
    W.W1.LL.t = 2e-3;
    W.W1.LL.b = 0.5 * (247 + 350) * 1e-3; % base
    W.W1.LL.h = 0.5 * (240 + 169) * 1e-3; % altura
    W.W1.LL.tpiel = 1e-3 ;
    W.W1.LL.Larguerillos.Areas = [50; 50]*1e-6;
    W.W1.LL.Larguerillos.Coord = [128*1e-3 W.W1.LL.h/2;...
                                         128*1e-3 -W.W1.LL.h/2];

    % Sección W1LC
    W.W1.LC.t = 10e-3;
    W.W1.LC.b = 0.5;
    W.W1.LC.h = 0.24;
    W.W1.LC.tpiel = 1e-3;
    W.W1.LC.Larguerillos.Areas = 50e-6 * ones(8,1);
    W.W1.LC.Larguerillos.Coord = [      75*1e-3 W.W1.LC.h/2;...
                                        -75*1e-3 W.W1.LC.h/2;...
                                        75*1e-3 -W.W1.LC.h/2;...
                                        -75*1e-3 -W.W1.LC.h/2;...
                                        188*1e-3 W.W1.LC.h/2;...
                                        -188*1e-3 W.W1.LC.h/2;...
                                        188*1e-3 -W.W1.LC.h/2;...
                                        -188*1e-3 -W.W1.LC.h/2];

    % Sección W1_CO
    W.W1.CO.t = 2e-3;
    W.W1.CO.st = 0.5588;
    W.W1.CO.b = W.W1.CO.st; % base
    W.W1.CO.h = 0.5 * (240 + 169) * 1e-3; % altura
    W.W1.CO.tpiel = 1e-3 ;


%% ESTABILIZADOR
% SECCIÓN ES 
% Primera aproximación como 2 secciones C
ES.Coords = [1353.5  1242   ;...
                       1353.5  1157   ;...
                       1153.5  1147   ;...
                       953.5   1150   ;...
                       899     1156   ;...
                       815.5   1179   ;...
                       793.5   1199   ;...
                       815.5   1221.5 ;...
                       899     1244.5 ;...
                       953.5   1249   ;...
                       1153.5  1253]*1e-3;
ES.espesores = [4 1 1 1 1 1 1 1 1 1]*1e-3;
ES.b = (560)*1e-3;
ES = momentopolar(ES); %% Para esta config, el larguero principal del ES no está siendo considerado



    % Sección ES_LA
    ES.LA.t = 4e-3;
    ES.LA.b = 200e-3;
    ES.LA.h = 0.5 * (99 + 85)*1e-3;
    ES.LA.tpiel = 1e-3; %%%%% CUIDADO, NO SALE VALOR


    % Sección ES_CO
    ES.CO.t = 2e-3;
    ES.CO.st = 0.375;
    ES.CO.b = ES.CO.st; % base
    ES.CO.h = 0.5 * (99 + 85) * 1e-3; % altura
    ES.CO.tpiel = 1e-3 ;
end