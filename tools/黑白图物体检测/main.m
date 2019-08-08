disize = 500;  %切割大小
date = '0412';
%xml_path = '0606/xml/';   %大xml的存储位置

folder = ['F:/BaiduYunDownload/原图/' date '\'];  %原图路径
dst_path= ['MyData/' date '/Images/'];  %切割图像临时存储位置
image_path = ['MyData/' date '/JPEGImages/'];%目的文件目录（最终）

folderbw = ['F:/BaiduYunDownload/黑白图/' date '/'];  %黑白图路径
bw_dst_path = ['MyData/' date '/bwImages/']; %黑白图存储位置
xml_dst_path = ['MyData/' date '/Annotations/']; %xml标记最终存储路径（最终）


%分割所有黑白图像
bigDir = dir([folderbw '\*.tif']);
for i = 1:length(bigDir)
    fprintf('bw: %d/%d\n',i,length(bigDir));
    filename = bigDir(i).name;
    division_code(folderbw,filename,disize,bw_dst_path,date);
end

%识别生成xml
%rgbim_name =  '0606-3-28-36.jpg';
%detect_one_rgbimage_area([bw_dst_path rgbim_name],folderbw,rgbim_name(1:length(rgbim_name)-4),xml_dst_path);

bigDir = dir([bw_dst_path '\*.jpg']);
for i = 1:length(bigDir)
    if mod(i,1000)==0
        fprintf('xml: %d/%d\n',i,length(bigDir));
    end
    rgbim_name =  bigDir(i).name;
    detect_one_rgbimage_area([bw_dst_path rgbim_name],folderbw,rgbim_name(1:length(rgbim_name)-4),xml_dst_path);
end

%分割所有原图
% bigDir = dir([folder '\*.tif']);
% for i = 1:length(bigDir)
%     fprintf('yuantu: %d/%d\n',i,length(bigDir));
%     filename = bigDir(i).name;
%     division_code(folder,filename,disize,dst_path,date);
% end

%将有猪场的图片复制到JPEGImages文件夹里面
fprintf('copyfile\n');
copyf(xml_dst_path,image_path,date)


%分割黑白图
%division_code(folderbw,filename,disize,bw_dst_path);
%分割原图
%division_code(folder,filename,disize,dst_path);
%生成大xml
%detect_area(folderbw,filename,xml_path);
%重建xml
%rebuild_xml(xml_path,filename,folder,disize,xml_dst_path,bw);


%识别区域并转换xml
% imgPath = dst_path;        % 图像库路径
% imgDir  = dir([imgPath '\*.png']); % 遍历所有jpg格式文件
% for i = 1:length(imgDir)          % 遍历结构体就可以一一处理图片了
%     if (ismember(1,i == fix(length(imgDir)/10*[0 1 2 3 4 5 6 7 8 9 10])))
%         fprintf('xml: %d/%d\n',i,length(imgDir));
%     end
%     filename2 = imgDir(i).name;
%     filename2 = filename2(1:length(filename2));
%     detect_area(imgPath,filename2,xml_dst_path); %读取每张图片
% end


