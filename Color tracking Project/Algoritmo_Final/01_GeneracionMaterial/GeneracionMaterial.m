clear
close all
clc

video=videoinput('winvideo',1,'YUY2_320x240'); 
video.ReturnedColorSpace = 'rgb'; %Frames de intensidad
video.TriggerRepeat=inf; % disparos continuados
video.FrameGrabInterval=2; %Cogemos 2 de cada 3 frames
set(video, 'LoggingMode', 'memory')

aviobj = VideoWriter('VideoSeguimientoAzul.avi', 'Uncompressed AVI'); % Crear objeto 
%archivo avi
aviobj.FrameRate = 10; % El video sera a 10 fps
open(aviobj)

start(video)

while (video.FramesAcquired<300) % Video de 30s
    I=getdata(video,1); % captura un frame guardado en memoria.
    imshow(I);
    writeVideo(aviobj,I);
end

stop(video)
close(aviobj)

preview(video)
objVideo = getsnapshot(video);

Imagenes(:,:,:,1) = objVideo;
Imagenes(:,:,:,2) = objVideo;
Imagenes(:,:,:,3) = objVideo;
Imagenes(:,:,:,4) = objVideo;
Imagenes(:,:,:,5) = objVideo;
Imagenes(:,:,:,6) = objVideo;
Imagenes(:,:,:,7) = objVideo;
Imagenes(:,:,:,8) = objVideo;
Imagenes(:,:,:,9) = objVideo;
Imagenes(:,:,:,10) = objVideo;
Imagenes(:,:,:,11) = objVideo;

save ImagenesEntrenamiento_Calibracion Imagenes

for i=1:size(Imagenes,4)
    
    imshow(Imagenes(:,:,:,i))
    pause
end


