clc
close all
clear all

% RUTAS A DIRECTORIOS CON INFORMACION
addpath('../02_ExtracionDatos/VariablesGeneradas')
addpath('Funciones')
addpath('videos_ejemplo')

%% LECTURA DE CONJUNTO DE DATOS
Color = 'azul';
Color = 'verde';

% visualizacion del video inicial
nombre_video = ['00_Color_' Color '.avi'];
implay(nombre_video);

% Datos extraidos de imagenes de calibraci?n
sentenciaTexto = ['load conjunto_de_datos_' Color '.mat'];
sentenciaTexto = ('load Conjunto_de_Datos.mat');
eval(sentenciaTexto);

%% REPRESENTAMOS DATOS
representa_datos_color_seguimiento_fondo(X,Y)

%% ESTRATEGIA DE CLASIFICACION:
%BASADA EN EL ESTABLECER UNA UNA REGION DEL ESPACIO DE CARACTERISTICAS QUE
%ENGLOBE A TODAS LAS MUESTRAS DE LA CLASE CORRESPONDIENTE A LOS PIXELES QUE
%SON DEL COLOR DEL OBJETO DE SEGUIMIENTO

% DATOS DE ESA CLASE DE INTERES
valoresY = unique(Y);
FoI = Y == valoresY(2); % Filas de la clase de interes - color de seguimiento
Xclase = X(FoI,:);

% VALORES REPRESENTATIVOS DE ESA CLASE: Valores medios, m?ximos y m?nimos
% de cada atributo (R, G, B)
valoresMedios = mean(Xclase);
valoresMaximos = max(Xclase);
valoresMinimos = min(Xclase);

%% PRIMERA OPCION
% CARACTERIZACION DE LA REGION DE INTERES BASADA EN ESTABLECER UN PRISMA
% RECTANGULAR EN EL ESPACIO RGB ASOCIADO AL COLOR DE SEGUIMIENTO

% DIMENSIONES DEL PRISMA BASADA EN VALORES MAXIMOS Y MINIMOS DE ESTA FORMA
% ENGLOBA A TODOS LOS PIXELES DEL COLOR
Rmin = valoresMinimos(1); Rmax = valoresMaximos(1);
Gmin = valoresMinimos(2); Gmax = valoresMaximos(2);
Bmin = valoresMinimos(3); Bmax = valoresMaximos(3);

% REPRESENTACION DEL PRISMA EN EL ESPACIO DE CARACTERISTICAS
close all
open('FigPrismaRectVerdeDimMaximas.fig')

% CLASIFICADOR: REGLA DE DECISION SENCILLA
% Considerar que un pixel caracterizado por R, G y B es del color si: 
% (Rmin < R < Rmax) && (Gmin < G < Gmax) && (Bmin < B < Bmax)

hold on, representa_datos_fondo(X,Y)
close all

% CONCLUSION: SI SE UTILIZA ESTE ESQUEMA DE CLASIFICACION PARA ANALIZAR LOS
% FRAMES DEL VIDEO:

% POR CADA FRAME Y CADA PIXEL DEL MISMO:
% 1.- SACAR SUS VALORES R, G, B
% 2.- EVALUAR LA REGLA DE DECISION ANTERIOR Y GENERAR IMAGEN BINARIA
% 3.- ETIQUETAR AGRUPACIONES CONEXAS DE 1'S Y CALCULAR SUS CENTROIDES
% 4.- MODIFICAR EL FRAME ORIGINAL PARA VISUALIZAR LOS CENTROIDES CON CAJAS
% 3x3
% 5.- GENERAR VIDEO DE SALIDA CON FRAMES PROCESADOS

implay('01_ColorVerde_ModParalMinMax_NoMov.avi')

% Observacion: si se pierde el objeto es porque las muestras de color
% extraidas de las imagenes de clasificacion no han sido representativas, no
% hay ninguna imagen que haya caracterizado el color del objeto en esa
% posicion donde se pierde el seguimiento.

%% SEGUNDA OPCION
% CARACTERISTA BASADA EN SUPERFICIE ESFERICA CENTRADA EN EL COLOR MEDIO

% Centro de la Esfera: Color Medio
valoresMedios = mean(Xclase);
Rc = valoresMedios(1); Gc = valoresMedios(2); Bc = valoresMedios(3);

% Representamos el centroide sobre la nube de puntos del color de
% seguimiento
close all, representa_datos_color_seguimiento_fondo(X,Y)
hold on, plot3(Rc, Gc, Bc, '*k');

% Para calcular radios representativos de posibles esferas:
% DEPENDE DEL CRITERIO: VER ENUNCIADO PDF, COMIENZO APARTADO 3.1

% 1.- NO PERDER EL OBJETO EN NINGUNA POSICION
% El radio (r1) de esfera debe ser igual a la distancia entre el centroide
% de la esfera y el punto de la nube de puntos del color de seguimiento que
% se encuentre m?s lejos de ese centroide

% 2.- NO DETECTAR NADA DE RUIDO DE FONDO
% El radio (r2) debe situarse a la distancia entre el centroide de la
% esfera y el punto m?s cercano de la nube de puntos de fondo

% 3.- COMPROMISO ENTRE DETECCION DE OBJETO Y RUIDO DE FONDO
% Solo tiene sentido si r2 es menor que r1
% Este criterio busca un compromiso entre deteccion de objeto  y ruido:
% Este radio de compromiso (r12) sera el valor medio de los dos radios
% anteriores

% PARA IMPLEMENTAR ESTE CONCEPTO DISE?AR LA SIGUIENTE FUNCION:

% datosEsfera = calcula_datos_esfera(X,Y)
% Pasos de la funcion:
% 1.- Calcula centroide de la nube de puntos del color de seguimiento: Rc,
% Gc, Bc
% 2.- Calcula vector distancias entre el centroide anterior y cada uno de
% los puntos de X (hay muestras de color del objeto y de fondo)
% 3.- Extraer los valores de cada clase: por una parte los valores de
% distancia entre centroide y las muestras de color del objeto y, por otra,
% los valores de distancia entre el centroide y las muestras de fondo.
% 4.- Calcular r1, r2 a partir de los vectores distancia anteriores
% 5.- Cacular el radio de compromiso r12
% 6.- Devolver datosEsfera = [Rc, Gc, Bc, r1, r2, r12] (vector fila)

datosEsfera = calcula_datos_esfera(X,Y)

% Extraemos en variables la informacion de datosEsfera
Rc = datosEsfera(1);
Gc = datosEsfera(2);
Bc = datosEsfera(3);
radioSinPerdida = datosEsfera(4);
radioSinRuido = datosEsfera(5);
radioCompromiso = datosEsfera(6);

% AYUDA MATLAB: CALCULO DE DISTANCIAS DE UN PUNTO A UNA NUBE DE PUNTOS

% Representamos las tres esferas en el espacio de caracteristicas junto con
% las muestras de color y fondo

% AYUDA MATLAB: REPRESENTACION SUFERFICIE ESFERICA EN ENUNCIADO PDF:
% funcion representa_esfera

close all
centroide = datosEsfera(1:3); radios = datosEsfera(4:6);
for i=1:length(radios)
    representa_datos_color_seguimiento_fondo(X,Y)
    hold on, representa_esfera(centroide, radios(i)), hold off
    title(['Esfera de Radio: ' num2str(radios(i))])
end
close all

% CLASIFICADOR BASADO EN SUPERFICIE ESFERICA: REGLA DE DECISION SENCILLA
% Considerar que un pixel caracterizado por R, G y B es del color si:
% la distancia (R,G,B) del pixel y el centro de la esfera (Rc, Gc, Bc) es
% menor que el Radio que se haya elegido segun el criterio

% 1.- CARGAR DATOS DE LA ESFERA: CENTROIDE (Rc, Gc, Bc) Y RADIO R
% 2.- POR CADA FRAME Y CADA PIXEL DEL MISMO:
% 2.1.- SACAR LOS VALORES R, G, B DEL PIXEL BAJO CONSIDERACION
% 2.2.- EVALUAR LA DISTANCIA d ENTRE (R,G,B) Y (Rc,Gc,Bc)
% 2.3.- SI d < Radio de la esfera R: ENTONCES EL PIXEL ES DEL COLOR
% 2.4.- LA REGLA ANTERIOR APLICADA A TODOS LOS PIXELES GENERA UNA IMAGEN
% BINARIA - MODIFICAR EL FRAME ORIGINAL PARA VISUALIZAR LOS CENTROIDES DE
% LAS AGRUPACIONES CON CAJAS 3x3
% 2.5.- GENERAR VIDEO DE SALIDA CON LOS FRAMES PROCESADOS

% IMPORTANTE: IMPLEMENTACION MATRICIAL
% POR CADA FRAME: Icolor
% R=double(Icolor(:,:,1)), G=double(Icolor(:,:,2)), B=double(Icolor(:,:,3))
% Matriz Distancia MD = sqrt ( (R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2 )
% Imagen binaria de puntos detectados como del color: Ib = MD < R;
% Analizar componentes conectadas y calcular sus centroides para modificar
% el frame del video de salida
% DE LA IMAGEN DADOS POR SUS VALORES RGB AL CENTROIDE DE LA ESFERA:

implay('02_ColorVerde_ModDistEucCompleta_NoMov.avi')

% COMO HABIAMOS DEDUCIDO, EL ALGORITMO SE COMPORTA MUY BIEN DISCRIMINANDO
% RUIDO PERO EL CLASIFICADOR NO DETECTA EL OBJETO EN SUS POSICIONES MAS
% ALEJADAS. LAS MUESTRAS DEL COLOR QUE SE QUEDAN FUERA DE LA ESFERA SON
% PRECISAMENTE LAS MUESTRAS QUE SE OBTUVIERON DE LAS IMAGENES DE
% CALIBRACION QUE TENIAMOS CON EL OBJETO EN LAS POSICIONES MAS ALEJADAS

% UNA SUPERFICIE ESFERICA: AL IGUAL QUE EL PRISMA, TAMPOCO HA SIDO UNA
% SOLUCION EFECTIVA, INCLUSO PARA RESOLVER EL PROBLEMA QUE TENIA LAS
% MUESTRAS DE LAS DOS CLASES MUY SEPARADAS

% EL PROBLEMA SE AGRAVA CUANDO LAS MUESTRAS DE LAS CLASES ESTEN MAS JUNTAS

% ES IMPOSIBLE MODELAR LA NUBE DE PUNTOS DEL COLOR CON UNA UNICA ESFERA SIN
% INCLUIR MUESTRAS DE FONDO DE LA ESCENA (RUIDO EN EL VIDEO)

% MOTIVO: LOS DATOS NO SE DISTRIBUYEN DE FORMA ESFERICA, PRESENTAN UNA
% DISPERSION QUE HACEN QUE HAYA QUE BUSCAR ALTERNATIVAS

% EJEMPLO: ANALIZAMOS VIDEO DEL OBJETO AZUL

clear, close all
Color = 'Azul';
sentenciaTexto = ['load conjunto_de_datos_' Color '.mat'];
eval(sentenciaTexto)

representa_datos_color_seguimiento_fondo(X,Y)

datosEsfera = calcula_datos_esfera(X, Y)

close all
centroide = datosEsfera(1:3); radios = datosEsfera(4:6);
for i=1:length(radios)
    representa_datos_color_seguimiento_fondo(X,Y)
    hold on, representa_esfera(centroide, radios(i)), hold off
    title(['Esfera de Radio: ' num2str(radios(i))])
end

% SOLO PODEMOS SEGUIR EL OBJETO DETECTANDO RUIDO (COLORES MAS PARECIDOS DEL
% FONDO DE LA ESCENA AL DEL OBJETO)
implay('03_ColorAzul_ModDistEucCompleta_NoMov.avi')

%% EJERCICIO ANTES DE ABORDAR LA SIGUIENTE ETAPA DEL ALGORITMO FINAL

% DISE?AR TODAS LAS FUNCIONES A LAS QUE SE HACE REFERENCIA EN ESTE VIDEO
% PARA ESTA OPCION DE CLASIFICACION BASADA EN CARACTERIZAR LA NUBE DE
% PUNTOS DEL COLOR POR MEDIO DE UNA UNICA ESFERA

% APLICAR ESTA TECNICA DE CLASIFICACION EN LAS IMAGENES DE CALIBRACION

% POR CADA IMAGEN DE CALIBRACION SE DEBE GENERAR UNA VENTANA TIPO FIGURE
% CON CUATRO GRAFICAS (SUBPLOT DE DOS FILAS Y DOS COLUMNAS DE GRAFICAS):

% PRIMERA GRAFICA: IMAGEN DE COLOR DE CALIBRACION ORIGINAL

% SEGUNDA GRADICA: IMAGEN ANTERIOR DONDE SE VISUALIZAN EN UN COLOR LOS
% PIXELES QUE SE DETECTAN COMO DEL COLOR DE SEGUIMIENTO UTILIZANDO EL RADIO
% DEL PRIMER CRITERIO: r1 (SE DETECTAN TODOS LOS PIXELES DEL COLOR). PARA
% ELLO UTILIZA LA FUNCION_VISUALIZA

% TERCERA Y CUARTA GRAFICA: IGUAL PARA LOS RADIOS r2 (no detecta ruido) Y
% r12 (radio de compromiso).


clear, close all, clc

%%RUTAS A DIRECTORIOS CON INFORMACIÓN
addpath('../02_ExtracionDatos/VariablesGeneradas')
addpath('Funciones')

%%Lectura y representación de datos
%Datos extraidos de imágenes de calibración
sentenciaTexto = ('load Conjunto_de_Datos.mat');
eval(sentenciaTexto)

representa_datos_color_seguimiento_fondo(X,Y)

%%Diseño Clasificador: Una esfera, 3 radios: Sin perdida, sin ruido,
%%compromiso

datosEsfera = calcula_datos_esfera(X,Y);

close all;
centroide = datosEsfera(1:3); radios = datosEsfera(4:6);
for i=1:length(radios)
    representa_datos_color_seguimiento_fondo(X,Y)
    hold on, representa_esfera(centroide, radios(i)), hold off
    title(['Esfera de Radio: ' num2str(radios(i))])
end

%%Aplicacion del clasificador sobre las imágenes de calibracion
addpath('../01_ObjetivosMaterial')
sentenciaTexto = ('load ImagenesEntrenamiento_Calibracion.mat');
eval(sentenciaTexto)

[N, M, NumComp, NumImag] = size(Imagenes);
for i=1:NumImag
    imshow(Imagenes(:,:,:,i)),title(num2str(i))
    pause
end
close all

%VISUALIZACIÓN DETECCION DE LAS ESFERAS EN CADA IMAGEN

%En cada ventana, 4 representaciones, la original y el resultado de la
%deteccion con cada uno de los tres criterios de radios de esferas
%considerado.

close all

criteriosRadios{1} = 'Radio sin perdida de color';
criteriosRadios{2} = 'Radio sin ruido de fondo';
criteriosRadios{3} = 'Radio de compromiso';

color = [0 255 0];

for i=1:NumImag
    
    figure(i), set(i,'Name',['Imagen de Calibración número ' num2str(i)])
    I = Imagenes(:,:,:,i);
    
    subplot(2,2,1), imshow(I), title(['Imagen ' num2str(i)])
    
    for j=1:length(criteriosRadios)
        centroides_radios = datosEsfera(:,[1:3 3+j]);
        
        Ib_deteccion_por_distancia = ...
            calcula_deteccion_1esfera_en_imagen(I, centroides_radios);
        
        subplot(2,2,j+1), funcion_visualiza(I,Ib_deteccion_por_distancia, color)
        title(criteriosRadios{j})
       
    end
     pause
end
