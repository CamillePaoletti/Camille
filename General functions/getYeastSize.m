function Size=getYeastSize(numel,Obj)
%Camille Paoletti - 09/2011
%get area of a single cell (Obj=tcells.Obj(cellNumber,:) - one line Obj) over time for frames in numel

Size=zeros(length(numel),1);
for i=1:length(numel);
   Size(i,1)=Obj(1,numel(i)).area;
end

end