function [fociTot]=mergeFoci(foci1,foci2)
%Camille Paoletti - 06/2013
%merge two foci cells in one big cell for analysis by plotMSDposter

s1=size(foci1);
s2=size(foci2);
n1=s1(1);

fociTot=foci1;

for i=1:s2(1)
    for j=1:s2(2)
        fociTot{i+n1,j}=foci2{i,j};
    end
end



end