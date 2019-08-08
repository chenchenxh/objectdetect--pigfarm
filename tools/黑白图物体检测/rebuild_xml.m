function rebuild_xml(xml_path,filename,folder,disize,xml_dst_path,bw)
divise_size = disize;
xml_folder = 'VOC2007';
%读取xml，重新生成xml

xmlDoc = xmlread([xml_path filename '.xml']);
%读取xml中的基本信息

image_size = xmlDoc.getElementsByTagName('size').item(0);
width = str2num(image_size.getElementsByTagName('width').item(0).getTextContent());
height = str2num(image_size.getElementsByTagName('height').item(0).getTextContent());

object_array = xmlDoc.getElementsByTagName('bndbox');
length = object_array.getLength();
viminp = []; vimaxp = [];
for i = 0:length-1
    object = object_array.item(i);
    xmin = object.getElementsByTagName('xmin').item(0);
    xmin = str2num(xmin.getTextContent());
    xmax = object.getElementsByTagName('xmax').item(0);
    xmax = str2num(xmax.getTextContent());
    ymin = object.getElementsByTagName('ymin').item(0);
    ymin = str2num(ymin.getTextContent());
    ymax = object.getElementsByTagName('ymax').item(0);
    ymax = str2num(ymax.getTextContent());
    viminp = [viminp;ymin xmin];
    vimaxp = [vimaxp;ymax xmax];
end

% %根据minp和maxp切割后生成的新的minp和maxp
wstart = 1; wadd = divise_size;
for j = 1:fix(width/divise_size)
    change = viminp(:,2)<wstart & vimaxp(:,2)>=wstart;
    if ismember(1,change)%判断是否有需要修改的矩阵标记
        tempminp = viminp(change==1,:);
        tempmaxp = vimaxp(change==1,:);

        vimaxp(change==1,2) = wstart-1;
        tempminp(:,2) = wstart;

        viminp = [viminp;tempminp];
        vimaxp = [vimaxp;tempmaxp];
    end
    wstart = wstart + divise_size;
end
hstart = 1; hadd = divise_size;
for j = 1:fix(height/divise_size)
    change = viminp(:,1)<hstart & vimaxp(:,1)>=hstart;
    if ismember(1,change)%判断是否有需要修改的矩阵标记
        tempminp = viminp(change==1,:);
        tempmaxp = vimaxp(change==1,:);

        vimaxp(change==1,1) = hstart-1;
        tempminp(:,1) = hstart;

        viminp = [viminp;tempminp];
        vimaxp = [vimaxp;tempmaxp];
    end
    hstart = hstart + divise_size;
end


% im = imread([folder '/' filename '.tif']);  %读取原图
% bw = im2bw( im );   % 转二值图像，需要注意是否需要转二值
% 输出检测框，测试结果正不正确：将minp和maxp在原图像上显示
figure;
imshow(bw);
hold on;
size_p = size(viminp);
for i = 1:size_p(1)
    rectangle('Position',[viminp(i,2) viminp(i,1) vimaxp(i,2)-viminp(i,2) vimaxp(i,1)-viminp(i,1)],'LineWidth',10,'EdgeColor','b');
    % 下面两行是输出检测框的数量，可以删除
end
%n = 800
%line([1 2000],[n n],'color','white');
hold off;

% 
% %生成xml：根据minp和maxp生成xml
% hstart = 1; hadd = divise_size; 
% for i = 1:fix(height/divise_size)
%     wstart = 1; wadd = divise_size;
%     for j = 1:fix(width/divise_size)
%         if i == fix(height/divise_size)
%             hadd = divise_size + mod(height,divise_size);
%         else
%             hadd = divise_size;
%         end
%         if j == fix(width/divise_size)
%             wadd = divise_size + mod(width,divise_size);
%         else
%             wadd = divise_size;
%         end
%         temp =  viminp(:,1)>=hstart & viminp(:,1) < hstart+hadd & viminp(:,2)>=wstart & vimaxp(:,2) < wstart+wadd;
%         if ismember(1,temp)
%             temp_minp = mod(viminp(temp,:),divise_size);temp_maxp = mod(vimaxp(temp,:),divise_size);
%             temp_minp(temp_minp==0) = divise_size; temp_maxp(temp_maxp==0) = divise_size;
%             xml(xml_dst_path , xml_folder, [filename '-' num2str((i-1)*fix(height/divise_size)+j)],[hadd, wadd],temp_minp,temp_maxp);
%         end
%         
%         wstart = wstart + divise_size;
%     end
%     hstart = hstart + divise_size;
% end
