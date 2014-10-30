function [realTime]=fluorescein(n,Dt,T,tau,filepath)
%Camille Paoletti - 05/2011
%drive fluorescein pulses and monitor diffusion

global andorCam;
global serialObj;
global fileList;
global XGGUI;

andorCam.mode(2).binning=1;

%periods definition
nDown=fix((T-tau)/Dt);%number of frames for the duration T-tau sec.
nUp=fix(tau/Dt);%number of frames for the duration tau sec.
nCycle=fix(n/(nDown+nUp));%number of total cycles ( valve 1 for T-tau sec. // valve 2 for tau sec.)

%valves : function describing the valve used over time
valves=ones(n,1);
for i=1:nCycle
    valves(i*nDown+(i-1)*nUp:i*nDown+i*nUp,1)=2;
end

%snap phase contrast
setCurrentPrism(serialObj.micro,3)
pause(1);

setScopeMethod(serialObj.micro,2) % ph
pause(1);
snap=andorSnapImage(andorCam.mode(1));
filename=strcat(filepath,'_phase.jpg');

imwrite(snap,filename,'BitDepth',16);
pause(1);

%snap fluo + valves' driving
setScopeMethod(serialObj.micro,3);
pause(1);
ti=clock;

openFluoShutter(serialObj.micro);

for i=1:n
    setElectroValve(serialObj.valves,valves(i));
    snap=andorSnapImage(andorCam.mode(2));
   if i<10
        a=strcat('00',num2str(i));
    elseif 10<=i && i<100;
        a=strcat('0',num2str(i));
    else
        a=num2str(i);
    end
    filename=strcat(filepath,'_fluo',a);
    imwrite(snap,filename,'BitDepth',16);
    
    dumpImageToFileList(XGGUI,snap,numel(fileList),'',1);
    
    t=clock;
    realTime=etime(ti,t);
    pause(Dt); 
end

closeFluoShutter(serialObj.micro);

end


