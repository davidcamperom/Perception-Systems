addpath('../01_ObjetivosMaterial');
load ImagenesEntrenamiento_Calibracion.mat

[N M NumComp NumImag] = size(ImagenesEntrenamiento_Calibracion);

%2.1.1
DatosFondo=[];

for i=1:2
    I = ImagenesEntrenamiento_Calibracion(:,:,:,i);

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    ROI = roipoly(I);
    DatosFondo = [DatosFondo; i*ones(length(R(ROI)),1) R(ROI) G(ROI) B(ROI)];
end

%2.1.2
DatosColor=[];

for i=3:11
    I = ImagenesEntrenamiento_Calibracion(:,:,:,i);

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    ROI = roipoly(I);
    DatosColor = [DatosColor; i*ones(length(R(ROI)),1) R(ROI) G(ROI) B(ROI)];
end

%Hacemos un save para guardar los datos en estas dos variables, NO ES
%NECESARIO
%save DatosEntrenamiento DatosColor DatosFondo

%2.1.3
X = [DatosColor(:,2:4)          ;   DatosFondo(:,2:4)];

Y = [ones(size(DatosColor,1),1) ;   zeros(size(DatosFondo,1),1)];

%Guardamos la toma de datos
save('./VariablesGeneradas/Conjunto_de_Datos', 'X', 'Y')