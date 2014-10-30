filepath='L:\common\matlab\Camille\figures\120420_multiStacks';
list=dir([filepath,'\*.fig']);
figure;
for i=1:length(dir)
    output = open([filepath,'\',list(i,1).name]);
    h=gcf;
    [pathstr, name, ext, versn] = fileparts(list(i,1).name);
    saveas(h,[filepath,'\',name],'pdf'); 
end
