function [ R ,project ] = findFolderPath( filePath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%filePath='/Users/camillepaoletti/Documents/Lab/Movies/120823_aggr_formationAtDifferentTemp/';

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
    makeAggrMovies(str);
end
    
end

