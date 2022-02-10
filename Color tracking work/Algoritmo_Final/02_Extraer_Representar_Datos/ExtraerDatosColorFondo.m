clear, close all
addpath('Funciones')
addpath('../01_GeneracionMaterial')

%%Lectura de imágenes y extracción de datos

%Leemos imágenes de Calibración

load ImagenesEntrenamiento_Calibracion.mat

[N M NumComp NumImag] = size(ImagenesEntrenamiento_Calibracion);

%Vemos las imágenes
for i=1:NumImag
    imshow(ImagenesEntrenamiento_Calibracion(:,:,:,i)), title(num2str(i))
    pause
end

%Generamos DatosColor
DatosColor=[];

for i=3:11
    I = ImagenesEntrenamiento_Calibracion(:,:,:,i);

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    ROI = roipoly(I);
    DatosColor = [DatosColor; i*ones(length(R(ROI)),1) R(ROI) G(ROI) B(ROI)];
end

%Generamos DatosFondo
DatosFondo=[];

for i=1:2
    I = ImagenesEntrenamiento_Calibracion(:,:,:,i);

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    ROI = roipoly(I);
    DatosFondo = [DatosFondo; i*ones(length(R(ROI)),1) R(ROI) G(ROI) B(ROI)];
end

%Generamos Conjunto de Datos X, Y
X = [DatosColor(:,2:4)          ;   DatosFondo(:,2:4)];
Y = [ones(size(DatosColor,1),1) ;   zeros(size(DatosFondo,1),1)];

%Guardamos la toma de datos
save('./VariablesGeneradas/Conjunto_de_Datos_original', 'X', 'Y')

%%REPRESENTACIÓN DE LA INFORMACIÓN
clear
load('./VariablesGeneradas/Conjunto_de_Datos_original.mat')
close all
representa_datos_color_seguimiento_fondo(X,Y)

%%DETECCIÓN Y ELIMINACIÓN DE OUTLIERS
%GENERACIÓN CONJUNTO FINAL DE DATOS

pos_outliers = funcion_detecta_outliers_clase_interes(X,Y);

X(pos_outliers,:) = [];
Y(pos_outliers,:) = [];

representa_datos_color_seguimiento_fondo(X,Y)

save('./VariablesGeneradas/Conjunto_de_Datos', 'X', 'Y')