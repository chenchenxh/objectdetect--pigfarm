import os
import shutil
source_path = 'F:\BaiduYunDownload\原始数据\\2019-3-15\标注'
dst_path_bw = 'F:\BaiduYunDownload\黑白图\\0315'
dst_path_yuantu = 'F:\BaiduYunDownload\原图\\0315'
i = 1

files = os.listdir(source_path)
for file in files:  #遍历所有文件
    if os.path.isdir(source_path+'\\'+file):  #如果是文件夹则打开
        print(file)
        cur_files = os.listdir(source_path+'\\'+file)  #获取子文件夹中的文件
        for cur_file in cur_files:   #遍历子文件夹
            if cur_file==file+'.tif':
                shutil.move(source_path+'\\'+file+'\\'+cur_file, dst_path_yuantu)
                os.rename(dst_path_yuantu+'\\'+cur_file, dst_path_yuantu+'\\' +str(i)+'.tif')
                i+=1