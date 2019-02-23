### Train
```
python model_main.py --lr=xx --num_epochs=xx --batch_size=xx --comment=XX
```

### Eval
```
python model_main.py --eval  --eval_output=RESULTS_FILE --model_path=CHECKPOINT_FILE
```

### Compute scores
```
python evaluate_tDCF_asvspoof19.py RESULTS_FILE scores/asv_dev.txt 
```

### To perform fusion of multiple results files
```
 python fuse_result.py --input FILE1 FILE2 FILE3 --output=RESULTS_FILE
```

#### Current result

### Logical Track

#### Using Spectorgram feature
lr = 0.00005, num_epochs=99

python model_main.py --num_epochs=100 --track=logical --features=spect   --lr=0.00005

```
CM SYSTEM
   EER            =  0.15698 % (Equal error rate for countermeasure)

TANDEM
   min-tDCF       =  0.00229

```

#### Using MFCC features

```
python model_main.py --num_epochs=100 --track=logical --features=mfcc   --lr=0.00005
```

```
CM SYSTEM
   EER            =  2.31044 % (Equal error rate for countermeasure)

TANDEM
   min-tDCF       =  0.07365
```

### Physical Track
```
python model_main.py --num_epochs=100 --track=physical --features=spect   --lr=0.00005

```

### Using MFCC features
```
python model_main.py --num_epochs=100 --track=physical --features=mfcc   --lr=0.00005

```

########## Preparing submission

for Dev track
```
python model_main.py --track=physical --model_path=./models/model_physical_spect_100_32_5e-05__2/epoch_59.pth --eval --eval_output=foo.txt
```

for Eval track
```
python model_main.py --track=physical --model_path=./models/model_physical_spect_100_32_5e-05__2/epoch_59.pth --eval --eval_output=foo.txt --is_eval --eval_part=0

```