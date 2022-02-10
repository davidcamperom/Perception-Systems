clear, close all

%CARGAMOS RUTAS A DIRECTORIOS: DATOS Y FUNCIONES

addpath('../02_ExtracionDatos/VariablesGeneradas')
addpath('Funciones')

%CARGAMOS CONJUNTO DE DATOS
load Conjunto_de_Datos.mat

%Tranformamos la X a double para trabajar con las proximas funciones
X = double(X);

%%REPRESENTACIÓN DE LOS DATOS
representa_datos_color_seguimiento_fondo(X,Y)

%%ANÁLISIS DE LOS DATOS DE LA CLASE

valoresY = unique(Y);
FoI = Y == valoresY(2); %Filas de la clase de interés - Color de seguimiento
Xclase = X(FoI,:);

close all
numDatosClase = size(Xclase,1);
numAtributos = size(Xclase,2);
datosAtributos = [];

nombreAtributos = {'R', 'G', 'B'};

for i=1:numAtributos
   x = Xclase(:,i); %Dato del atributo 
   
   %Algunos valores presentativos de la muestra
   valor_medio = mean(x);
   desv_tipica = std(x);
   mediana = median(x);
   x_ord = sort(x); %Ordenamos la secuencia de datos para los cuartiles
   Q1 = x_ord(round(0.25*numDatosClase)); %El valor de la muestra ordenada
   %que hace el 25% de los datos.
   Q3 = x_ord(round(0.75*numDatosClase)); %El valor de la muestra ordenada
   %que hace el 75% de los datos
   %rango_intercuartilico = Q3-Q1;
   
   datos = [valor_medio; desv_tipica; Q1; mediana; Q3; min(x); max(x)];
   datosAtributos = [datosAtributos datos];
   
    figure
    subplot(1,2,1), hist(x)
    subplot(1,2,2), boxplot(x)
    sgtitle(nombreAtributos{i})
end
datosAtributos

%% POSIBLES CRITERIOS DE DETECCION DE OUTLIERS

%f1 y f2 marcan el rango de variacion normal de los valores
%Un valor definido fuera de f1 y f2 va a ser considerado outlier

% f1 = Q1 - 1.5*rango_intercuartilico;
% f2 = Q3 + 1.5*rango_intercuartilico;

% f1 = valor_medio - 3*desv_tipica;
% f2 = valor_medio + 3*desv_tipica;

% rangoNoOutliers = [f1 f2]; % Los factores 1.5 y 3 pueden variarse
% dependiendo del nivel de exigencia para considerar un dato como outlier

rangoOutliersAtrbutos1 = [];
rangoOutliersAtrbutos2 = [];

for i=1:numAtributos
    x = Xclase(:,i);    % Datos del atributo

    % Algunos valores representativos de la muestra
    valor_medio = mean(x);
    desv_tipica = std(x);
    
    x_ord = sort(x); %Ordenamos para luego sacar los cuartiles 
    Q1 = x_ord(round(0.25*numDatosClase));
    Q3 = x_ord(round(0.75*numDatosClase));
    rango_intercuartilico = Q3-Q1; %Para poder definir f1 y f2
    %Si está dentro de estos dos valores, se considerará un valor normal y
    %por tanto entrará como valor válido

    f1 = Q1 - 1.5*rango_intercuartilico;
    f2 = Q3 + 1.5*rango_intercuartilico;
    rangoOutliersAtrbutos1 = [rangoOutliersAtrbutos1 [f1; f2]];

    f1 = valor_medio - 3*desv_tipica;
    f2 = valor_medio + 3*desv_tipica;
    rangoOutliersAtrbutos2 = [rangoOutliersAtrbutos2 [f1; f2]];
end

rangoOutliersAtrbutos1
rangoOutliersAtrbutos2