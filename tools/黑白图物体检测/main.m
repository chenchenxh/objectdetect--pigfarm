disize = 500;  %�и��С
date = '0412';
%xml_path = '0606/xml/';   %��xml�Ĵ洢λ��

folder = ['F:/BaiduYunDownload/ԭͼ/' date '\'];  %ԭͼ·��
dst_path= ['MyData/' date '/Images/'];  %�и�ͼ����ʱ�洢λ��
image_path = ['MyData/' date '/JPEGImages/'];%Ŀ���ļ�Ŀ¼�����գ�

folderbw = ['F:/BaiduYunDownload/�ڰ�ͼ/' date '/'];  %�ڰ�ͼ·��
bw_dst_path = ['MyData/' date '/bwImages/']; %�ڰ�ͼ�洢λ��
xml_dst_path = ['MyData/' date '/Annotations/']; %xml������մ洢·�������գ�


%�ָ����кڰ�ͼ��
bigDir = dir([folderbw '\*.tif']);
for i = 1:length(bigDir)
    fprintf('bw: %d/%d\n',i,length(bigDir));
    filename = bigDir(i).name;
    division_code(folderbw,filename,disize,bw_dst_path,date);
end

%ʶ������xml
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

%�ָ�����ԭͼ
% bigDir = dir([folder '\*.tif']);
% for i = 1:length(bigDir)
%     fprintf('yuantu: %d/%d\n',i,length(bigDir));
%     filename = bigDir(i).name;
%     division_code(folder,filename,disize,dst_path,date);
% end

%��������ͼƬ���Ƶ�JPEGImages�ļ�������
fprintf('copyfile\n');
copyf(xml_dst_path,image_path,date)


%�ָ�ڰ�ͼ
%division_code(folderbw,filename,disize,bw_dst_path);
%�ָ�ԭͼ
%division_code(folder,filename,disize,dst_path);
%���ɴ�xml
%detect_area(folderbw,filename,xml_path);
%�ؽ�xml
%rebuild_xml(xml_path,filename,folder,disize,xml_dst_path,bw);


%ʶ������ת��xml
% imgPath = dst_path;        % ͼ���·��
% imgDir  = dir([imgPath '\*.png']); % ��������jpg��ʽ�ļ�
% for i = 1:length(imgDir)          % �����ṹ��Ϳ���һһ����ͼƬ��
%     if (ismember(1,i == fix(length(imgDir)/10*[0 1 2 3 4 5 6 7 8 9 10])))
%         fprintf('xml: %d/%d\n',i,length(imgDir));
%     end
%     filename2 = imgDir(i).name;
%     filename2 = filename2(1:length(filename2));
%     detect_area(imgPath,filename2,xml_dst_path); %��ȡÿ��ͼƬ
% end


