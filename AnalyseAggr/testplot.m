function testplot(n,frame)
if n==0
    for i=1:10
        position2=ComputePosition(i,[50:1:89]);
        x1=position2.foc.ox;
        y1=position2.foc.oy;
        a1=position2.foc.area;
        B=[x1;y1];
        x2=position2.nuc.ox;
        y2=position2.nuc.oy;
        a2=position2.nuc.area;
        A=[x2;y2];
        %figure;plot(xcorr2(A,B));
        %hold on; text(2,-2000,num2str(position2.N)); hold off;
        figure; plot(sqrt((x1-x2).^2+(y1-y2).^2)); ylim([0 60]);
        hold on;
        text(5,5,['cell n° ',num2str(position2.N)]);
        text(5,3,['nucl n° ',num2str(position2.nuc.n(1))]);
        text(5,1,['foc n° ',num2str(position2.foc.n(1))]);
        plot(sqrt(a1/pi)+sqrt(a2/pi),'r-');
        hold off;
        computeMSD(x1,y1,1);
        
    end
else
    i=n;
    position2=ComputePosition(i,frame);
        x1=position2.foc.ox;
        y1=position2.foc.oy;
        a1=position2.foc.area;
        B=[x1;y1];
        x2=position2.nuc.ox;
        y2=position2.nuc.oy;
        a2=position2.nuc.area;
        A=[x2;y2];
        h_fig=computeMSD(x1,y1,1);
        h_fig=computeMSD(x1-x2,y1-y2,1);
        figure;plot(x1,x2,'b+');
        hold on ; plot(y1,y2,'g+');
        corrcoef(x1,x2)
        corrcoef(y1,y2)
        %figure;plot(xcorr2(A,B));
        figure;
        subplot(2,2,1);
        plot(xcorr(x1,x2));%ylim([-3000;3000]);
        hold on;
        plot(xcorr(y1,y2),'g-');
        hold off;
        %hold on; text(2,-2000,num2str(position2.N)); hold off;
        sr=sqrt(a1/pi)+sqrt(a2/pi);%r_nuc+r_foc
        dis=sqrt((x1-x2).^2+(y1-y2).^2);%distance between the center of the nucleus and the center of the focus
        %figure;
        subplot(2,2,3);plot(dis-sr); ylim([-20 40]);
        hold on;
        line([0 40],[0 0],'Color','r');
        text(1,10,['cell n° ',num2str(position2.N)]);
        text(1,8,['nucl n° ',num2str(position2.nuc.n(1))]);
        text(1,6,['foc n° ',num2str(position2.foc.n(1))]);
        xlabel('time (frame');
        ylabel('(distance nuc-foc) - (sum theoritical radii) (pix)');
        hold off;
        %figure;
        subplot(2,2,4); plot(dis); ylim([0 60]);
        hold on;
        xlabel('time (frame');
        ylabel('distance nuc-foc (pix)');
        plot(sr,'r-');
        text(5,5,['cell n° ',num2str(position2.N)]);
        text(5,3,['nucl n° ',num2str(position2.nuc.n(1))]);
        text(5,1,['foc n° ',num2str(position2.foc.n(1))]);
        hold off;
        
        
end

