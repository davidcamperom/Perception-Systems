clear, close all;

%% RUTAS A DIRECTORIOS Y CARGA DE INFORMACIÓN
addpath('../06_DiseñoClasificador_MultiplesEsferas/Funciones')
addpath('Funciones')

load('../01_ObjetivosMaterial/ImagenesEntrenamiento_Calibracion.mat')
addpath('../02_ExtracionDatos/VariablesGeneradas')
load('../06_DiseñoClasificador_MultiplesEsferas/VariablesGeneradas/datos_multiples_esferas.mat')
addpath('../05_FundamentosEstrategiaClasificacion/Funciones/')

%% CALIBRACIÓN DE PARÁMETROS: RADIO ESFERAS Y UMBRAL DE CONECTIVIDAD

% -----------------
% CALIBRACIÓN DE RADIO DE LAS ESFERAS
% -----------------

% 1.- VISUALIZACIÓN DETECCIÓN DE LAS ESFERAS EN CADA IMÁGEN

% En cada ventana, 4 representaciones, la original y el resultado de la
% detección con cada uno de los tres criterios de radios de esferas
% considerado.

% NO VAMOS A MEZCLAR CRITERIOS, TODAS LAS ESFERAS DE LAS
% AGRUPACIONES SE VAN A DISEÑAR MANTENIENDO EL CRITERIO

% 2.- ELECCIÓN DE RADIO EN BASE AL ANÁLISIS DE LAS IMÁGENES ANTERIOERS

% Posible radios y criterios:
% 1: radio sin pérdida color
% 2: radio sin ruido de fondo
% 3: radio de compromiso

radio = 1;
datosMultiplesEsferas_clasificador = datosMultiplesEsferas(:,[1:3 3+radio]);

% NOTAR QUE ESTA VARIABLE datosMultiplesEsferas_clasificador TIENE LA MISMA
% ESTRUCTURA QUE LA QUE SE LE HA PASADO POR PARÁMETRO A LA FUNCIÓN
% calcula_deteccion_multiples_esferas_en_imagen


% -------------------------
% CALIBRACIÓN DE PARÁMETRO DE CONECTIVIDAD: numPix
% -------------------------

% DE LA IMAGEN BINARIA RESULTANTE DE LA DETECCIÓN POR DISTANCIA SE ELIMINAN
% TODAS LAS AGRUPACIONES CONECTADAS DE MENOS DE numPix PÍXELES

% ESTE PARÁMETRO numPix SE AJUSTA SOBRE LA IMAGEN DONDE EL OBJETO SE
% ENCUENTRA EN LA POSICIÓN MÁS ALEJADA (ES CUANDO ES MÁS PEQUEÑO)

% 1.- Utilizando roipoly, marcamos la superficie del objeto
% 2.- Calculamos el área o número de píxeles del objeto en esta posición
% Notar que este es el valor máximo que puede tener este parámetro si no se
% quiere perder el objeto en esta posición
% 3.- Seleccionar numPix como un porcenatje de esta área del objeto en su
% posición más alejada

% Cálculo del área del objeto en su posición más alejada

%Para ver las imágenes:
[N, M, numComp, numImag] = size(Imagenes);
for i=1:numImag
    imshow(Imagenes(:,:,:,i)), title(num2str(i))
    pause
end

%numImag = size(Imagenes,4); % En nuestro caso es la última imágen
I_objeto_pos_mas_alejada = Imagenes(:,:,:,11);
Ib = roipoly(I_objeto_pos_mas_alejada);
numPixReferencia = sum(Ib(:));

numPixAnalisis = round([0.25 0.5 0.75]*numPixReferencia);

% Al igual que antes, visualizamos cuatro gráficas por cada imagen
% 1.- Imagen de calibración con la detección por distancia sin eliminar
% nada
% 2, 3 y 4: se eliminan las componentes conectadas con los tres valores de
% prueba del vector numPixAnalisis

color = [0 255 0];
valoresConectividad{1} = ['numPix = ' num2str(numPixAnalisis(1))];
valoresConectividad{2} = ['numPix = ' num2str(numPixAnalisis(2))];
valoresConectividad{3} = ['numPix = ' num2str(numPixAnalisis(3))];

close all
figure
for i=1:size(Imagenes,4)
    I = Imagenes(:,:,:,i);
    
    Ib_original = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas_clasificador);
    Ib1 = bwareaopen(Ib_original, numPixAnalisis(1));
    Ib2 = bwareaopen(Ib_original, numPixAnalisis(2));
    Ib3 = bwareaopen(Ib_original, numPixAnalisis(3));
    
    subplot(2,2,1), funcion_visualiza(I, Ib_original, color), title(['Detección original img:' num2str(i)]),
    hold on, subplot(2,2,2), funcion_visualiza(I, Ib1, color), title(valoresConectividad{1}),
    hold on, subplot(2,2,3), funcion_visualiza(I, Ib2, color), title(valoresConectividad{2}),
    hold on, subplot(2,2,4), funcion_visualiza(I, Ib3, color), title(valoresConectividad{3});
    pause
end

% Elección de numPix en base al análisis de las imágenes anteriores
numPix = numPixAnalisis(1);

%% GUARDAMOS PARÁMETROS PARA LA APLICACIÓN DEL CLASIFICADOR

save('./VariablesGeneradas/parametros_clasificador', 'datosMultiplesEsferas_clasificador', 'numPix')
save('../08_AlgoritmoVideo_SoloColor/VariablesRequeridas/parametros_clasificador', 'datosMultiplesEsferas_clasificador', 'numPix')