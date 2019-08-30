# Deep Residual Neural Networks for Audio Spoofing Detection

This repo has an implemntation for our paper **Deep Residual Neural Networks for Audio Spoofing Detection**, this is also describes the solution of team **UCLANESL** in the [ASVSpoof 2019 competition](https://www.asvspoof.org/).

## Dataset

The ASVSpoof2019 dataset can be downloaded from the following link:

[ASVSpoof2019 dataset](https://datashare.is.ed.ac.uk/handle/10283/3336)

### Training models
```
python model_main.py --num_epochs=100 --track=[logical/physical] --features=[spect/mfcc/cqcc]   --lr=0.00005
```

#### To perform fusion of multiple results files
```
 python fuse_result.py --input FILE1 FILE2 FILE3 --output=RESULTS_FILE
```

### Evaluating Models

Run the model on the evaluation dataset to generate a prediction file.
```
python model_main.py --eval  --eval_output=RESULTS_FILE --model_path=CHECKPOINT_FILE
```

Then compute the evaluation scores using:

```
python evaluate_tDCF_asvspoof19.py RESULTS_FILE scores/asv_dev.txt 
```


