function [realTime,I]=acquisitionBrightFieldDiffusion(n,p,filepath)
%Camille Paoletti - 05/2011
%monitor diffusion
%ex: [realTime,I]=brightFieldDiffusion(3,5,'L:\common\movies\Camille\2011\frame');

global andorCam;
global serialObj;
global fileList;
global XGGUI;

andorCam.mode(1).binning=1;

setScopeMethod(serialObj.micro,1);
pause(1);

ti=clock;
realTime=zeros(n+1,1);
c=zeros(1,1);
openTransShutter(serialObj.micro);
%fprintf(serialObj.precisexcite,'QN');

%initial snap
snap=andorSnapImage(andorCam.mode(1));
filename=strcat(filepath,'_BF_000.jpg');
imwrite(snap,filename,'BitDepth',16);
dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);

%fluorescein bleach%out=pulseLED(2,1000*i)
t=clock;
realTime(1)=etime(t,ti);

I=uint16(zeros(n,1000,1000));

for i=1:n
      
%    snap=andorSnapImage(andorCam.mode(2));
%     if i<10;
%         a=strcat('00',num2str(i));
%     elseif 10<=i && i<100;
%         a=strcat('0',num2str(i));
%     else
%         a=num2str(i);
%     end
%     filename=strcat(filepath,'_fluo_',a,'.jpg')
%     imwrite(snap,filename,'BitDepth',16);
    %dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);
  
    I(i,:,:)=andorSnapImage(andorCam.mode(1));
    i
    t=clock;
    realTime(i+1)=etime(t,ti);
    
    pause(p);
end

closeTransShutter(serialObj.micro);

str=strcat(filepath,'.mat');
save(str,'I', 'realTime');

end