%% CLASES DESBALANCEADAS: M�TODO M�NIMO ENTRE M�XIMOS

clear, clc, close all
addpath('Funciones')
addpath('Imagenes')

I = imread('Matric.tif');
Id = double(I);
[g_MinEntreMax, gmax1, gmax2] = funcion_MinEntreMax(Id,[])
Ib = I < g_MinEntreMax;
figure,
subplot(2,1,1), imshow(uint8(Id))
subplot(2,1,2), funcion_visualiza(uint8(Id), Ib, [255 0 0]) %Con este subplot
%se mostrar� la imagen a�n no filtrada de basura. Sus datos se
%representar�n de color rojo (Ya que est� en el campo R el 255)
figure, imhist(uint8(I))
title(['Umbral: ' num2str(g_MinEntreMax)])

%% PROGRAMACI�N FUNCI�N M�NIMO ENTRE M�XIMOS

% IMPORTANTE: Consideramos en toda la programaci�n niveles de gris de 1 a
% 256, despu�s al resultado le restamos una unidad.

% OBJETIVO: Calcular los dos m�ximos correspondientes a las clases
% principales del histograma y despu�s el valor m�nimo entre ellos.

% 1.- Nivel de gris del maximo mayor:

[h, nivelesGris] = imhist(I); %I tipo uint8
[numPixMax, g1max] = max(h); % MUCHO CUIDADO: el nivel de gris real es g1max-1

close all, imhist(I); axis([0 255 0 max(h)+1000]), title(num2str(g1max))