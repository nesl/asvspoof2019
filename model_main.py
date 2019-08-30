"""
    Author: Moustafa Alzantot (malzantot@ucla.edu)
    All rights reserved.
"""
import argparse
import sys
import os
import data_utils
import numpy as np
from torch import Tensor
from torch.utils.data import DataLoader
from torchvision import transforms
import librosa

import torch
from torch import nn
from tensorboardX import SummaryWriter

from models import SpectrogramModel, MFCCModel, CQCCModel
from scipy.optimize import brentq
from scipy.interpolate import interp1d
from sklearn.metrics import roc_curve


def pad(x, max_len=64000):
    x_len = x.shape[0]
    if x_len >= max_len:
        return x[:max_len]
    # need to pad
    num_repeats = (max_len / x_len)+1
    x_repeat = np.repeat(x, num_repeats)
    padded_x = x_repeat[:max_len]
    return padded_x


def evaluate_accuracy(data_loader, model, device):
    num_correct = 0.0
    num_total = 0.0
    model.eval()
    for batch_x, batch_y, batch_meta in data_loader:
        batch_size = batch_x.size(0)
        num_total += batch_size
        batch_x = batch_x.to(device)
        batch_y = batch_y.view(-1).type(torch.int64).to(device)
        batch_out = model(batch_x)
        _, batch_pred = batch_out.max(dim=1)
        num_correct += (batch_pred == batch_y).sum(dim=0).item()
    return 100 * (num_correct / num_total)


def produce_evaluation_file(dataset, model, device, save_path):
    data_loader = DataLoader(dataset, batch_size=32, shuffle=False)
    num_correct = 0.0
    num_total = 0.0
    model.eval()
    true_y = []
    fname_list = []
    key_list = []
    sys_id_list = []
    key_list = []
    score_list = []
    for batch_x, batch_y, batch_meta in data_loader:
        batch_size = batch_x.size(0)
        num_total += batch_size
        batch_x = batch_x.to(device)
        batch_out = model(batch_x)
        batch_score = (batch_out[:, 1] - batch_out[:, 0]
                       ).data.cpu().numpy().ravel()

        # add outputs
        fname_list.extend(list(batch_meta[1]))
        key_list.extend(
            ['bonafide' if key == 1 else 'spoof' for key in list(batch_meta[4])])
        sys_id_list.extend([dataset.sysid_dict_inv[s.item()]
                            for s in list(batch_meta[3])])
        score_list.extend(batch_score.tolist())

    with open(save_path, 'w') as fh:
        for f, s, k, cm in zip(fname_list, sys_id_list, key_list, score_list):
            if not dataset.is_eval:
                fh.write('{} {} {} {}\n'.format(f, s, k, cm))
            else:
                fh.write('{} {}\n'.format(f, cm))
    print('Result saved to {}'.format(save_path))


def train_epoch(data_loader, model, lr, device):
    running_loss = 0
    num_correct = 0.0
    num_total = 0.0
    ii = 0
    model.train()
    optim = torch.optim.Adam(model.parameters(), lr=lr)
    weight = torch.FloatTensor([1.0, 9.0]).to(device)
    criterion = nn.NLLLoss(weight=weight)
    for batch_x, batch_y, batch_meta in train_loader:
        batch_size = batch_x.size(0)
        num_total += batch_size
        ii += 1
        batch_x = batch_x.to(device)
        batch_y = batch_y.view(-1).type(torch.int64).to(device)
        batch_out = model(batch_x)
        batch_loss = criterion(batch_out, batch_y)
        _, batch_pred = batch_out .max(dim=1)
        num_correct += (batch_pred == batch_y).sum(dim=0).item()
        running_loss += (batch_loss.item() * batch_size)
        if ii % 10 == 0:
            sys.stdout.write('\r \t {:.2f}'.format(
                (num_correct/num_total)*100))
        optim.zero_grad()
        batch_loss.backward()
        optim.step()
    running_loss /= num_total
    train_accuracy = (num_correct/num_total)*100
    return running_loss, train_accuracy


def get_log_spectrum(x):
    s = librosa.core.stft(x, n_fft=2048, win_length=2048, hop_length=512)
    a = np.abs(s)**2
    #melspect = librosa.feature.melspectrogram(S=a)
    feat = librosa.power_to_db(a)
    return feat


def compute_mfcc_feats(x):
    mfcc = librosa.feature.mfcc(x, sr=16000, n_mfcc=24)
    delta = librosa.feature.delta(mfcc)
    delta2 = librosa.feature.delta(delta)
    feats = np.concatenate((mfcc, delta, delta2), axis=0)
    return feats


if __name__ == '__main__':
    parser = argparse.ArgumentParser('UCLANESL ASVSpoof2019  model')
    parser.add_argument('--eval', action='store_true', default=False,
                        help='eval mode')
    parser.add_argument('--model_path', type=str,
                        default=None, help='Model checkpoint')
    parser.add_argument('--eval_output', type=str, default=None,
                        help='Path to save the evaluation result')
    parser.add_argument('--batch_size', type=int, default=32)
    parser.add_argument('--num_epochs', type=int, default=100)
    parser.add_argument('--lr', type=float, default=0.0001)
    parser.add_argument('--comment', type=str, default=None,
                        help='Comment to describe the saved mdoel')
    parser.add_argument('--track', type=str, default='logical')
    parser.add_argument('--features', type=str, default='spect')
    parser.add_argument('--is_eval', action='store_true', default=False)
    parser.add_argument('--eval_part', type=int, default=0)
    if not os.path.exists('models'):
        os.mkdir('models')
    args = parser.parse_args()
    track = args.track
    assert args.features in ['mfcc', 'spect', 'cqcc'], 'Not supported feature'
    model_tag = 'model_{}_{}_{}_{}_{}'.format(
        track, args.features, args.num_epochs, args.batch_size, args.lr)
    if args.comment:
        model_tag = model_tag + '_{}'.format(args.comment)
    model_save_path = os.path.join('models', model_tag)
    assert track in ['logical', 'physical'], 'Invalid track given'
    is_logical = (track == 'logical')
    if not os.path.exists(model_save_path):
        os.mkdir(model_save_path)

    if args.features == 'mfcc':
        feature_fn = compute_mfcc_feats
        model_cls = MFCCModel
    elif args.features == 'spect':
        feature_fn = get_log_spectrum
        model_cls = SpectrogramModel
    elif args.features == 'cqcc':
        feature_fn = None  # cqcc feature is extracted in Matlab script
        model_cls = CQCCModel

    transforms = transforms.Compose([
        lambda x: pad(x),
        lambda x: librosa.util.normalize(x),
        lambda x: feature_fn(x),
        lambda x: Tensor(x)
    ])
    device = 'cuda' if torch.cuda.is_available() else 'cpu'

    dev_set = data_utils.ASVDataset(is_train=False, is_logical=is_logical,
                                    transform=transforms,
                                    feature_name=args.features, is_eval=args.is_eval, eval_part=args.eval_part)
    dev_loader = DataLoader(dev_set, batch_size=args.batch_size, shuffle=True)
    model = model_cls().to(device)
    print(args)

    if args.model_path:
        model.load_state_dict(torch.load(args.model_path))
        print('Model loaded : {}'.format(args.model_path))

    if args.eval:
        assert args.eval_output is not None, 'You must provide an output path'
        assert args.model_path is not None, 'You must provide model checkpoint'
        produce_evaluation_file(dev_set, model, device, args.eval_output)
        sys.exit(0)

    train_set = data_utils.ASVDataset(is_train=True, is_logical=is_logical, transform=transforms,
                                      feature_name=args.features)

    train_loader = DataLoader(
        train_set, batch_size=args.batch_size, shuffle=True)
    num_epochs = args.num_epochs
    writer = SummaryWriter('logs/{}'.format(model_tag))
    for epoch in range(num_epochs):
        running_loss, train_accuracy = train_epoch(
            train_loader, model, args.lr, device)
        valid_accuracy = evaluate_accuracy(dev_loader, model, device)
        writer.add_scalar('train_accuracy', train_accuracy, epoch)
        writer.add_scalar('valid_accuracy', valid_accuracy, epoch)
        writer.add_scalar('loss', running_loss, epoch)
        print('\n{} - {} - {:.2f} - {:.2f}'.format(epoch,
                                                   running_loss, train_accuracy, valid_accuracy))
        torch.save(model.state_dict(), os.path.join(
            model_save_path, 'epoch_{}.pth'.format(epoch)))
