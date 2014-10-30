function [] = analyseDivisionsBatch(readOut,highlightCell,highlightCellCycle)
%Camille Paoletti - 12/2011
%run singleAnalyseDivisions for different read out to choose from
%   -area
%   -cellCycle
%   -cellCyclePhase
%   -fluo
%   -growthRate
%ex: analyseDivisionsBatch({'cellCycle','cellCyclePhase','fluo'},[],13)

%highlightCell=[9 25 26 28 29 31 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 55 53 52 51]; % select cells that should be highlitghted
%highlightCellCycle: highlight if cellcycle duration is larger than number (cell cycle in minutes / 10)

%definition of properties
fluo=[0;0;0;1;0];%fluo=1; % to plot fluo or area values
cellcyclephase=[0;0;1;0;0];%to plot G1 vs S/G2/M
G1color=[2;2;1;2;2];
G2color=[2;2;2;2;2];

ti=10;

spacing=3;

for A=1:length(readOut)
    switch readOut{A}
        case 'area'
            mode=1;
        case 'cellCycle'
            mode=2;
        case 'cellCyclePhase'
            mode=3;
        case 'fluo'
            mode=4;
        case 'growthRate'
            mode=5;
        otherwise
            mode=0;
    end
    fprintf('run=%d; read out=%s; mode=%d\n',double(A),readOut{A},mode);
    singleAnalyzeDivisions(fluo(mode),cellcyclephase(mode),highlightCell,highlightCellCycle,G1color(mode),G2color(mode),ti,spacing);
end






