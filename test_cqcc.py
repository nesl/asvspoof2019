import model_main as mn
import soundfile as sf
import h5py
import numpy as np
voice = sf.read("/home/ziqi/Desktop/asvspoof2019-cqcc/data_logical/ASVspoof2019_LA_dev/flac/LA_D_1000265.flac")
x = mn.pad(voice[0])
cqcc_feature = mn.compute_cqcc_feats(x)

# prototype of the fuction that read matlan cahches
def read_matlab_cache(filepath):
    f = h5py.File(filepath,'r')
    data_y = f["data_y"][0]
    filename_index = f["filename"]
    data_x_index = f["data_x"]
    sys_id_index = f["sys_id"]
    filename = []
    data_x = []
    sys_id = []
    for i in range(0,data_x_index.shape[1]):
        idx = data_x_index[0][i]
        temp = f[idx]
        data_x.append(np.array(temp).transpose())

        idx = filename_index[0][i]
        temp = list(f[idx])
        temp_name = [chr(x[0]) for x in temp]
        filename.append(''.join(temp_name))

        idx = sys_id_index[0][i]
        temp = f[idx]
        sys_id.append(int(list(temp)[0][0]))

    return data_x, data_y, sys_id








# Abandoned code in model_main.py in def compute_cqcc_feats(x):
# B = 96
# sr = 16000
# fmax = sr/2
# oct = math.ceil(np.log2(fmax / 20))
# fmin = fmax / 2 ** oct
# # gamma = 228.7 * (2 ** (1 / B) - 2 ** (-1 / B))
# constant_q = librosa.cqt(y=x, bins_per_octave=B, sr=sr, fmin=fmin)
# problem: Cqt in librosa is different from cqt in matlab
