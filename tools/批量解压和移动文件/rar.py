from unrar import rarfile
import os
def unrar (filename, dst_path_bw, dst_path_yuantu, i):
    rar = rarfile.RarFile(filename) #读取rar
    
    info = rar.namelist()
    for j in range(len(info)):
        if '黑白.tif' in info[j]:
            #解压黑白图并重命名
            print('黑白.tif')
            rar.extract(info[j], dst_path_bw)
            os.rename(dst_path_bw+'\\'+info[j], dst_path_bw+'\\' +str(i)+'.tif')
        # if '原图.tif' in info[j]:
        #     #解压原图并重命名
        #     print('原图.tif')
        #     rar.extract(info[j], dst_path_yuantu)
        #     os.rename(dst_path_yuantu+'\\'+info[j], dst_path_yuantu+'\\' +str(i)+'.tif')
        # detect_name = filename.split('\\')[4] + '.tif'
        # if detect_name == info[j]:
        #     #解压原图并重命名
        #     print(detect_name)
        #     rar.extract(info[j], dst_path_yuantu)
        #     os.rename(dst_path_yuantu+'\\'+info[j], dst_path_yuantu+'\\' +str(i)+'.tif')

if __name__ == '__main__':

    source_path = 'F:\BaiduYunDownload\原始数据\\2019-4-12'
    dst_path_bw = 'F:\BaiduYunDownload\黑白图\\0412'
    dst_path_yuantu = 'F:\BaiduYunDownload\原图\\0412'
    i = 1

    files = os.listdir(source_path)
    for file in files:  #遍历所有文件
        if os.path.isdir(source_path+'\\'+file):  #如果是文件夹则打开
            cur_files = os.listdir(source_path+'\\'+file)  #获取子文件夹中的文件（包含rar）
            for cur_file in cur_files:   #遍历子文件夹
                if os.path.splitext(cur_file)[1] == '.rar':  #获得子文件夹中的rar文件
                    print(source_path+'\\'+file+'\\'+cur_file)
                    unrar(source_path+'\\'+file+'\\'+cur_file, dst_path_bw, dst_path_yuantu, i)
                    i+=1

    # unrar('南雄市湖口镇.rar', dst_path_bw, dst_path_yuantu, i)