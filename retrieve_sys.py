# work in progress

import multiprocessing
import ifcopenshell
import ifcopenshell.geom
import ifcopenshell.util
import ifcopenshell.util.placement
from ifcopenshell.util.selector import Selector

ifc_file = ifcopenshell.open('cases/duct/duct.ifc')

tree = ifcopenshell.geom.tree()
settings = ifcopenshell.geom.settings()
iterator = ifcopenshell.geom.iterator(settings, ifc_file, multiprocessing.cpu_count())
if iterator.initialize():
    while True:
        tree.add_element(iterator.get_native())
        if not iterator.next():
            break

# elements_1 = tree.select_box((27.6168356029645, 12.8426797812756, 6.015000021553043))
# elements_2 = tree.select_box((28.6, 13.9, 6.5))
# print(elements_1)
# print(elements_2)



element = ifc_file.by_guid("1yqMNkcxH5IOEIJ761u1at")
# matrix = ifcopenshell.util.placement.get_local_placement(element.ObjectPlacement)
# location = list(matrix[:, 3][0:3])
# print(location)

settings = ifcopenshell.geom.settings()
shape = ifcopenshell.geom.create_shape(settings, element)
verts = shape.geometry.verts # X Y Z of vertices in flattened list e.g. [v1x, v1y, v1z, v2x, v2y, v2z, ...]
print(len(verts))