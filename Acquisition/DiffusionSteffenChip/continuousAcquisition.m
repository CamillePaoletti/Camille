function [M,realTime,diffTime]=continuousAcquisition(duration,periode,display)
global andorCam;

mo=1;

ROI=andorCam.mode(mo).ROI;
bin=andorCam.mode(mo).binning;
out=andorSetROI(ROI(1), ROI(2), ROI(3), ROI(4), bin);

s=[floor(ROI(3)/bin) floor(ROI(4)/bin) 3];

M=uint16(zeros(s));

n=floor(duration/periode);

count=1;

if display
    h=figure;
    pause(0.2);
end

ret=SetEMCCDGain(andorCam.mode(mo).gain);
ret=SetAcquisitionMode(5); %run til abort
ret=SetReadMode(4); % Image mode;

ret=SetExposureTime(andorCam.mode(mo).exposureTime);
[a b c d]=GetAcquisitionTimings;
pauseTime=max(periode,d);

trig=10;
[ret]=SetTriggerMode(trig);
[ret]=StartAcquisition;

andorCam.status='acquiring';

diffTime=zeros(n,1);
%realTime=zeros(n,1);
realTime=[];
toggleLED(2,1);
t=clock;
while strcmp(andorCam.status,'acquiring')
    
    if etime(clock,t)> duration
        ret=AbortAcquisition();
        toggleLED(2,0);
        andorCam.status='idle';
    end
    
    ret=SendSoftwareTrigger();
    
    [ret,data]=GetNewData(floor(ROI(3)/bin)*floor(ROI(4)/bin));
    temp=clock;
    diffTime(count)=etime(temp,t);
    realTime=[realTime;temp];
    
    snap = uint16(reshape(data,floor(ROI(3)/bin),floor(ROI(4)/bin)));
    snap=imadjust(snap);
    
    M(:,:,1,count) = fliplr(snap);
    M(:,:,2,count)=M(:,:,1,count);
    M(:,:,3,count)=M(:,:,1,count);
    
    if display
        figure(h); imshow(snap,[]);
    end
    
    pause(pauseTime);
    count=count+1;
end

mov=immovie(M);
implay(mov);
