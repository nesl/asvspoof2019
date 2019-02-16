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

Epoch 80 : EER = 4.2, t-DCF = 0.14
Epoch 90:  EER = 4.004, t-DCF = 0.133
EPOCH=98, EER= 3.33, t-DCF = 0.116
Epcoh 99:  EER = 2.23 , t-DCF = 0.06

