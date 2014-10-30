for i=1:8
    str=strcat('fig',num2str(i),'.png');
    print(i,'-dpng','-r200',str);
end