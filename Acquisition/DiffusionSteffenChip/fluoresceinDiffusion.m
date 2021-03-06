function [realTime,c,I]=fluoresceinDiffusion(n,p,bleach,filepath)
%Camille Paoletti - 05/2011
%monitor diffusion
%ex: [realTime,c,I]=fluoresceinDiffusion(60,5,60,'L:\common\movies\Camille\2011\frame');

global andorCam;
global serialObj;
global fileList;
global XGGUI;

%andorCam.mode(2).binning=1;

setScopeMethod(serialObj.micro,3);
pause(1);

ti=clock;
realTime=zeros(n+1,1);
c=zeros(1,1);
openFluoShutter(serialObj.micro);
%fprintf(serialObj.precisexcite,'QN');

%initial snap
setLEDIntensity(2,100);
pause(0.1);
snap=andorSnapImage(andorCam.mode(2));
filename=strcat(filepath,'_fluo_000.jpg');
imwrite(snap,filename,'BitDepth',16);
dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);

%fluorescein bleach%out=pulseLED(2,1000*i)
setLEDIntensity(2,100);
toggleLED(2,1);
b=clock;
while etime(clock,b)<bleach;
    pause(0.01);
end
toggleLED(2,0);
c=etime(clock,b);
t=clock;
realTime(1)=etime(t,ti);

I=uint16(zeros(n,500,500));

setLEDIntensity(2,100);
pause(0.1);
for i=1:n
      
% snap=andorSnapImage(andorCam.mode(2));
%     if i<10;
%         a=strcat('00',num2str(i));
%     elseif 10<=i && i<100;
%         a=strcat('0',num2str(i));
%     else
%         a=num2str(i);
%     end
% filename=strcat(filepath,'_fluo_',a,'.jpg')
% imwrite(snap,filename,'BitDepth',16);
    %dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);
  
    I(i,:,:)=andorSnapImage(andorCam.mode(2));
    %i
    t=clock;
    realTime(i+1)=etime(t,ti);
    
    pause(p);
end

closeFluoShutter(serialObj.micro);

end


