function checkSinglePos(path,file,position,initFrame,hsFrame,lastFrame,ALPHA)
%Camille Paoletti - 04/2014

%check aggregates number and ratio evolution

%extractio of values of number and volume evolution
%[concat,nNum,area,volume]=extract_values(path,file,position,initFrame, hsFrame, lastFrame,'hsCells');
%plot number/radius/intensity and growth rate evolution
%[h_growth,h_figure,cbar_axes,h_gr]=compareMeanFociNumberBatch(initFrame, hsFrame, lastFrame,concat,nNum,area,volume,1);


meanLen=5;
[Data,~,~,~,meanLen]=computeRatioBudMotherFigure(path,file,position,hsFrame,lastFrame,meanLen);
%Data{2,1}
[Data_all]=computeRatioBudMotherAllDataPoints(path,file,position,hsFrame,lastFrame);
%Data_all{2,1}

[c,h_fig1,~,~]=alpha(Data_all,ALPHA,1);
plotCorr(Data_all);

end