%% INTRODUCCI�N AL PROBLEMA DE SEGMENTACI�N - HISTOGRAMA BIMODAL
%% CLASES ONJETO-FONDO BIEN SEPARADAS

clear, clc, close all
addpath('Imagenes')
addpath('Funciones')

I = imread('Matric.tif');
imshow(I)
figure, imhist(uint8(I))

%% OBJETIVO: SELECCIONAR DE FORMA AUTOM�TICA UMBRALES DE SEPARACI�N ENTRE CLASES

%% PRIMERA OPCI�N B�SICA: UTILIZAR ESTAD�STICOS SIMPLES: EJEMPLO - VALOR MEDIO

Id = double(I);
T = mean(Id(:)); %Umbral (T)
Ib = Id < T;
figure,
subplot(2,1,1), imshow(uint8(Id))
subplot(2,1,2), funcion_visualiza(uint8(Id), Ib, [255 0 0])

%% PEQUE�O PAR�NTESIS - TERMINAMOS DE SEGMENTAR LOS CARACTERES
% ASUMIMOS QUE CONOCEMOS EL NUMERO DE CARACTERES, NOS QUEDAMOS CON LOS M�S
% GRANDES

numCaracteres = 7; % Queremos segmentar los 7 caracteres m�s grandes
[Ietiq, Nobj] = bwlabel(Ib); % Distiguimos las agrupaciones
% Observamos que Nobj tiene 104, es decir, tiene mucha basura
% Lo que haremos ser� ver cu�ntos pixeles tienen las 7 agrupaciones
% mayores y despu�s usaremos bwareaopen para adivinar el resto

%Calculamos las �reas:
stats = regionprops(Ietiq,'Area');
%Accedemos al vector de areas
areas = cat(1, stats.Area);
%Ordenamos de forma descendente (de mayor a menor)
areas_ord = sort(areas, 'descend');
numPix = areas_ord(numCaracteres);
%Filtramos la basura de la imagen binaria que no quer�amos
IbFiltrada = bwareaopen(Ib, numPix);
figure,
subplot(3,1,1), imshow(uint8(Id))
subplot(3,1,2), funcion_visualiza(uint8(Id), Ib, [255 0 0]) %Con este subplot
%se mostrar� la imagen a�n no filtrada de basura. Sus datos se
%representar�n de color rojo (Ya que est� en el campo R el 255)
subplot(3,1,3), funcion_visualiza(uint8(Id), IbFiltrada, [0 255 0]) %Pero con
%este, se mostrar� la imagen filtrada de basura. Sus datos se
%representar�n de color verde (Ya que est� en el campo G el 255)

close all;
figure,
subplot(4,1,1), imshow(uint8(Id))
subplot(4,1,2), funcion_visualiza(uint8(Id), Ib, [255 0 0]) %Con este subplot
%se mostrar� la imagen a�n no filtrada de basura. Sus datos se
%representar�n de color rojo (Ya que est� en el campo R el 255)
subplot(4,1,3), funcion_visualiza(uint8(Id), IbFiltrada, [0 255 0]) %Pero con
%este, se mostrar� la imagen filtrada de basura. Sus datos se
%representar�n de color verde (Ya que est� en el campo G el 255)

% Para etiquetar los n�meros de la matr�cula:
Ietiq = bwlabel(IbFiltrada);
R = uint8(Id); G = R; B = R;
colores = uint8((255*rand(numCaracteres, 3)));
for i = 1:numCaracteres
    IbFiltrada_i = Ietiq == i;
    R(IbFiltrada_i) = colores(i,1);
    G(IbFiltrada_i) = colores(i,2);
    B(IbFiltrada_i) = colores(i,3);
end
subplot(4,1,4), imshow(cat(3,R,G,B))

%% RETOMAMOS HISTOGRAMA BIMODAL, CON CLASES OBJETO-FONDO BIEN SEPARADOS

% UMBRALES BASADOS EN ESTAD�STICOS SIMPLES: EJEMPLO - VALOR MEDIO
clear, clc, close all
addpath('Imagenes')
addpath('Funciones')
I = imread('Matric.tif');
Id = double(I);
T = mean(I(:));
Ib = I < T;
figure,
subplot(3,1,1), imshow(uint8(Id))
subplot(3,1,2), imhist(uint8(Id))
subplot(3,1,3), funcion_visualiza(uint8(Id), Ib, [255 0 0]) %Con este subplot
%se mostrar� la imagen a�n no filtrada de basura. Sus datos se
%representar�n de color rojo (Ya que est� en el campo R el 255)
title(['Umbral definido como valor medio: ' num2str(T)])

% CLASE SEPARADAS PERO DESBALANCEADAS: EL UMBRAL EST� MUY ESCORADO
% LA CLASE M�S NUMEROSA. MEJOR: M�TODO DE M�NIMO ENTRE M�XIMO

                                % Hay que desarrollar esta funci�n
[g_MinEntreMax, gmax1, gmax2] = funcion_MinEntreMax(Id, 'NO')
Ib = I < g_MinEntreMax;
figure,
subplot(2,1,1), imshow(uint8(Id))
subplot(2,1,2), funcion_visualiza(uint8(Id), Ib, [255 0 0]) %Con este subplot
%se mostrar� la imagen a�n no filtrada de basura. Sus datos se
%representar�n de color rojo (Ya que est� en el campo R el 255)
figure, imhist(uint8(I))
title(['Umbral: ' num2str(g_MinEntreMax)])