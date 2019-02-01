%%%%%% example of use of the evaluate_tDCF_asvspoof19 function using two
%%%%%% set of toy scores (in folder "scores")

clear; close all;

addpath(genpath('bosaris_toolkit.1.06'));
addpath('tDCF');

ASV_SCOREFILE = 'scores/asv_dev.txt';
CM_SCOREFILE = 'scores/cm_dev.txt';

evaluate_tDCF_asvspoof19(CM_SCOREFILE, ASV_SCOREFILE);

