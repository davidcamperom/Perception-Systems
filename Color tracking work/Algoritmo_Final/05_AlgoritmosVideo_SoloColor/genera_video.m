%% RUTAS A DIRECTORIOS Y CARGA DE INFORMACIÓN
clear, clc, close all;
addpath('VariablesRequeridas')
addpath('../01_ObjetivosMaterial')
addpath('../07_AjusteClasificador_ImgCalib/VariablesGeneradas/')
addpath('Funciones')

%% DATOS CLASIFICADOR
load parametros_clasificador.mat

%% LECTURA VIDEO DE ENTRADA
nombre_archivo_video_entrada='VideoSeguimientoAzul.avi';
videoInput = VideoReader(nombre_archivo_video_entrada);
[numFrames, numFilasFrame, numColumnasFrame, FPS] = carga_video_entrada(videoInput);

%% GENERACIÓN VÍDEO DE SALIDA
nombre_archivo_video_salida = 'VideoSalida_VideoSeguimientoAzul.avi';
videoOutput = VideoWriter(nombre_archivo_video_salida);
videoOutput.FrameRate = FPS;
open(videoOutput)

color = [255 255 0];

% Por cada frame del vídeo de entrada:

% - Calcular imagen binaria de detección por distancia basada en múltiples
% esferas

% - Eliminar agrupaciones de 1's binarios que no tengan un área mínima
% según umbral de conectividad. El resultado sigue siendo una matriz
% lógica.

% - Sólo si hay 1's binarios en la matriz binaria anterior (si no hay, es
% que no se ha detectado nada y no hay nada que mostrar; en este caso el
% vídeo de salida se genera con el frame del vídeo de entrada sin
% modificar)

%   - Etiquetar
%   - Calcular los centroides de las agrupaciones
%   - Modificar el frame que está siendo analizado situando una caja blanca
%   3x3 centrada en los píxeles más cercanos a cada centroide obtenido.

%   Si no es posible situar la caja 3x3 por no entrar en las dimensiones de
%   la imagen, únicamente localizar cada centroide, poniendo en color
%   blanco únicamente el píxel en cuestión.

%   - Escribir el frame modificado en el archivo de vídeo de salida.

for i=1:numFrames
    I = read(videoInput,i);
    numEsferas = size(datosMultiplesEsferas_clasificador,1);
    
    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));
    
    Ib = zeros(size(I,1),size(I,2));
    
    for j=1:numEsferas
        Rc = datosMultiplesEsferas_clasificador(j,1);
        Gc = datosMultiplesEsferas_clasificador(j,2);
        Bc = datosMultiplesEsferas_clasificador(j,3);
        
        radio = datosMultiplesEsferas_clasificador(j,4);

        MD = sqrt( (R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2 );

        % Matriz lógica
        Ib = or(Ib, MD < radio);
    end
    
    Ib_clear = bwareaopen(Ib, numPix);
    
    if ( sum(Ib_clear(:)) == 0 )
        writeVideo(videoOutput, I);
    else
        [Ietiq, numAgrupaciones] = bwlabel(Ib_clear);
        stats = regionprops(Ietiq, 'Area', 'Centroid');
        centro_agrupacion = stats.Centroid;
        
        fila = int64(centro_agrupacion(2));
        columna = int64(centro_agrupacion(1));
        
        if ( (columna-1 > 0 || columna+1 < numColumnasFrame) && (fila-1 > 0 || fila+1 < numFilasFrame) )
            I(fila, columna,:) = color;
            I(fila+1, columna,:) = color;
            I(fila-1, columna,:) = color;
            I(fila, columna+1,:) = color;
            I(fila, columna-1,:) = color;
            I(fila+1, columna+1,:) = color;
            I(fila+1, columna-1,:) = color;
            I(fila-1, columna+1,:) = color;
            I(fila-1, columna+1,:) = color;
            I(fila-1, columna-1,:) = color;
        else
            I(fila,columna,:) = color;
        end
        
        writeVideo(videoOutput, I);
    end
    
end

close(videoOutput);

%% DIFERENCIA DE IMÁGENES
clear, clc;
addpath('VariablesRequeridas')
addpath('../07_AjusteClasificador_ImgCalib/VariablesGeneradas/')
addpath('Funciones')

%% DATOS CLASIFICADOR
load parametros_clasificador.mat

%% LECTURA VIDEO DE ENTRADA
nombre_archivo_video_entrada='VideoSeguimientoAzul.avi';
videoInput = VideoReader(nombre_archivo_video_entrada);
[numFrames, numFilasFrame, numColumnasFrame, FPS] = carga_video_entrada(videoInput);

%% GENERACIÓN VÍDEO DE SALIDA
nombre_archivo_video_salida = 'VideoSalida_VideoSeguimientoAzulV2.avi';
videoOutput = VideoWriter(nombre_archivo_video_salida);
videoOutput.FrameRate = FPS;
open(videoOutput)

color = [255 255 0];

umbral = 100;
I_ant = read(videoInput,1);
for i=2:numFrames
    I = read(videoInput,i);

    numEsferas = size(datosMultiplesEsferas_clasificador,1);
    
    R = double(I_ant(:,:,1));
    G = double(I_ant(:,:,2));
    B = double(I_ant(:,:,3));
    
    Ib = zeros(size(I_ant,1),size(I_ant,2));
    
    for j=1:numEsferas
        Rc = datosMultiplesEsferas_clasificador(j,1);
        Gc = datosMultiplesEsferas_clasificador(j,2);
        Bc = datosMultiplesEsferas_clasificador(j,3);
        
        radio = datosMultiplesEsferas_clasificador(j,4);

        MD = sqrt( (R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2 );

        % Matriz lógica
        Ib_ant = or(Ib, MD < radio);
    end
    
    numEsferas = size(datosMultiplesEsferas_clasificador,1);
    
    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));
    
    Ib_act = zeros(size(I,1),size(I,2));
    
    for j=1:numEsferas
        Rc = datosMultiplesEsferas_clasificador(j,1);
        Gc = datosMultiplesEsferas_clasificador(j,2);
        Bc = datosMultiplesEsferas_clasificador(j,3);
        
        radio = datosMultiplesEsferas_clasificador(j,4);

        MD = sqrt( (R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2 );

        % Matriz lógica
        Ib_act = or(Ib_act, MD < radio);
    end
    
    Ib_f = imabsdiff(Ib_ant, Ib_act);
        
    if ( sum(Ib_f(:)) == 0 )
        writeVideo(videoOutput, I);
    else
        [Ietiq, numAgrupaciones] = bwlabel(Ib_f);
        stats = regionprops(Ietiq, 'Area', 'Centroid');
        centro_agrupacion = stats.Centroid;
        
        fila = int64(centro_agrupacion(2));
        columna = int64(centro_agrupacion(1));
        
        if ( (columna-1 > 0 || columna+1 < numColumnasFrame) && (fila-1 > 0 || fila+1 < numFilasFrame) )
            I(fila, columna,:) = color;
            I(fila+1, columna,:) = color;
            I(fila-1, columna,:) = color;
            I(fila, columna+1,:) = color;
            I(fila, columna-1,:) = color;
            I(fila+1, columna+1,:) = color;
            I(fila+1, columna-1,:) = color;
            I(fila-1, columna+1,:) = color;
            I(fila-1, columna+1,:) = color;
            I(fila-1, columna-1,:) = color;
        else
            I(fila,columna,:) = color;
        end
        
        writeVideo(videoOutput, I);
    end
    
end

close(videoOutput);