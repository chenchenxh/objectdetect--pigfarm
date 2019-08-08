function minp = detect_one_rgbimage_area(rgbim_name,folder,filename,xml_dst_path)
rgbim = imread(rgbim_name);
grayim = rgb2gray(rgbim);
SmallSize = 30;
SmallGray = 200;
LargeGray = 250;

minp=[];maxp=[];  %�����洢���յ�λ�õľ���
image_size = size(grayim);
[x, y] = find(grayim>SmallGray&grayim<LargeGray);
edge = [x y];
all_size = [];
%���������㷨����������ͼ��grayim����Ե��edge��������minp��maxp
%�ӱ�Ե��Ķ�ά����edge��ѡȡһ���㣬�������������õ�n�����������nС��ĳ��ֵ������ĳ��ֵ���ж�Ϊ��Ҫ������
%���۷�������������������������edge��ɾȥ��Ȼ������ȡedge�ĵ�һ������м��㡣
emptyarray = zeros(size(grayim));
while ~isempty(edge)
    temp = edge(1,:);  %��ȡtour�ĵ�һ����
    index = 1;
    while 1
        %�Ӱ˸������5*5�����ж��Ƿ��Ǳ�Ե
        %eight1 = [-1 -1 -1 0 0 1 1 1 -2 -2 -2 -2 -2 -1 -1 0 0 1 1 2 2 2 2 2];eight2 = [-1 0 1 -1 1 -1 0 1 -2 -1 0 1 2 -2 2 -2 2 -2 2 -2 -1 0 1 2];
        %eight1 = [-1 -1 -1 0 0 1 1 1];eight2 = [-1 0 1 -1 1 -1 0 1];
        eight1 = [-1 0 0 1]; eight2 = [0 -1 1 0];
        for i = 1:length(eight1)
            a = temp(index,1)+eight1(i); b = temp(index,2)+eight2(i); %�����Χ������
            if a>0 && a<=image_size(1) && b>0 && b<=image_size(2)  %����û�г�����Χ
                if grayim(a,b)<LargeGray && grayim(a,b)>SmallGray && emptyarray(a,b)==0
                    emptyarray(a,b) = 1;
                    temp = [temp;[a b]];
                end
            end
        end
        index = index + 1;
        % ��������Ѽ��������˳�
        size_temp = size(temp);
        if index == size_temp(1) + 1
            break;
        end
    end
    
    %��������
    size_temp = size(temp);
    % �������̫С��ֻ��һ�������������أ�
    if size_temp(1) <= SmallSize
        edge = setdiff(edge, temp, 'rows'); 
    else
        all_size = [all_size size_temp(1)];
        edge = setdiff(edge, temp, 'rows'); 
        minp = [minp; min(temp,[],1)];
        maxp = [maxp; max(temp,[],1)];
    end
end

% ������򣬲��Խ��������ȷ����minp��maxp��ԭͼ������ʾ
% figure;
% imshow(rgbim);
% hold on;
% size_p = size(minp);
% for i = 1:size_p(1)
%     rectangle('Position',[minp(i,2) minp(i,1) maxp(i,2)-minp(i,2) maxp(i,1)-minp(i,1)],'LineWidth',1,'EdgeColor','b');
%     % ����������������������������ɾ��
%     txt = num2str(i);
%     text(minp(i,2),minp(i,1),txt,'Color','blue','FontSize',10);
% end
% hold off;

%����xml������minp��maxp����xml
xml_folder = 'VOC2007';
if ~isempty(minp)
    xml(xml_dst_path,xml_folder,filename,image_size,minp,maxp);
end
