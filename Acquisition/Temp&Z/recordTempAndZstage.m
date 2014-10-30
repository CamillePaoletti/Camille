function [data] = recordTempAndZstage(periode, Tinitial,Tfinal, deltaT,deltaTime, filepath )
% function [data] = recordTempAndZstage( duration, periode, objT, stageT, filepath )
%Camille Paoletti - 03/2012
%set temperature changes & record temperature and stage deviation
%objT(i,1)=ith temperaure from time=objT(i,2) to time=objT(i+1,2)
%stageT(i,1)=idem for stage temperature

%data=recordTempAndZstage(0.1,30,50,1,180,filename);
% data=recordTempAndZstage(0.1,30,42,1,360,'L:\common\movies\Camille\2012\2
% 01205\120524_calibrationTemp\Observer&OldStage_temp_0dot1');
%data=recordTempAndZstage(3600,0.1,[30,3;31,6;32,9;33,12;34,15;35,18;36,21;37,24;38,27;39,30;40,33;41,36;42,39;43,42;44,45;45,48;46,51;47,54;48,57;49,60;50,63;30,67],[30,3;31,6;32,9;33,12;34,15;35,18;36,21;37,24;38,27;39,30;40,33;41,36;42,39;43,42;44,45;45,48;46,51;47,54;48,57;49,60;50,63;30,67], 'L:\common\movies\Camille\2012\201205\120524_calibrationTempAxiovert&OldStage\temp_3600_0.1');

global serialObj;
global andorCam
global data;
%global andorCam;

%acquisition mode:
mode=1;
display=0;
imAcquisition=0;

duration=(Tfinal-Tinitial)/deltaT*deltaTime+9;

cc=0;
for i=[Tinitial:deltaT:Tfinal]
    objT(cc+1,1)=Tinitial+cc*deltaT;
    objT(cc+1,2)=(cc+1)*deltaTime;
    cc=cc+1;
end



objT(cc+1,1)=30;
objT(cc+1,2)=(cc+1)*deltaTime+10;

stageT=objT;

%objT(:,2)=objT(:,2).*60;
%stageT(:,2)=stageT(:,2).*60;

%variables
n=floor(duration/periode);
if imAcquisition
    M=zeros(1000,1000,n+1);
end
data.diffTime=zeros(n,1);
data.stageTempAlarm=zeros(n,1);
data.stageTempCurrent=zeros(n,1);
data.stageTemp=zeros(n,1);
data.objectiveTempAlarm=zeros(n,1);
data.objectiveTempCurrent=zeros(n,1);
data.objectiveTemp=zeros(n,1);
data.realTime=[];
data.duration=duration;
data.periode=periode;
data.objT=objT;
data.stageT=stageT;
data.z=zeros(n,1);



if display
    h=figure;
    pause(0.2);
end

count=1;
stageCount=1;
objCount=1;

setTemperature(serialObj.temperature1,stageT(stageCount,1));
setTemperature(serialObj.temperature2,objT(objCount,1));


t=clock;
while etime(clock,t)< duration
    fprintf('resume \n');
    pause(1.0);
    
    if etime(clock,t)>stageT(stageCount,2)
        setTemperature(serialObj.temperature1,stageT(stageCount+1,1));
        fprintf('Stage temperature set to %d \n',stageT(stageCount+1,1));
        stageCount=stageCount+1;
    end
    if etime(clock,t)>objT(objCount,2)
        setTemperature(serialObj.temperature2,objT(objCount+1,1));
        fprintf('Objective temperature set to %d \n',objT(objCount+1,1));
        objCount=objCount+1;
    end
    
    temp=clock;
    
    
    data.diffTime(count)=etime(temp,t);
    data.realTime=[data.realTime;temp];
    
    data.stageTempAlarm(count)=getCurrentAlarm(serialObj.temperature1);
    data.stageTempCurrent(count)=getCurrentTemperature(serialObj.temperature1);
    data.stageTemp(count)=getTemperature(serialObj.temperature1);
    
    data.objectiveTempAlarm(count)=getCurrentAlarm(serialObj.temperature2);
    data.objectiveTempCurrent(count)=getCurrentTemperature(serialObj.temperature2);
    data.objectiveTemp(count)=getTemperature(serialObj.temperature2);
    
    if imAcquisition
        M(:,:,count)=andorSnapImage(andorCam.mode(mode));
        if display
            figure(h); imshow(snap,[]);
        end
    end
    
    data.z(count,1)=get_z(serialObj.micro);
    fprintf('pause \n');
    pause(periode-1);
    count=count+1;
    
    
end

setTemperature(serialObj.temperature1,30);
setTemperature(serialObj.temperature2,30);

fprintf('saving data to disk \n');
if imAcquisition
save(strcat(filepath,'_snap.mat'), 'M');
end
save(strcat(filepath,'_data.mat'), 'data');
fprintf('data saved\n');

end

