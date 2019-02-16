"""
Utility script to fuse different output files.
"""

import numpy as np
import pandas as pd
import argparse

def read_frame(fname):
    data_np = np.genfromtxt(fname, dtype=str)
    df = pd.DataFrame(index=data_np[:,0],data=data_np, columns=['fname', 'sysid', 'key', 'score'])
    df['score'] = df['score'].astype(np.float32, copy=False)
    return df

def fuse(file_list):
    frames = [read_frame(f) for f in file_list]
    result_df = pd.concat(frames).groupby(["fname", "sysid", "key"], as_index=False)["score"].mean()
    return result_df
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser('Result Fusion utility')
    parser.add_argument('--input', type=str, nargs='+', required=True)
    parser.add_argument('--output', type=str,required=True)
    args = parser.parse_args()
    print('Processing input files : ', args.input)
    fuse_result =  fuse(args.input)
    fuse_result.to_csv(args.output,  sep=' ', header=False, index=False)
    print('Result saved to {}'.format(args.output))