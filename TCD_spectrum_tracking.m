clear
clc

load spectrum_1.mat
Sdat = flipud(spectrum_1);


N = size(Sdat,2);
time = 3*(1:N)'/592;
frequency = linspace(-131,2481,256);
figure(1)
imagesc(time,frequency,Sdat)

%% enhancement
Sdat_hist_1 = histeq(min(Sdat,15)/15);
Sdat_hist = Sdat_hist_1;
Sdat_hist(Sdat_hist>0.7) = 1;
Sdat_hist(Sdat_hist<0.5) = 0;

%% find envelope
envelope = zeros(N,1);
for m = 1:N
    % fit curve with step function
    x = stepfit(Sdat_hist(:,m), 1, 0, 70);
    envelope(m,1) =  x;
end
k1 = (-131-2481)/-256;
b1 = -131;
envelope = k1*envelope + b1;

figure(2)
imagesc(time,frequency,Sdat_hist_1)
% colormap turbo
hold on
% figure(3)
plot(time,envelope, 'r', 'LineWidth', 2)


%% find max and min peaks 
Nslide = 400; 
Nwindow = 590;

smooth_enve = smooth(envelope,5);
for m = 1:Nslide:length(envelope)-Nwindow 
    m,
    sorted = sort(smooth_enve(m:m+Nwindow-1));
    up_limit = mean(sorted(end-5:end));
    down_limit = mean(sorted(1:5));
    
    [pks_EDV, locs_EDV] = findpeaks(envelope(m:m+Nwindow-1),'MinPeakHeight',up_limit-20,'MinPeakDistance',120); 
    [pks_ESV, locs_ESV] = findpeaks(-envelope(m:m+Nwindow-1),'MinPeakHeight',-down_limit-20,'MinPeakDistance',120);
    
    abs_x_EDV = locs_EDV + m - 1;
    abs_x_ESV = locs_ESV + m - 1;
    
    if m == 1
        x_PSV = abs_x_EDV;
        x_EDV = abs_x_ESV;
    end

    if m > 1
        ind = find(abs_x_EDV == x_PSV(end));
        if ind > 0
            abs_x_EDV(ind) = [];
        end
        x_PSV = [x_PSV; abs_x_EDV];
        
        ind = find(abs_x_ESV == x_EDV(end));
        if ind > 0
            abs_x_ESV(ind) = [];
        end
        x_EDV = [x_EDV; abs_x_ESV];
    end
end

y_PSV = envelope(x_PSV) * 154000/(2*2e6);
y_EDV = envelope(x_EDV) * 154000/(2*2e6);

figure(5)
plot(envelope* 154000/(2*2e6))
hold on
plot(x_PSV, y_PSV, '*r')
plot(x_EDV, y_EDV, '*k')
