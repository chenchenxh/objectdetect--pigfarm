function xml(folder,filename,disize,dst_path,date)
%mkdir(dst_path);%·��������������

A=imread([folder filename]);
imsize=size(A);
h = imsize(1);w = imsize(2);

hstart = 1; hadd = disize; 
for i = 1:fix(h/disize)
    wstart = 1; wadd = disize;
    for j = 1:fix(w/disize)
        if i == fix(h/disize)
            hadd = disize + mod(h,disize);
        else
            hadd = disize;
        end
        if j == fix(w/disize)
            wadd = disize + mod(w,disize);
        else
            wadd = disize;
        end
        aa = A(hstart:hstart+hadd-1, wstart:wstart+wadd-1, :);
        imwrite(aa,[dst_path date '-' filename(1:length(filename)-4) '-' num2str(i) '-' num2str(j) '.jpg'],'jpg'); %����ÿ��ͼƬ
        wstart = wstart + disize;
    end
    hstart = hstart + disize;
end

%���ݱ����и�Ĵ���
% for i = 1:size
% for j = 1:size
% m_start=1+(i-1)*fix(m/size);
% m_end=i*fix(m/size);
% n_start=1+(j-1)*fix(n/size);
% n_end=j*fix(n/size);
% aa=A(m_start:m_end,n_start:n_end,:); %��ÿ��������
% imwrite(aa,[dst_path num2str(i) '--' num2str(j) '.png'],'png'); %����ÿ��ͼƬ
% end
% end