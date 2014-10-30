function makeMultiTimeLapseOverlayMovies(pos)

global timeLapse;
global position;
global overlayList;
global overlay;
global movieMakerGUIHandles;

fprintf('\n Now I m building overlay movies... Be patient.... \n');

overlayList=[];
overlay=[];
movieMakerGUI();

load(strcat(overlay.path,overlay.timeLapseName,'-retreat/','overlaySettings.mat'));

pha=overlaySettings.phaseIndex;
%overlay.endFrame=timeLapse.currentFrame;

overlay.useRetreat=1;
overlay.showScale=1;
if (numel(overlay.seqFrame)==0)
overlay.showSequence=0;
else
 overlay.showSequence=1;  
%overlay.showSequence=0;  
end

strname=overlay.timeLapseName;            
%overlay.path= strcat(overlay.path,strname,'-retreat/');


for i=pos
   overlay.position=i;
   %overlay.startFrame=200;
   overlay.endFrame=timeLapse.position.list(i).maxUsableFrame;
   %overlay.endFrame=
   
   if (numel(timeLapse.list)~=numel(position.list(i).timeLapse.list))
       localTimeLapse=position.list(i).timeLapse;
   else
       localTimeLapse=timeLapse;
   end
   
   
   for j=1:numel(localTimeLapse.list) 
   if (j~=pha)     
   mine=min(overlaySettings.fluo(i,j,:,1));
   maxe=max(overlaySettings.fluo(i,j,:,2));
   %overlay.channel(j).ratio=overlay.availableChannel(j).ratio;
   overlay.channel(j).ratio=0.8;
   else
   mine=min(overlaySettings.phase(i,:,1));
   maxe=max(overlaySettings.phase(i,:,2));
   overlay.channel(j).ratio=0.8;
   end
   
   %if (j==3)
   %    overlay.channel(j).ratio=0;
   %end
   
   overlay.channel(j).name=overlay.availableChannel(j).name;
   overlay.channel(j).rgb=overlay.availableChannel(j).rgb;
   overlay.channel(j).low=round(mine);
   overlay.channel(j).high=round(maxe);
   
   overlay.channel(j).index=j;
   overlay.channel(j).videoResolution=overlay.availableChannel(j).videoResolution;
   overlay.channel(j).cutBackground=0; 
   overlay.channel(j).biasRenorm=0;
   overlay.channel(j).timeRenorm=0;
   
   str3=overlay.pathList.channels(i,overlay.channel(j).index);
   strname=overlay.timeLapseName;            
   str3= strcat(overlay.path,strname,'-retreat/',str3,overlay.pathList.names(i,overlay.channel(j).index),'-list.txt');
   overlay.channel(j).list=str3; 
   end
 %  updateChannelDisplay(handles,j);
   
 %str=overlay.pathList.position(i);
 %str=str(1:numel(str)-1);
b=strcat(overlay.path,strname,'-retreat/',strname,'-pos',int2str(i),'.avi');
overlay.movieName=b;

n=numel(overlayList);
if (n~=0)
overlayList(n+1)=overlay;
else
 overlayList=overlay;   
end
displaySelectedOverlay(movieMakerGUIHandles, n+1);
pause(0.2);

makeSingleMovie(overlay);    
end

save(strcat(overlay.path,strname,'-retreat/','overlayList.mat'), 'overlayList');