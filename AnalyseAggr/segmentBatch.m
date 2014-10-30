function [ R ,project ] = segmentBatch( filePath,level)
%Camille Paoletti - 08/2012
%segment cells, foci and budnecks for every movies, every positions in
%filepath

%filePath='/Users/camillepaoletti/Documents/Lab/Movies/120823_aggr_formationAtDifferentTemp/';
%level=[0.025,0.03,0.03,0.03,0.04,0.035,0.035];

%filepath='/Users/camillepaoletti/Documents/Lab/Movies/test/';


r = dir(filePath);
c=1;
for i =1:numel(r)
    TF=strfind(r(i,1).name, '.');  
    if numel(TF)>0
    else
        R(c,1)=r(i,1);
        c=c+1;
    end
end

project=cell(numel(R),1);

for i=1:numel(R)
    project{i,1}=dir(strcat(filePath,R(i,1).name,'/*-project*.mat'));
    str=strcat(filePath,R(i,1).name,'/',project{i,1}(1,1).name);
    if nargin ==1
        makeSegmentation(str);
    else
        makeSegmentation(str,level(1,i));
    end
end
    
end