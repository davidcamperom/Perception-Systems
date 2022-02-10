clear, close all
addpath('../01_ObjetivosMaterial')
addpath('Funciones')

%%Lectura de imágenes y extracción de datos

%Leemos imágenes de Calibración

load ImagenesEntrenamiento_Calibracion.mat

[N M NumComp NumImag] = size(Imagenes);

%Vemos las imágenes
for i=1:NumImag
    imshow(Imagenes(:,:,:,i)), title(num2str(i))
    pause
end

%Generamos DatosColor
DatosColor=[];

for i=4:11
    I = Imagenes(:,:,:,i);

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    ROI = roipoly(I);
    DatosColor = [DatosColor; i*ones(length(R(ROI)),1) R(ROI) G(ROI) B(ROI)];
end

%Generamos DatosFondo
DatosFondo=[];

for i=1:3
    I = Imagenes(:,:,:,i);

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
X = double(X);
save('./VariablesGeneradas/Conjunto_de_Datos', 'X', 'Y')

%%REPRESENTACIÓN DE LA INFORMACIÓN
clear
load('./VariablesGeneradas/Conjunto_de_Datos.mat')
close all
representa_datos_color_seguimiento_fondo(X,Y)
