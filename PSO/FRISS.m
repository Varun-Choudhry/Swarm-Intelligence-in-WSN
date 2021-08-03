
% friss(Gt, Gr, freq, Txp[1,2], Rxp[1,2])
%
% Gt -> Transmitting Antenna Gain
% Gr -> Receiver antenna gain
% Freq -> frequency in MHz
% Txp[x,y] -> Position vector of the TRANSMITTER node
% Rxp[x,y] -> Position vector of the RECEIVER node


function [ATTdb] = friss(Gt, Gr, freq, Txp, Rxp)

c = (3.*10.^8);
lambda = c ./ (freq.*10.^6);

% calculate the distance between transmitter and receiver
dist = (((Rxp(1) - Txp(1)).^2) + ((Rxp(2) - Txp(2)).^2)).^0.5;

ATT = Gt.*Gr.*(lambda./(4.*pi.*dist)).^2;
ATTdb = 10.*log10(ATT);
end
