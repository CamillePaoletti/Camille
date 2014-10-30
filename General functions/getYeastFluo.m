function Fluo=getYeastFluo(numel,Obj,channel)
%Camille Paoletti - 09/2011
%get fluo (channel) of a single cell (Obj=tcells.Obj(cellNumber,:) - one line Obj) over time for frames in numel

Fluo=zeros(length(numel),1);
for i=1:length(numel);
   Fluo(i,1)=Obj(1,numel(i)).fluoMean(channel);
end

end