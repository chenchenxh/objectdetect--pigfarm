function minp = detect_one_rgbimage_area(rgbim_name,folder,filename,xml_dst_path)
rgbim = imread(rgbim_name);
grayim = rgb2gray(rgbim);
SmallSize = 30;
SmallGray = 200;
LargeGray = 250;

minp=[];maxp=[];  %用来存储最终的位置的矩阵
image_size = size(grayim);
[x, y] = find(grayim>SmallGray&grayim<LargeGray);
edge = [x y];
all_size = [];
%区域生长算法：输入整个图像grayim，边缘点edge，输出结果minp和maxp
%从边缘点的二维矩阵edge中选取一个点，进行区域生长得到n个点的区域。若n小于某阈值并大于某阈值则判定为需要的区域。
%无论符不符合条件，都将这个区域从edge中删去，然后重新取edge的第一个点进行计算。
emptyarray = zeros(size(grayim));
while ~isempty(edge)
    temp = edge(1,:);  %获取tour的第一个点
    index = 1;
    while 1
        %从八个方向的5*5区域判断是否是边缘
        %eight1 = [-1 -1 -1 0 0 1 1 1 -2 -2 -2 -2 -2 -1 -1 0 0 1 1 2 2 2 2 2];eight2 = [-1 0 1 -1 1 -1 0 1 -2 -1 0 1 2 -2 2 -2 2 -2 2 -2 -1 0 1 2];
        %eight1 = [-1 -1 -1 0 0 1 1 1];eight2 = [-1 0 1 -1 1 -1 0 1];
        eight1 = [-1 0 0 1]; eight2 = [0 -1 1 0];
        for i = 1:length(eight1)
            a = temp(index,1)+eight1(i); b = temp(index,2)+eight2(i); %获得周围的坐标
            if a>0 && a<=image_size(1) && b>0 && b<=image_size(2)  %坐标没有超出范围
                if grayim(a,b)<LargeGray && grayim(a,b)>SmallGray && emptyarray(a,b)==0
                    emptyarray(a,b) = 1;
                    temp = [temp;[a b]];
                end
            end
        end
        index = index + 1;
        % 如果区域已检测结束则退出
        size_temp = size(temp);
        if index == size_temp(1) + 1
            break;
        end
    end
    
    %处理区域
    size_temp = size(temp);
    % 如果检测框太小（只是一个或者两个像素）
    if size_temp(1) <= SmallSize
        edge = setdiff(edge, temp, 'rows'); 
    else
        all_size = [all_size size_temp(1)];
        edge = setdiff(edge, temp, 'rows'); 
        minp = [minp; min(temp,[],1)];
        maxp = [maxp; max(temp,[],1)];
    end
end

% 输出检测框，测试结果正不正确：将minp和maxp在原图像上显示
% figure;
% imshow(rgbim);
% hold on;
% size_p = size(minp);
% for i = 1:size_p(1)
%     rectangle('Position',[minp(i,2) minp(i,1) maxp(i,2)-minp(i,2) maxp(i,1)-minp(i,1)],'LineWidth',1,'EdgeColor','b');
%     % 下面两行是输出检测框的数量，可以删除
%     txt = num2str(i);
%     text(minp(i,2),minp(i,1),txt,'Color','blue','FontSize',10);
% end
% hold off;

%生成xml：根据minp和maxp生成xml
xml_folder = 'VOC2007';
if ~isempty(minp)
    xml(xml_dst_path,xml_folder,filename,image_size,minp,maxp);
end
