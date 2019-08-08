参考https://github.com/Paperspace/DataAugmentationForObjectDetection

此代码实现的是图像的左右翻转，上下翻转，共生成四张图像。其他数据增强类型可以在data_augmentation.py添加类型即可。

使用方法：

1. 将数据放入data中（Annotations和JPEGImages两个文件夹）
2. 在results中新建两个文件（Annotations和JPEGImages两个文件夹）

3. 

```python
python3 data_augmentations.py
```

运行即可。



修改数据增强类型和参数：

1. 了解data_aug/data_aug.py中各个函数的意义和参数的意义，根据自己需求将其添加到data_sequence中
2. 在data_augmentation.py中的sequence修改成类似于源代码的quick_start.ipynb的sequence，并修改去掉55行的[i]即可。

