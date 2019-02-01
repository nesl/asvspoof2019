ASVspoof 2019 CHALLENGE:
Automatic Speaker Verification Spoofing and Countermeasures Challenge

http://www.asvspoof.org/


============================================================================================
Matlab implementation of spoofing detection baseline system based on:
  - linear frequency cepstral coefficients (LFCC) features + Gaussian Mixture Models (GMMs)
  - constant Q cepstral coefficients (CQCC) features + Gaussian Mixture Models (GMMs)
============================================================================================


Contents of the package
=======================

- LFCC
------------------
Matlab implementation of linear frequency cepstral coefficients.

For further details on LFCC for antispoofing, refer to the following publication:
M. Sahidullah, T. Kinnunen, C. Hanilçi, "A Comparison of Features for Synthetic Speech Detection," in Proc INTERSPEECH, 2015.

- CQCC_v1.0
------------------
Matlab implementation of constant Q cepstral coefficients.

For further details on CQCC, refer to the following publication:

M. Todisco, H. Delgado, N. Evans,
"A new feature for automatic speaker verification anti-spoofing: Constant Q cepstral coefficients,"
in Proc. ODYSSEY 2016, The Speaker and Language Recognition Workshop, 2016.

http://audio.eurecom.fr/content/software

- GMM
-----------------
VLFeat open source library that implements the GMMs.

For further details, refer to:
http://www.vlfeat.org/

- tDCF_v1
----------------
Contains a implementation of the tandem detection cost function, used as the ASVspoof 2019 primary metric. It also contains the Bosaris toolkit.

For further details, refer to the paper:
T. Kinnunen, K.-A. Lee, H. Delgado, N. Evans, M. Todisco, M. Sahidullah, J. Yamagishi, D.-A. Reynolds,
"t-DCF: a Detection Cost Function for the Tandem Assessment of Spoofing Countermeasures and Automatic Speaker Verification,"
in Proc. ODYSSEY 2016, The Speaker and Language Recognition Workshop, 2018.

- ASVspoof2019_baseline_CM.m
----------------
This script implements the baseline countermeasure systems for ASVspoof 2019 Challenge.
Front-ends include LFCC and CQCC features, while back-end is based on GMMs. 
LFCC features use a 20-channel linear filterbank, from which 19 coefficients + 0th, with the static, delta and delta-delta coefficients.
The CQCC is applied with a maximum frequency of fs/2, where fs = 16kHz is the sampling frequency.
The minimum frequency is set to fs/2/2^9 ~15Hz (9 being the number of octaves). 
The number of bins per octave is set to 96. Re-sampling is applied with a sampling period of 16.
CQCC features dimension is set to 29 coefficients + 0th, with the static, delta and delta-delta coefficients.
2-class GMMs are trained on the genuine and spoofed speech utterances of the training dataset, respectively. We use 512-component models, trained with an expectation-maximisation (EM) algorithm with random initialisation. The score is computed as the log-likelihood ratio for the test utterance given the natural and the spoofed speech models.

Results are shown in the ASVspoof 2019 Evaluation Plan.

Contact information
===================

For any query, please contact ( info at asvspoof.org )

