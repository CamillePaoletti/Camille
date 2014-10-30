function []=makeMultiAviMovieFromUint16Jpg()

global timeLapse;

deltaT=timeLapse.interval/60;

fprintf('building movies while you are having a nap... \n');

for j=1:numel(timeLapse.position.list)%j: position
    for k=1:numel(timeLapse.list)%k: channel
        [pathstr, name, ext, versn] = fileparts(fileparts(cell2mat(timeLapse.pathList.channels(j,k))));
        if timeLapse.list(1,k).enableZStacks
            filename=strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection');
            filesave=strcat(timeLapse.realPath,name,'-projection');
            lowLevel=500;
            highLevel=1500;
        else
            filename=strcat(timeLapse.realPath,cell2mat(timeLapse.pathList.channels(j,k)));
            filesave=strcat(timeLapse.realPath,name);
            lowLevel=800;%600
            highLevel=2500;%1000
        end
        binning=timeLapse.list(1,k).binning;
        makeAviMovieFromUint16Jpg(filename,filesave,deltaT,lowLevel,highLevel,binning);
        fprintf('.');
    end
end

fprintf('\n time to wake up! \n');
end