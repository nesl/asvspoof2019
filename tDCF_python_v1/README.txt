A Python code package for computing t-DCF and EER metrics for ASVspoof2019.
(Version 1.0)

USAGE:

 TO USE WITH CUSTOM SCORE FILES:
 python evaluate_tDCF_asvspoof19.py <YOUR_CM_SCORE_FILE> <ORGANIZERS_ASV_SCORE_FILE>

 TO USE WITH THE EXAMPLE SCORE FILES:
 python evaluate_tDCF_asvspoof19.py

NOTE! There are two different ASV score files provided by the organizers:
      One for the physical access scenario and the other for the logical access scenario.

REQUIREMENTS:
 -python3 (tested with version 3.6.5)
 -numpy (tested with version 1.15.4)
 -matplotlib (tested with version 2.2.2)