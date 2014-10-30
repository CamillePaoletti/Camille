function []=frequencyAnalysis(image,j)

s=size(image);


Fs = 1/600;                    % Sampling frequency
L = s(2);                      % Length of signal
NFFT = 2^nextpow2(L); % Next power of 2 from length of signal


for i=1:s(1)
y=image(i,:);
Yt(i,:) = fft(y,NFFT)/L;

% if i==1%i==1
%     f = Fs/2*linspace(0,1,NFFT/2+1);
%     figure;
% plot(f,2*abs(Yt(1,1:NFFT/2+1))) 
% title(['Single-Sided Amplitude Spectrum of kymograph 1 for position ',num2str(j)])
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% end
% if i==100%i==1
%     f = Fs/2*linspace(0,1,NFFT/2+1);
%     figure;
% plot(f,2*abs(Yt(100,1:NFFT/2+1))) 
% title(['Single-Sided Amplitude Spectrum of kymograph 100 for position ',num2str(j)])
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% end
end

Y=mean(Yt,1);
f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
figure;
plot(f,2*abs(Y(1:NFFT/2+1))) 
title(['Mean Single-Sided Amplitude Spectrum of kymograph for position ',num2str(j)])
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

end