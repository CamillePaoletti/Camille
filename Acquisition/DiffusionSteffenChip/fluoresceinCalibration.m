function [realTime,c,d]=fluoresceinCalibration(n,p,filepath)
%Camille Paoletti - 05/2011
%monitor bleaching
%ex: [realTime,c,d]=fluoresceinCalibration(3,5,'./110511/frame');

global andorCam;
global serialObj;
global fileList;
global XGGUI;

andorCam.mode(2).binning=1;

%snap phase contrast
% setCurrentPrism(serialObj.micro,3);
% pause(1);
% 
% setScopeMethod(serialObj.micro,2) % ph
% pause(1);
% snap=andorSnapImage(andorCam.mode(1));
% filename=strcat(filepath,'_phase.jpg');
% 
% imwrite(snap,filename,'BitDepth',16);
% pause(1);
% 
% 
% %snap fluo + illumination +snap fluo
 setScopeMethod(serialObj.micro,3);
 pause(1);


ti=clock;

realTime=zeros(n,1);
c=zeros(n,1);
d=zeros(n,1);realTime=zeros(n,1);
openFluoShutter(serialObj.micro);
%fprintf(serialObj.precisexcite,'QN');

for i=1:n
    
    pause(p);
    snap=andorSnapImage(andorCam.mode(2));
    if i<10;
        a=strcat('00',num2str(i));
    elseif 10<=i && i<100;
        a=strcat('0',num2str(i));
    else
        a=num2str(i);
    end
    filename=strcat(filepath,'_fluo_',a,'_1.jpg')
    imwrite(snap,filename,'BitDepth',16);
    dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);
   
   
    
    pause(0.2)
    %out=pulseLED(2,1000*i)
    toggleLED(2,1);
     b=clock;
    while etime(clock,b)<i;
        pause(0.01);
    end
    toggleLED(2,0);
    c(i)=etime(clock,b)
    pause(0.1);
    
    snap=andorSnapImage(andorCam.mode(2));
    filename=strcat(filepath,'_fluo_',a,'_2.jpg')
    imwrite(snap,filename,'BitDepth',16);
    dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);
    d(i)=etime(clock,b);
    
    t=clock;
    realTime(i)=etime(t,ti);
end

closeFluoShutter(serialObj.micro);

end


