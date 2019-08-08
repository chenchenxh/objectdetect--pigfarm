from lxml import etree


class GEN_Annotations:
    def __init__(self, filename):
        self.root = etree.Element("annotation")

        child1 = etree.SubElement(self.root, "folder")
        child1.text = "VOC2007"

        child2 = etree.SubElement(self.root, "filename")
        child2.text = filename

        child3 = etree.SubElement(self.root, "segmented")
        child3.text = "0"
        # child2.set("database", "The VOC2007 Database")
        # child4 = etree.SubElement(child3, "annotation")
        # child4.text = "PASCAL VOC2007"
        # child5 = etree.SubElement(child3, "database")

        # child6 = etree.SubElement(child3, "image")
        # child6.text = "flickr"
        # child7 = etree.SubElement(child3, "flickrid")
        # child7.text = "35435"

        # root.append( etree.Element("child1") )
        # root.append( etree.Element("child1", interesting="totally"))
        # child2 = etree.SubElement(root, "child2")

        # child3 = etree.SubElement(root, "child3")
        # root.insert(0, etree.Element("child0"))

    def set_size(self,shape):
        width = shape[0]
        height = shape[1]
        depth = shape[2]
        size = etree.SubElement(self.root, "size")
        widthn = etree.SubElement(size, "width")
        widthn.text = str(width)
        heightn = etree.SubElement(size, "height")
        heightn.text = str(height)
        channeln = etree.SubElement(size, "depth")
        channeln.text = str(depth)
    def savefile(self,filename):
        tree = etree.ElementTree(self.root)
        tree.write(filename, pretty_print=True, xml_declaration=False, encoding='utf-8')
    def add_pic_attr(self,label,x,y,w,h):
        object = etree.SubElement(self.root, "object")
        namen = etree.SubElement(object, "name")
        namen.text = label
        pose = etree.SubElement(object, "pose")
        pose.text = "unspecified"
        truncated = etree.SubElement(object, "truncated")
        truncated.text = "0"
        difficult = etree.SubElement(object, "difficult")
        difficult.text = "0"
        bndbox = etree.SubElement(object, "bndbox")
        x = int(x)+1
        y = int(y)+1
        w = int(w)+1
        h = int(h)+1
        x = 500 if x==501 else x
        y = 500 if y==501 else y
        w = 500 if w==501 else w
        h = 500 if h==501 else h
        if x<=0 or y<=0 or w<=0 or h<=0 or x>500 or y>500 or w>500 or h>500:
            print(x,y,w,h)
        xminn = etree.SubElement(bndbox, "xmin")
        xminn.text = str(x)
        yminn = etree.SubElement(bndbox, "ymin")
        yminn.text = str(y)
        xmaxn = etree.SubElement(bndbox, "xmax")
        xmaxn.text = str(w)
        ymaxn = etree.SubElement(bndbox, "ymax")
        ymaxn.text = str(h)
