clear, close all, clc

%% Rutas a directorios con informacion

addpath('../02_ExtracionDatos/VariablesGeneradas')

addpath('Funciones')

%% Lectura y representacion de datos

load Conjunto_de_Datos.mat

representa_datos_color_seguimiento_fondo(X,Y)

%% Agrupamiento de datos y representacion - clase de interes

% DATOS DE ESA CLASE DE INTERES
valoresY = unique(Y);
FoI = Y == valoresY(2);
Xcolor = X(FoI,:);

numAgrup = 3;
idx = funcion_kmeans(Xcolor, numAgrup);
%idx = kmeans(Xcolor, numAgrup);

% Representamos agrupaciones
close all
representa_datos_color_seguimiento_fondo(X,Y)

figure
representa_datos_fondo(X,Y), hold on
representa_datos_color_seguimiento_por_agrupacion(Xcolor,idx)
%Mostramos en distintos colores en la diferentes agrupaciones de idx
hold off

% figure
% representa_datos_fondo(X,Y), hold on
% representa_datos_color_seguimiento_por_agrupacion(Xcolor,idxM)
% hold off

%% Calculo de las esferas de cada agrupacion

% ANTES, CUANDO TENIAMOS UNA SOLA ESFERA:
% datosEsfera = calcula_datos_esfera(X,Y)
% Pasos de la funcion:
% 1.- Calcula centroide de la nube de puntos del color de seguimiento: Rc,
% Gc, Bc
% 2.- Calcula vector distancias entre el centroide anterior y cada uno de
% los puntos de X (hay muestras del color del objeto y de fondo)
% 3.- Extrae los valores de cada clase: por una parte los calores de
% distancia entre el centroide y las muestras del color del objeto y, por
% otra, los valores de distancia entre el centroide y las muestras de
% fondo.
% 4.- Calcula r1 y r2 a partir de los vectores distancia anteriores
% 5.- Calcula el radio de compromiso r12
% 6.- Devolver datosEsfera = [Rc, Gc, Bc, r1, r2, r12] (vector fila)

% AHORA:
% datosEsferasAgrupacion = ...
%       cacula_datos_esferas_agrupacion(Xcolor_agrupacion, X, Y);
% Pasos de la funcion:
% 1.- Calcula centroide de los puntos del color de seguimiento de la
% agrupacion: Rc, Gc, Bc
% 2.- Calcula el vector distancias  entre el centroide anterior y cada uno
% de los puntos de Xcolor_agrupacion
% 3.- Caclula el vector distancia entre el centroide anterior y cada uno de
% los puntos de las muestras de fondo que hay en X
% 4.- Calcular r1 y r2 a partir de los vectores distancia anteriores
% 5.- Calcular el radio de compromiso r12
% 6.- Devolver datosEsferaAgrupacion = [Rc, Gc, Bc, r1, r2, r12] (vector fila)

datosMultiplesEsferas = zeros(numAgrup,6);
% Variable que contiene los datos de todas las esferas de todas las
% agrupaciones
% Filas: tantas como agrupaciones
% Columnas: 3 valores para el centroide, 3 para radios

for i=1:numAgrup
    Fagrupacion = idx == i;
    Xcolor_agrupacion = Xcolor(Fagrupacion,:);
    
    datosEsferaAgrupacion = calcula_datos_esferas_agrupacion(Xcolor_agrupacion, X, Y);
    datosMultiplesEsferas(i,:) = datosEsferaAgrupacion;
end

%% Representamos esferas en espacio de caracteristicas
close all
valoresCentros = datosMultiplesEsferas(:,1:3);
valoresRadios = datosMultiplesEsferas(:,4:6);
significadoRadio{1} = 'Radio sin perdida';
significadoRadio{2} = 'Radio sin ruido';
significadoRadio{3} = 'Radio compromiso';


for i=1:length(valoresRadios)
    
    figure(i),set(i,'Name',significadoRadio{i})
    representa_datos_fondo(X,Y), hold on
    representa_datos_color_seguimiento_por_agrupacion(Xcolor,idx)
    
    for j=1:numAgrup
        representa_esfera(valoresCentros(j,:),valoresRadios(j,i))
    end
end

save('./VariablesGeneradas/datos_multiples_esferas','datosMultiplesEsferas')

%% EJERCICIO PROPUESTO 

% APLICAR ESTA TECNICA DE CLASIFICACION EN LAS IMAGENES DE CLASIFICACION

% POR CADA IMAGEN DE CALIBRACION SE DEBE GENERAR UNA VENTANA DE TIPO FIGURE
% CON CUATRO GRAFICAS SUBPLOT DE DOS FILAS Y DOS COLUMNAS DE GRAFICAS):

% PRIMERA GRAFICA: IMAGEN DE COLOR DE CALIBRACION ORIGINAL

% SEGUNDA GRAFICA: IMAGEN ANTERIOR DONDE SE VISUALIZAN EN UN COLOR LOS
% PIXELES QUE SE DETECTAN COMO DEL COLOR DE SEGUIMIENTO UTILIZANDO EL RADIO
% DEL PRIMER CRITERIO: r1 (SE DETECTAN TODOS LOS PIXELES DEL COLOR). PARA
% ELLO UTLIZA LA FUNCION_VISUALIZA

% TERCERA Y CUARTA GRAFICA: IGUAL PARA LOS RADIOS r2 (no detecta ruido) Y
% r12 (radio de compromiso).

% -------------------------------------------------------------------------
% EN LA ESTRATEGIA BASADA EN UNA ESFERA PARA MODELAR TODOS LOS DATOS DE
% COLOR, SE IMPLEMENTO PARA RESOLVER ESTE EJERCICIO LA FUNCION:
%        Ib = calcula_deteccion_1esfera_en_imagen(I,centroides_radios)

% AHORA, CUANDO SE CONSIDERAN MULTIPLES ESFERAS PARA MODELAR DATOS DE COLOR
% POR DISTINTAS AGRUPACIONES:
% Ib = calcula_deteccion_multiples_esferas_en_imagen(I,centroides_radios)

% Un pixel de I es del color del objeto de seguimiento si su punto (R,G,B)
% esta dentro de cualquiera de las esferas dadas en la variable
% centroides_radios
