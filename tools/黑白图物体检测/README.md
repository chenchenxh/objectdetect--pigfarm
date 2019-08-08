# 主函数main.m

可以在里面调用各个其他各个函数，修改最开始的路径即可。包括

1. 分割黑白图（division_code.m）
2. 分割原图（devision_code.m）
3. 识别并生成xml（detect_one_rbg_image_area.m -- xml.m）
4. 将识别后存在猪场的对应的图片复制到JPEGImages文件夹中。（copyf.m）

后面的version 1 是报告中一开始说的整个地图进行识别再切割，应该用不到，可以参考。

