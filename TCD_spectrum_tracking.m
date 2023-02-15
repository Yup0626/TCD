clear
clc

namelist = dir('TCD_long monitoring 0824/');

Sdat = [];
for m = 4:879
    m,

    % generate variable SdatAll
    load(['TCD_long monitoring 0824/', namelist(m).name]); 
    
    % connect all frames in the horizontal direction
    Sdat = [Sdat, SdatAll];
end

N = size(TCD_full4h,2);
time = (1:N)'/592;
frequency = 1:2481;
figure(1)
imagesc(time,frequency,flipud(TCD_full4h))

Sdat_hist_1 = histeq(min(TCD_full4h,20)/20);
Sdat_hist = Sdat_hist_1;
Sdat_hist(Sdat_hist>0.7) = 1;
Sdat_hist(Sdat_hist<0.5) = 0;

envelope = zeros(N,1);
for m = 1:N
    m,
    % fit curve with step function
    x = stepfit(Sdat_hist(:,m), 1, 0, 70);
    envelope(m,1) =  x;
end

envelope = max(min(envelope,200),0);
smooth_enve = smooth(envelope,5);
%% no loop
figure(2)
imagesc(Sdat_hist_1)
% colormap turbo
hold on
% figure(3)
plot(envelope, 'r', 'LineWidth', 2)
time = (1:N)'*3/592;



Nslide = 500; 
Nwindow = 600;

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

y_PSV = envelope(x_PSV);
y_EDV = envelope(x_EDV);

figure(5)
plot(envelope)
hold on
plot(x_PSV, y_PSV, '*r')
plot(x_EDV, y_EDV, '*k')
% legend('Raw Data','PSV','EDV')
figure(6)
y_MFV=(y_EDV(1:20002,:)+(y_PSV(1:20002,:)-y_EDV(1:20002,:))/3)/256*3025*154000/(2*2*10^6);
hold on
x_MFV=time(x_PSV(1:20002,:))/60;
plot(x_MFV, smooth(y_MFV,100))


