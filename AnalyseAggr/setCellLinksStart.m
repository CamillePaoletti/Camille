clear mother
clear daughter

df=[segmentation.tcells1(1,:).detectionFrame];
numel=find(df==1);
tcells=[segmentation.tcells1(numel)];
mother=[tcells.mother];
numel=find(mother);
mother=mother(numel);
[~,~,i]=intersect(mother,[tcells.N]);
mother=[tcells(i).N];

for j=1:length(mother)
    daughter(j)=tcells(i(j)).daughterList(1);
end



numcat=horzcat(mother,daughter);
[~,~,i]=intersect(numcat,[tcells.N]);
N=[tcells.N];
N(i)=0;
numel=find(N);
addmother=N(numel);

mother=[mother,addmother];
daughter=[daughter,zeros(1,length(addmother))];

%disp(mother);
%disp(daughter);

% strm=[];
% strd=[];
% 
% for j=1:length(mother)
%     strm=[strm,' ',num2str(mother(j))];
%     strd=[strd,' ',num2str(daughter(j))];
% end

segmentation.pedigree.firstMCell=mother;
for j=1:length(mother)
    if daughter(j)
        segmentation.pedigree.firstCells{j}=num2str(daughter(j));
    else
        segmentation.pedigree.firstCells{j}='';
    end
end

hsFrame=42;


mother=[];
daughter=[];
tcells=segmentation.tcells1;
N=[tcells.N];
numel=find(N);
tcells=tcells(numel);
df=[tcells.detectionFrame];
numel=find(df<(hsFrame+2));
tcells=tcells(numel);
for j=1:length(tcells)
    budTime_temp=tcells(j).budTimes;
   if sum(budTime_temp<(hsFrame+2))%alors c'est une mère
       budTime_temp=budTime_temp(budTime_temp<(hsFrame+2));%sous tableau avec les bud times <hsFrame+2
       mother=[mother,tcells(j).N];
       [~,ind,~]=intersect([tcells.N],tcells(j).daughterList(length(budTime_temp)));
       daughter=[daughter,tcells(ind).N];
   else
       disp(num2str(tcells(j).N));
   end
end

mother
daughter