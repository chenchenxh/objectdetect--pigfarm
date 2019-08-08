function copyf(SOURCE_PATH_t, DST_PATH_t, date)
% SOURCE_PATH_t = '0606/Annotations/';%源文件目录  
% DST_PATH_t = '0606/JPEGImages/';%目的文件目录  
  
bigDir = dir([SOURCE_PATH_t '\*.xml']);
for i = 1:length(bigDir)
    filename = bigDir(i).name;
    %newname = ['0426' filename(5:length(filename))];
    %movefile([SOURCE_PATH_t filename],[SOURCE_PATH_t newname]);

    filename = filename(1:length(filename)-4);
    copyfile(['MyData/' date '/Images/' filename '.jpg'],DST_PATH_t);
end

