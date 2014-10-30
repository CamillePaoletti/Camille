function [realTime,diffTime,M]=fluoresceinDiffusion2(duration,periode,bleach,filepath)
%Camille Paoletti - 05/2011
%monitor diffusion
%ex: [realTime,c,I]=fluoresceinDiffusion2(60,5,60,'L:\common\movies\Camille\2011\frame');

global andorCam;
global serialObj;
global fileList;
global XGGUI;

%andorCam.mode(2).binning=1;

setScopeMethod(serialObj.micro,3);
pause(1);

openFluoShutter(serialObj.micro);
%fprintf(serialObj.precisexcite,'QN');

%initial snap
setLEDIntensity(2,50);
pause(0.1);
snap=andorSnapImage(andorCam.mode(2));
filename=strcat(filepath,'_fluo_initialSnap.jpg');
imwrite(snap,filename,'BitDepth',16);
dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);

%fluorescein bleach%out=pulseLED(2,1000*i)
setLEDIntensity(2,100);
fprintf('start bleaching \n');
ti=clock;
toggleLED(2,1);
b=clock;
while etime(clock,b)<bleach;
    pause(0.01);
end
toggleLED(2,0);
t=clock;
r=etime(t,ti);
fprintf('stop bleaching \n');

setLEDIntensity(2,50);
pause(0.1);
fprintf('start acquisition \n');

[M,realTime,diffTime]=continuousAcquisition(duration,periode,0);
realTime=[t;realTime];
diffTime=vertcat(r,diffTime);

closeFluoShutter(serialObj.micro);

fprintf('saving data to disk \n');
save(strcat(filepath,'.mat'), 'M', 'realTime','diffTime');
fprintf('data saved\n');

end


