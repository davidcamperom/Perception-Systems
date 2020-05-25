%% CLASES DESBALANCEADAS: MÉTODO MÍNIMO ENTRE MÁXIMOS

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
%se mostrará la imagen aún no filtrada de basura. Sus datos se
%representarán de color rojo (Ya que está en el campo R el 255)
figure, imhist(uint8(I))
title(['Umbral: ' num2str(g_MinEntreMax)])

%% PROGRAMACIÓN FUNCIÓN MÍNIMO ENTRE MÁXIMOS

% IMPORTANTE: Consideramos en toda la programación niveles de gris de 1 a
% 256, después al resultado le restamos una unidad.

% OBJETIVO: Calcular los dos máximos correspondientes a las clases
% principales del histograma y después el valor mínimo entre ellos.

% 1.- Nivel de gris del maximo mayor:

[h, nivelesGris] = imhist(I); %I tipo uint8
[numPixMax, g1max] = max(h); % MUCHO CUIDADO: el nivel de gris real es g1max-1

close all, imhist(I); axis([0 255 0 max(h)+1000]), title(num2str(g1max))