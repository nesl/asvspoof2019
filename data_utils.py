"""
    Author: Moustafa Alzantot (malzantot@ucla.edu)
    All rights reserved.
"""
import collections
import os
import soundfile as sf
import librosa
from torch.utils.data import DataLoader, Dataset

LOGICAL_DATA_ROOT = 'data_logical'


ASVFile = collections.namedtuple('ASVFile',
    ['speaker_id', 'file_name', 'sys_id', 'key'], verbose=False)

class ASVDataset(Dataset):
    """ Utility class to load  train/dev datatsets """
    def __init__(self, data_root=LOGICAL_DATA_ROOT, transform=None, is_train=True):
        self.prefix = 'ASVspoof2019_LA'
        self.sys_id_dict = {
            '-': 0,  # bonafide speech
            'SS_1': 1, # Wavenet vocoder
            'SS_2': 2, # Conventional vocoder WORLD
            'SS_4': 3, # Conventional vocoder MERLIN
            'US_1': 4, # Unit selection system MaryTTS
            'VC_1': 5, # Voice conversion using neural networks
            'VC_4': 6 # transform function-based voice conversion
        }
        self.data_root = data_root
        self.dset_name = 'train' if is_train else 'dev'
        self.protocols_fname ='train.trn' if is_train else 'dev.trl'
        self.protocols_dir = os.path.join(self.data_root,
            '{}_protocols/'.format(self.prefix))
        self.files_dir = os.path.join(self.data_root, '{}_{}'.format(
            self.prefix, self.dset_name), 'flac')
        self.protocols_fname = os.path.join(self.protocols_dir,
            'ASVspoof2019.LA.cm.{}.txt'.format(self.protocols_fname))
        self.files_meta = self.parse_protocols_file(self.protocols_fname)
        data = list(map(self.read_file, self.files_meta))
        self.data_x, self.data_y, self.data_sysid = map(list, zip(*data))
        self.length = len(self.data_x)
        self.transform = transform

    def __len__(self):
        return self.length

    def __getitem__(self, idx):
        x = self.data_x[idx]
        if self.transform:
            x = self.transform(x)
        y = self.data_y[idx]
        return x, y

    def read_file(self, meta):
        data_x, sample_read = sf.read(meta.file_name)
        data_y = meta.key
        return data_x, float(data_y), meta.sys_id
    def _parse_line(self, line):
        tokens = line.strip().split(' ')
        return ASVFile(speaker_id=tokens[0],
            file_name=os.path.join(self.files_dir, tokens[1] + '.flac'),
            sys_id=self.sys_id_dict[tokens[3]],
            key=int(tokens[4] == 'bonafide'))

    def parse_protocols_file(self, protocols_fname):
        lines = open(protocols_fname).readlines()
        files_meta = map(self._parse_line, lines)
        return list(files_meta)

if __name__ == '__main__':
    train_loader = ASVDataset(LOGICAL_DATA_ROOT, is_train=True)
    assert len(train_loader) == 25380, 'Incorrect size of training set.'
    dev_loader = ASVDataset(LOGICAL_DATA_ROOT, is_train=False)
    assert len(dev_loader) == 24844, 'Incorrect size of dev set.'

