function [ N , m_aggr , m_hexamer] = initialAggregatesNumber(r,R)
%Camille Paoletti - 11/2012
%compute initial number of hexamer of radius r to get a final aggregate of
%radius R

mass = @(x) (x/0.0515)^(1/0.392) ;
radius = @(x) 0.0515*x^.392 ;

m_aggr = mass(R) ;
m_hexamer = mass(r) ;

N = m_aggr/m_hexamer ;

end

