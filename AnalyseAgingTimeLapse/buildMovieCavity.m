function buildMovieCavity(foldername,filename,pos,numel,cavities)
%Camille Paoletti - 11/2014
%build movie for tcells number indicated in numel
global segmentation
global timeLapse

n=length(numel);

for i=1:n
    tcell=segmentation.tcells1(1,numel(i));
    start=tcell.detectionFrame-10;
    last=tcell.lastFrame+10;
    exportMontage(foldername, filename, [pos], {'1 2 3 0'}, [start:last], [], segmentation,'cavity',cavities(i));
end


end