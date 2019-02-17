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

Epcoh 99:  EER = 2.23 , t-DCF = 0.06

Old Model results: EER = 2.87, t-DCF = 0.08

Fusion between epoch 99, and old model results : EER =1.91, and t-DCF = 0.054
