import matplotlib
matplotlib.use('Agg')
from data_aug.data_aug import *
from data_aug.bbox_util import *
import cv2 
import os
import pickle as pkl
import numpy as np 
import matplotlib.pyplot as plt
from gen_annotations import *

if sys.version_info[0] == 2:
    import xml.etree.cElementTree as ET
else:
    import xml.etree.ElementTree as ET

times=4

def parse_rec(filename):
    tree = ET.parse(filename)
    objects = []
    for obj in tree.findall('object'):
        obj_struct = {}
        bbox = obj.find('bndbox')
        obj_struct['bbox'] = [int(bbox.find('xmin').text) - 1,
                              int(bbox.find('ymin').text) - 1,
                              int(bbox.find('xmax').text) - 1,
                              int(bbox.find('ymax').text) - 1]
        objects.append(obj_struct)
    return objects

def aug_one_img(filename,save_folder,num):
    ann_folder = 'data/Annotations/'
    jpg_folder = 'data/JPEGImages/'

    xml_filename = filename+'.xml'
    jpg_filename = filename+'.jpg'
    recs = parse_rec(ann_folder+xml_filename)
    bboxes = []
    for rec in recs:
        rec['bbox'].append(0)
        bboxes.append(rec['bbox'])
    bboxes = np.array(bboxes,dtype='f')
    # print(bboxes)

    img = cv2.imread(jpg_folder+jpg_filename)[:,:,::-1] #OpenCV uses BGR channels
    # bboxes = pkl.load(open("messi_ann.pkl", "rb"))


# RandomVerticalFlip(0.5), 
    transforms = [Sequence([RandomHorizontalFlip(1)]),Sequence([RandomVerticalFlip(1)]),Sequence([RandomHorizontalFlip(0), RandomVerticalFlip(0)]),Sequence([RandomHorizontalFlip(1), RandomVerticalFlip(1)])]
    # print(img.shape,bboxes)
    for i in range(times):
        
        img_, bboxes_ = transforms[i](img, bboxes)
        
        #保存img
        plt.figure(figsize=(5,5))
        plt.imshow(img_)
        plt.axis('off')
        # print(img_.shape)
        plt.savefig(save_folder+'JPEGImages/'+'new_'+str(num+i+1)+'.jpg',dpi=100)
        plt.close()

        #保存bbox，转换为xml
        filename="new_"+str(i+1)+".jpg"
        anno= GEN_Annotations(filename)
        anno.set_size(img_.shape)
        for bbox_ in bboxes_:
            anno.add_pic_attr("pigfarm",bbox_[0],bbox_[1],bbox_[2],bbox_[3])
        anno.savefile(save_folder+"Annotations/"+"new_"+str(num+i+1)+".xml")

        

if __name__ == '__main__':
    """
    将图像和xml文件输入并进行数据增强，最终输出在文件夹中，
    输出文件夹需要先有JPEGImages和Annotations文件夹，
    输入和输出文件夹及其他参数可以在下面和全局变量中修改。
    """
    file_path = 'data/Annotations' #文件夹目录，ann和jpg均可
    files= os.listdir(file_path) #得到文件夹下的所有文件名称
    save_folder = 'results/'
    num=0

    # filename = '0419-1-18-31'
    # aug_one_img(filename,save_folder,0)

    for i,file in enumerate(files):
        if i% 100 == 0:
            print(i,'/',len(files))
        filename = file[0:len(file)-4]
        aug_one_img(filename,save_folder,num)
        num+=times
        