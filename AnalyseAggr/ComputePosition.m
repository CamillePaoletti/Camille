function position=ComputePosition(ncell,segmentedFrames)
%Camille Paoletti - 05/2014
%for cell ncell: compute position of nucleus and foci center in the cell
%referential

global segmentation;


foci=segmentation.foci;
nucleus=segmentation.nucleus;

tcells1=segmentation.tcells1(ncell);
N=tcells1.N;
detec=tcells1.detectionFrame;
if detec<segmentedFrames(1)
    start=segmentedFrames(1)-detec+1;
else
    start=1;
end
stop=segmentedFrames(end)-detec+1;

ox=[tcells1.Obj(1,start:stop).ox];
oy=[tcells1.Obj(1,start:stop).oy];

segmentedFrames=[max(detec,segmentedFrames(1)):1:segmentedFrames(end)];

c=0;
clear position;
position.N=N;
for i=segmentedFrames
    c=c+1;
    xc=tcells1.Obj(1,i-detec+1).x;
    yc=tcells1.Obj(1,i-detec+1).y;

    cc=0;
    position.nuc.ox(1,c)=NaN;
    position.nuc.oy(1,c)=NaN;
    position.nuc.area(1,c)=NaN;
    position.nuc.n(1,c)=NaN;
    position.foc.ox(1,c)=NaN;
    position.foc.oy(1,c)=NaN;
    position.foc.area(1,c)=NaN;
    position.foci.n(1,c)=NaN;
    
    for j=1:numel(nucleus(i,:)) % loop over all nucleus (numbered j) in frame i
        if nucleus(i,j).n~=0
            xn=nucleus(i,j).x;
            yn=nucleus(i,j).y;
            in=inpolygon(xn,yn,xc,yc);
            n=length(in);
            in=sort(in);
            in=in(1:round(n/2));
            if mean(in)>0 % nucleus is inside the cell
                cc=cc+1;
                if cc>1
                    disp(N);
                    disp(i);
                    position.nuc.ox=0;
                    position.nuc.oy=0;
                    position.nuc.area=0;
                    position.nuc.n=0;
                    position.foc.ox=0;
                    position.foc.oy=0;
                    position.foc.area=0;
                    position.foc.n=0;
                    return;
                end
                position.nuc.ox(1,c)=nucleus(i,j).ox;
                position.nuc.oy(1,c)=nucleus(i,j).oy;
                position.nuc.area(1,c)=nucleus(i,j).area;
                position.nuc.n(1,c)=nucleus(i,j).n;
            end
        end
    end
    
    cc=0;
    clear temp_pos;
    for j=1:numel(foci(i,:)) % loop over all foci (numbered j) in frame i
        if foci(i,j).n~=0
            xf=foci(i,j).x;
            yf=foci(i,j).y;
            in=inpolygon(xf,yf,xc,yc);
            n=length(in);
            in=sort(in);
            in=in(1:round(n/2));
            if mean(in)>0 % foci is inside the cell
                cc=cc+1;
                temp_pos.x(cc)=foci(i,j).ox;
                temp_pos.y(cc)=foci(i,j).oy;
                temp_pos.a(cc)=foci(i,j).area;
                temp_pos.n(cc)=foci(i,j).n;
            end
        end
    end
    if exist('temp_pos','var')
        [~,v] = max(temp_pos.a);
        position.foc.ox(1,c)=temp_pos.x(v);
        position.foc.oy(1,c)=temp_pos.y(v);
        position.foc.area(1,c)=temp_pos.a(v);
        position.foc.n(1,c)=temp_pos.n(v);
    end
    
end
position.nuc.ox=position.nuc.ox-ox;
position.nuc.oy=position.nuc.oy-oy;
position.foc.ox=position.foc.ox-ox;
position.foc.oy=position.foc.oy-oy;



end

