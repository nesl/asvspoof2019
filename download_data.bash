#! /bin/bash
echo 'Downloading logical access dataset'
test -d data_logical || mdkir data_logical
cd data_logical
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_LA_train_v1.tar
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_LA_dev_v1.tar
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_LA_protocols_v1.tar
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_LA_dev_asv_scores_v1.txt
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_LA_instructions_v1.txt
cd ../
echo 'Downloading physical access dataset'
test -d data_physical || mkdir data_physical
cd data_physical
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_PA_train_v1.tar
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_PA_dev_v1.tar
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_PA_protocols_v1.tar
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_PA_dev_asv_scores_v1.txt
wget -c ftp://ftp.asvspoof.org/incoming/ASVspoof2019_PA_instructions_v1.txt
