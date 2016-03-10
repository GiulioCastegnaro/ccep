
function [n1_mat,rmseN1,fitted_line_n1] = ccep_fitN1(ccep_parmsN1fit,ccep,data,times,el,elm)



%% N1 and N2 component detection. Fits a line plus gaussian with preset parameters.
% Each component is detected separately. Best fit is estimated by
% non-linear least squares estimate. Outputs to structs that contain N1 and
% N2 data:
% 1st dimension - stimulated electrode
% 2nd dimension - measured electrode
% 3rd dimension - (1st value - peak amplitude (microV), 2nd value - width (ms), 3rd value - latency (ms))
%
% Additionally, for each component a root mean square error is
% created, to evaluate the goodness of fit for each component:
% 1st dimension - stimulated electrode
% 2nd dimension - measured electrode
%
% Vassileva and Hermes, 2016, UMC Utrecht


%% Define data and times to fit for each component:

% N1:
data2fitN1 = squeeze(nanmean(data(elm,times>ccep_parmsN1fit.t_low_N1 & times<ccep_parmsN1fit.t_up_N1,ccep(el).epochs),3));
data2fitN1 = double(data2fitN1);

if find(isnan(data2fitN1),1)>0
    disp(['WARNING: input data N1 has NANs, fitting function is going to crash at electrode ' int2str(elm)])
end

%% Detect N1

% calculate least squares
[a, resNorm] =...
  lsqnonlin(@(x) LinePlusGauss(x,data2fitN1,ccep_parmsN1fit.times2fitN1),ccep_parmsN1fit.X01,ccep_parmsN1fit.LB1,ccep_parmsN1fit.UB1,ccep_parmsN1fit.my_options);

% fit a line
fitted_line_n1 = a(1)*sqrt(2*pi)*normpdf(ccep_parmsN1fit.times2fitN1,a(2),a(3)) + a(4);

% calculate outputs
amp = a(1)/a(3);                  % amplitude
funWidth = 2*sqrt(2*log(2))*a(3); % width
peakLat = a(2);                   % peak latency

% write stuff down:
n1_mat = [a(1) a(2) a(3) a(4) amp funWidth];
rmseN1 = sqrt(resNorm/ccep_parmsN1fit.alltN1); % root mean square error
% 
clear a amp funWidth peakLat resNorm

%% Plot N1 data + fitted line
% figure,
% hold on
% plot(times2fitN1,data2fitN1,'k')
% plot(times2fitN1,fitted_line_n1,'r')
% xlabel('ms')
% ylabel('mV')
% title(['N1 ' int2str(el) ' to ' int2str(elm) ' subj ' s])

