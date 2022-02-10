%%GENERACIÓN DE DATOS, VÍDEO Y CAPTUTA DE FRAMES QUE QUERAMOS

% clear all
% clc
% close all
% 
% video=videoinput('winvideo',1,'YUY2_320x240'); 
% video.ReturnedColorSpace = 'rgb'; %Frames de intensidad
% video.TriggerRepeat=inf; % disparos continuados
% video.FrameGrabInterval=2; %Cogemos 1 de cada 3 frames (10fps)
% set(video, 'LoggingMode', 'memory')
% aviobj = VideoWriter('VideoSeguimientoRojo.avi', 'Uncompressed AVI'); % Crear objeto 
% %archivo avi
% aviobj.FrameRate = 10; % El video sera a 10 fps
% open(aviobj)
% 
% start(video)
% 
% while (video.FramesAcquired<300) % Video de 10s
%     I=getdata(video,1); % captura un frame guardado en memoria.
%     imshow(I);
%     writeVideo(aviobj,I);
% end
% stop(video)
% close(aviobj);

%%LEEMOS EL VIDEO PARA PODER SELECCIONAR LOS FRAMES QUE DESEAMOS DEL VIDEO
video1 = VideoReader('VideoSeguimientoRojo.avi');
contador = 0;

while(video1.hasFrame)
   I=readFrame(video1);
   contador = contador +1
   imshow(I);    
   pause
end
stop(video1);

%PASAMOS A GUARDAR LAS IMÁGENES DE LOS FRAMES PARA LA CALIBRACIÓN
% 48(mano vacia), 70(mano fondo), 99(color centro), 200(color fondo), 
% 123(color izq), 151(color der), 175(color centro cerca), 217(color 
% fondo izq), 244(color fondo der abajo), 260(color fondo der arriba), 292
% (color fondo izq abajo)
numeros = [48,70,99,123,151,175,200,217,244,260,292];
ImagenesEntrenamiento_Calibracion = I;

for i=1:length(numeros)
    I = read(video1,numeros(i));
    ImagenesEntrenamiento_Calibracion(:,:,:,i)=I;
end
save ImagenesEntrenamiento_Calibracion;

%Para comprobar que hemos metido bien todas las imágenes
for i=1:size(ImagenesEntrenamiento_Calibracion,4)
    imshow(ImagenesEntrenamiento_Calibracion(:,:,:,i))
    pause
end

