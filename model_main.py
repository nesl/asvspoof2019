"""
    Author: Moustafa Alzantot (malzantot@ucla.edu)
    All rights reserved.
"""
import sys
import data_utils
import numpy as np
from torch import Tensor
from torch.utils.data import DataLoader
from torchvision import transforms
import librosa

import torch
from torch import nn 

from tensorboardX import SummaryWriter

def pad(x, max_len=64000):
    x_len = x.shape[0]
    if x_len >= max_len:
        return x[:max_len]
    # need to pad
    num_repeats = (max_len / x_len)+1
    x_repeat = np.repeat(x, num_repeats)
    padded_x = x_repeat[:max_len]
    return padded_x

class ResNetBlock(nn.Module):
    def __init__(self, in_depth, depth, first=False):
        super(ResNetBlock, self).__init__()
        self.first = first
        self.conv1 = nn.Conv1d(in_depth, depth, kernel_size=5, stride=1, padding=2)
        self.bn1 = nn.BatchNorm1d(depth)
        self.lrelu = nn.LeakyReLU(0.01)
        self.dropout = nn.Dropout(0.5)
        self.conv2 = nn.Conv1d(depth, depth, kernel_size=5, stride=2, padding=2)
        self.conv11 = nn.Conv1d(in_depth, depth, kernel_size=1, stride=2, padding=0)
        if not self.first :
            self.pre_bn = nn.BatchNorm1d(in_depth)

    def forward(self, x):
        # x is (B x d_in x T)
        prev = x
        prev_mp = self.conv11(x)

        if not self.first:
            out = self.pre_bn(x)
            out = self.lrelu(out)
        else:
            out = x
        out = self.conv1(x)
        # out is (B x depth x T/2)
        out = self.bn1(out)
        out = self.lrelu(out)
        out = self.dropout(out)
        out = self.conv2(out)
        # out is (B x depth x T/2)
        out = out + prev_mp
        return out

class ConvModel(nn.Module):
    def __init__(self):
        super(ConvModel, self).__init__()
        self.conv1 = nn.Conv1d(20, 16, 5)
        self.conv2 = nn.Conv1d(16, 12, 5)
        self.lrelu = nn.LeakyReLU(0.01)
        self.fc1 = nn.Linear(12*118, 128)
        self.fc2 = nn.Linear(128, 1)
    
    def forward(self, x):
        batch_size = x.size(0)
        out = self.conv1(x)
        out = self.lrelu(out)
        out = self.conv2(out)
        out = self.lrelu(out)
        out = out.view(batch_size, -1)
        out = self.fc1(out)
        out = self.lrelu(out)
        out = self.fc2(out)
        return out
        
def evaluate_accuracy(data_loader, model, device):
    num_correct = 0.0
    num_total = 0.0
    for batch_x, batch_y in train_loader:
        batch_size = batch_x.size(0)
        num_total += batch_size
        batch_x =batch_x.to(device)
        batch_y = batch_y.view(-1, 1).type(torch.float32).to(device)
        batch_out = model(batch_x)
        batch_pred = (batch_out > 0.0).type(torch.float32)
        num_correct += (batch_pred == batch_y).sum(dim=0).item()
    return 100 * (num_correct / num_total)
        
def train_epoch(data_loader, model, device):
    running_loss = 0
    num_correct = 0.0
    num_total = 0.0
    ii = 0
    optim = torch.optim.Adam(model.parameters(), lr=0.001)
    weight = torch.FloatTensor([9.0]).to(device)
    criterion = nn.BCEWithLogitsLoss(pos_weight=weight)
    for batch_x, batch_y in train_loader:
        batch_size = batch_x.size(0)
        num_total += batch_size
        ii += 1
        batch_x =batch_x.to(device)
        batch_y = batch_y.view(-1, 1).type(torch.float32).to(device)
        batch_out = model(batch_x)
        batch_loss = criterion(batch_out, batch_y)
        batch_pred = (batch_out > 0.0).type(torch.float32)
        num_correct += (batch_pred == batch_y).sum(dim=0).item()
        running_loss += (batch_loss.item() * batch_size)
        if ii % 10 == 0:
            sys.stdout.write('\r \t {:.2f}'.format((num_correct/num_total)*100))
        optim.zero_grad()
        batch_loss.backward()
        optim.step()
    running_loss /= num_total
    train_accuracy = (num_correct/num_total)*100
    return running_loss, train_accuracy

if __name__ == '__main__':
    feature_transform = transforms.Compose([
        lambda x: pad(x),
        lambda x: librosa.feature.mfcc(x, sr=16000),
        lambda x: Tensor(x)
        ])

    train_set = data_utils.ASVDataset(is_train=True, transform=feature_transform)
    dev_set = data_utils.ASVDataset(is_train=False, transform=feature_transform)
    train_loader = DataLoader(train_set, batch_size=32, shuffle=True)
    dev_loader = DataLoader(dev_set, batch_size=32, shuffle=True)
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    num_epochs = 100
    model = ConvModel().to(device)
    writer = SummaryWriter('log')
    for epoch in range(num_epochs):
        running_loss, train_accuracy = train_epoch(train_loader, model, device) 
        valid_accuracy = evaluate_accuracy(dev_loader, model, device)
        writer.add_scalar('train_accuracy', train_accuracy, epoch)
        writer.add_scalar('valid_accuracy', valid_accuracy, epoch)
        writer.add_scalar('loss', running_loss, epoch)
        print('{} - {} - {:.2f} - {:.2f}'.format(epoch, running_loss, train_accuracy, valid_accuracy))
        torch.save(model.state_dict(), 'epoch_{}.pth'.format(epoch))
