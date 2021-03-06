function computeProbapValues(proba)

serie=3

N1=transpose(proba(serie,:).*1000)

N2=[1000; 1000; 1000; 1000]-N1

o=[N1,N2]


for i=1:3
    for j=i+1:4
        disp([num2str(i),' - ', num2str(j)]);
        crop=vertcat(o(i,:),o(j,:))
        [hNull pValue X2] = ChiSquareTest(crop, 0.05)  
    end
end



bud=3

N1=proba(:,bud).*1000

N2=[1000; 1000; 1000]-N1

o=[N1,N2]


for i=1:2
    for j=i+1:3
        disp([num2str(i),' - ', num2str(j)]);
        crop=vertcat(o(i,:),o(j,:))
        [hNull pValue X2] = ChiSquareTest(crop, 0.05)  
    end
end


