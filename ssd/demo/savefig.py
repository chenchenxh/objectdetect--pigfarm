import os
import sys
module_path = os.path.abspath(os.path.join('..'))
if module_path not in sys.path:
    sys.path.append(module_path)

import torch
import torch.nn as nn
import torch.backends.cudnn as cudnn
from torch.autograd import Variable
import numpy as np
import cv2
if torch.cuda.is_available():
    torch.set_default_tensor_type('torch.cuda.FloatTensor')

from ssd import build_ssd

import matplotlib
matplotlib.use('Agg')
from matplotlib import pyplot as plt
from data import VOCDetection, VOC_ROOT, VOCAnnotationTransform

def ssd_detect(limit_detection,dataset):
    # image = cv2.imread('./data/example.jpg', cv2.IMREAD_COLOR)  # uncomment if dataset not downloaded
    # here we specify year (07 or 12) and dataset ('test', 'val', 'train') 
    testset = VOCDetection(VOC_ROOT, [('2007', dataset)], None, VOCAnnotationTransform())
    for img_id in range(len(testset)):
        if img_id %100 == 1:
            print(img_id,'/',len(testset))
        image = testset.pull_image(img_id)

        rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

        x = cv2.resize(image, (300, 300)).astype(np.float32)
        x -= (104.0, 117.0, 123.0)
        x = x.astype(np.float32)
        x = x[:, :, ::-1].copy()
        x = torch.from_numpy(x).permute(2, 0, 1)

        xx = Variable(x.unsqueeze(0))     # wrap tensor in Variable
        if torch.cuda.is_available():
            xx = xx.cuda()
        y = net(xx)


        from data import VOC_CLASSES as labels
        top_k=10

        plt.figure(figsize=(10,10))
        colors = plt.cm.hsv(np.linspace(0, 1, 21)).tolist()
          # plot the image for matplotlib
        currentAxis = plt.gca()

        detections = y.data
        # scale each detection back up to the image
        scale = torch.Tensor(rgb_image.shape[1::-1]).repeat(2)
        for i in range(detections.size(1)):
            j = 0
            while detections[0,i,j,0] >= limit_detection:
                score = detections[0,i,j,0]
                label_name = labels[i-1]
                display_txt = '%s: %.2f'%(label_name, score)
                pt = (detections[0,i,j,1:]*scale).cpu().numpy()
                coords = (pt[0], pt[1]), pt[2]-pt[0]+1, pt[3]-pt[1]+1
                color = colors[i]
                currentAxis.add_patch(plt.Rectangle(*coords, fill=False, edgecolor=color, linewidth=2))
                currentAxis.text(pt[0], pt[1], display_txt, bbox={'facecolor':color, 'alpha':0.5})
                j+=1

            #显示正确的检测框
            [imageid, gts] = testset.pull_anno(img_id)
            for gt in gts:
                coords = (gt[0], gt[1]), gt[2]-gt[0]+1, gt[3]-gt[1]+1
                currentAxis.add_patch(plt.Rectangle(*coords, fill=False, edgecolor=colors[15], linewidth=2))
        plt.imshow(rgb_image)
        plt.savefig('result/data/'+str(img_id)+'.jpg')
        plt.close()

net = build_ssd('test', 300, 2)    # initialize SSD
net.load_weights('../weights/ssd300_Data4_1_1e-4_11000.pth')


limit_detection = 0.3
dataset = 'trainval'
ssd_detect(limit_detection,dataset)