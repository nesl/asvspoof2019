%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASVspoof 2019
% Automatic Speaker Verification Spoofing and Countermeasures Challenge
%
% http://www.asvspoof.org/
%
% ============================================================================================
% Matlab implementation of spoofing detection baseline system based on:
%   - linear frequency cepstral coefficients (LFCC) features + Gaussian Mixture Models (GMMs)
%   - constant Q cepstral coefficients (CQCC) features + Gaussian Mixture Models (GMMs)
% ============================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all; clc;

% add required libraries to the path
addpath(genpath('LFCC'));
addpath(genpath('CQCC_v1.0'));
addpath(genpath('GMM'));
addpath(genpath('bosaris_toolkit'));
addpath(genpath('tDCF_v1'));

% set here the experiment to run (access and feature type)
access_type = 'LA'; % LA for logical or PA for physical
feature_type = 'LFCC'; % LFCC or CQCC

% set paths to the wave files and protocols

% TODO: in this code we assume that the data follows the directory structure:
%
% ASVspoof_root/
%   |- LA
%      |- ASVspoof2019_LA_dev_asv_scores_v1.txt
% 	   |- ASVspoof2019_LA_dev_v1/
% 	   |- ASVspoof2019_LA_protocols_v1/
% 	   |- ASVspoof2019_LA_train_v1/
%   |- PA
%      |- ASVspoof2019_PA_dev_asv_scores_v1.txt
%      |- ASVspoof2019_PA_dev_v1/
%      |- ASVspoof2019_PA_protocols_v1/
%      |- ASVspoof2019_PA_train_v1/

pathToASVspoof2019Data = '/path/to/ASVspoof_root/';

pathToDatabase = fullfile(pathToASVspoof2019Data, access_type);
trainProtocolFile = fullfile(pathToDatabase, horzcat('ASVspoof2019_', access_type, '_protocols'), horzcat('ASVspoof2019.', access_type, '.cm.train.trn.txt'));
devProtocolFile = fullfile(pathToDatabase, horzcat('ASVspoof2019_', access_type, '_protocols'), horzcat('ASVspoof2019.', access_type, '.cm.dev.trl.txt'));

% read train protocol
fileID = fopen(trainProtocolFile);
protocol = textscan(fileID, '%s%s%s%s%s');
fclose(fileID);

% get file and label lists
filelist = protocol{2};
key = protocol{5};

% get indices of genuine and spoof files
bonafideIdx = find(strcmp(key,'bonafide'));
spoofIdx = find(strcmp(key,'spoof'));

%% Feature extraction for training data

% extract features for GENUINE training data and store in cell array
disp('Extracting features for BONA FIDE training data...');
genuineFeatureCell = cell(size(bonafideIdx));
parfor i=1:length(bonafideIdx)
    filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_train/flac'],[filelist{bonafideIdx(i)} '.flac']);
    [x,fs] = audioread(filePath);
    if strcmp(feature_type,'LFCC')
        [stat,delta,double_delta] = extract_lfcc(x,fs,20,512,20);
        genuineFeatureCell{i} = [stat delta double_delta]';
    elseif strcmp(feature_type,'CQCC')
        genuineFeatureCell{i} = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
    end
end
disp('Done!');

% extract features for SPOOF training data and store in cell array
disp('Extracting features for SPOOF training data...');
spoofFeatureCell = cell(size(spoofIdx));
parfor i=1:length(spoofIdx)
    filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_train/flac'],[filelist{spoofIdx(i)} '.flac'])
    [x,fs] = audioread(filePath);
    if strcmp(feature_type,'LFCC')
        [stat,delta,double_delta] = extract_lfcc(x,fs,20,512,20);
        spoofFeatureCell{i} = [stat delta double_delta]';
    elseif strcmp(feature_type,'CQCC')
        spoofFeatureCell{i} = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
    end
end
disp('Done!');

%% GMM training

% train GMM for BONA FIDE data
disp('Training GMM for BONA FIDE...');
[genuineGMM.m, genuineGMM.s, genuineGMM.w] = vl_gmm([genuineFeatureCell{:}], 512, 'verbose', 'MaxNumIterations',10);
disp('Done!');

% train GMM for SPOOF data
disp('Training GMM for SPOOF...');
[spoofGMM.m, spoofGMM.s, spoofGMM.w] = vl_gmm([spoofFeatureCell{:}], 512, 'verbose', 'MaxNumIterations',10);
disp('Done!');


%% Feature extraction and scoring of development data

% read development protocol
fileID = fopen(devProtocolFile);
protocol = textscan(fileID, '%s%s%s%s%s');
fclose(fileID);

% get file and label lists
filelist = protocol{2};
attackType = protocol{4};
key = protocol{5};

% process each development trial: feature extraction and scoring
scores_cm = zeros(size(filelist));
disp('Computing scores for development trials...');
parfor i=1:length(filelist)
    filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_dev/flac'],[filelist{i} '.flac']);
    [x,fs] = audioread(filePath);
    % featrue extraction
    if strcmp(feature_type,'LFCC')
        [stat,delta,double_delta] = extract_lfcc(x,fs,20,512,20);
        x_fea = [stat delta double_delta]';
    elseif strcmp(feature_type,'CQCC')
        x_fea = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
    end
    
    % score computation
    llk_genuine = mean(compute_llk(x_fea,genuineGMM.m,genuineGMM.s,genuineGMM.w));
    llk_spoof = mean(compute_llk(x_fea,spoofGMM.m,spoofGMM.s,spoofGMM.w));
    % compute log-likelihood ratio
    scores_cm(i) = llk_genuine - llk_spoof;
end
disp('Done!');

% save scores to disk
fid = fopen(fullfile('cm_scores',['scores_cm_' access_type '_' feature_type '.txt']), 'w');
for i=1:length(scores_cm)
    fprintf(fid,'%s %s %s %.6f\n',filelist{i},attackType{i},key{i},scores_cm(i));
end
fclose(fid);

% compute performance
evaluate_tDCF_asvspoof19(fullfile('cm_scores', ['scores_cm_' access_type '_' feature_type '.txt']), ...
    fullfile(pathToASVspoof2019Data, access_type, ['ASVspoof2019_' access_type '_dev_asv_scores_v1.txt']));
