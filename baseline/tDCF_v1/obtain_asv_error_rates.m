function [Pfa_asv, Pmiss_asv, Pmiss_spoof_asv] = obtain_asv_error_rates(tar_asv, non_asv, spoof_asv, thresh_asv)

Ntar_asv    = length(tar_asv);
Nnon_asv    = length(non_asv);
Nspoof_asv  = length(spoof_asv);

% Obtain ASV false alarm and miss rates
Pfa_asv     = sum(non_asv >= thresh_asv)./Nnon_asv;
Pmiss_asv   = sum(tar_asv <  thresh_asv)./Ntar_asv;
if isempty(spoof_asv)
    Pmiss_spoof_asv = [];
else
    Pmiss_spoof_asv = sum(spoof_asv <  thresh_asv)./Nspoof_asv;
end