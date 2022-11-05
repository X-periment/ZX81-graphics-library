## Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s


import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
from scipy.spatial import ConvexHull
import numpy as np



vertices = []
edges = []
edge_faces = []
faces = []
#filename = "viper.txt"
filename = "coriolis.txt"
f = open(filename, "r")
while "\VERTEX" not in f.readline():
    pass
while True:
    line = f.readline()
    if "VERTEX" not in line:
        break
    line2 = line.split("TEX")[1]
    nums = line2.split(",")
    v = []
    for i in range(3):
        v.append(int(nums[i]))
    vertices.append(v)

while "\EDGE" not in f.readline():
    pass
while True:
    line = f.readline()
    if "EDGE" not in line:
        break
    line2 = line.split("GE")[1]
    nums = line2.split(",")
    e = []
    ef = []
    for i in range(2):
        e.append(int(nums[i]))
    for i in range(2,4):
        ef.append(int(nums[i]))
    edges.append(e)
    edge_faces.append(ef)

while "\FACE" not in f.readline():
    pass
while True:
    line = f.readline()
    if "FACE" not in line:
        break
    line2 = line.split("CE")[1]
    nums = line2.split(",")
    face = []
    for i in range(3):
        face.append(int(nums[i]))
    faces.append(face)
f.close()

#print("Edges:")
#for e in edges:
#    print(e)

if filename == "coriolis.txt":
    for i in range(len(faces)):
        for j in range(3):
            faces[i][j]= int(faces[i][j]/4)

#print("Faces:")
#for face in faces:
#    print(face)

nvertices = np.array(vertices)
#print(nvertices)
X = nvertices[:,0]
Y = nvertices[:,1]
Z = nvertices[:,2]

xlen = np.amax(X) -  np.amin(X)
xmax = np.amax(X)
ylen = np.amax(Y) -  np.amin(Y)
ymax = np.amax(Y)
zlen = np.amax(Z) -  np.amin(Z)
zmax = np.amax(Z)

mlen = max([xlen,ylen,zlen])
xToAdd = xlen/2-xmax
yToAdd = ylen/2-ymax
zToAdd = zlen/2-zmax

if filename == "coriolis.txt":
    scale =33/mlen
else:
    scale =40/mlen
#print("scale:", scale)
#print("mlen: ",mlen)

x2 = []
y2 = []
z2 = []
for i in X:
    x2.append(int(scale*(i+xToAdd)))
for i in Y:
    y2.append(int(scale*(i+yToAdd)))
for i in Z:
    z2.append(int(scale*(i+zToAdd)))

vertices = [x2,y2,z2]
#print(vertices)
nvertices = np.array(vertices)
nvertices = nvertices.T

print("\n\n\npoints")
print("point0")
v = nvertices[0]
print("    DEFB ",v[0], ", ",v[1], ", ",v[2], ", 0")
print("point1")
v = nvertices[0]
print("    DEFB ",v[0], ", ",v[1], ", ",v[2], ", 0")
print("point2")
for v in nvertices[2:]:
    print("    DEFB ",v[0], ", ",v[1], ", ",v[2], ", 0")

print("faces")
for face in faces:
    print("    DEFB ",face[0], ", ",face[1], ", ",face[2], ", 0")   
print("endOfPoints")

print("\n\n\npointsSafe")
for v in nvertices:
    print("    DEFB ",v[0], ", ",v[1], ", ",v[2], ", 0")
print("facesSafe")
for face in faces:
    print("    DEFB ",face[0], ", ",face[1], ", ",face[2], ", 0")

print("\n\n\npointsTemp")
for v in nvertices:
    print("    DEFB ",v[0], ", ",v[1], ", ",v[2], ", 0")
print("facesTemp")
for face in faces:
    print("    DEFB ",face[0], ", ",face[1], ", ",face[2], ", 0")  

print("\n\n\nconnections")

for v in edges:
    print("    DEFB ",v[0], ", ",v[1])
print("    DEFB $ff")


print("\n\n\nedgefaces")

for ef in edge_faces:
    print("    DEFB ",ef[0], ", ",ef[1])


print("\n\ndemoStart")
print("\n\n    ld a, ",len(nvertices)+len(faces))
print("    ld (numPointsToRotate), a")
    
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot(*nvertices.T, marker='o', color='k', ls='')
for i, j in edges:
    ax.plot(*nvertices[[i, j], :].T, color='r', ls='-')

plt.show()
