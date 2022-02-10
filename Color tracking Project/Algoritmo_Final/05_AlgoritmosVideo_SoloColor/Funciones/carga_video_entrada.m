function [numFrames, numFilasFrame, numColumnasFrame, FPS]  = carga_video_entrada(videoInput)
    FPS = videoInput.FrameRate;
    numFrames = videoInput.NumFrames;
    numFilasFrame = videoInput.Height;
    numColumnasFrame = videoInput.Width;
end