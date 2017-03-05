from objparser import Vertex, IntVertex, Face, ObjModel
from pnghelper import Image
from math import cos,sin,degtorad

proc scale*(v: var Vertex, s:float=1)=
  v.x = v.x*s
  v.y = v.y*s
  v.z = v.z*s

proc center*(srf:Image,v:Vertex):Vertex =
  result.x = (v.x+srf.width/2)
  result.y = (v.y+srf.height/2)

proc rotateZ*(v : var Vertex,deg:float=45.0): var Vertex=
  let
    c = cos(degtorad(deg))
    s = sin(degtorad(deg))
  v.x = v.x*c-v.y*s
  v.y = v.x*s+v.y*c
  v.z = v.z
  result = v

proc rotateX*(v : Vertex,deg:float=45.0):Vertex=
  let
    c = cos(degtorad(deg))
    s = sin(degtorad(deg))
  result.x = v.x
  result.y = v.y*c+v.z*s
  result.z = v.z*c-v.y*s

proc rotateY*(v : Vertex,deg:float=45.0):Vertex=
  let
    c = cos(degtorad(deg))
    s = sin(degtorad(deg))
  result.x = v.x*c+v.z*s
  result.y = v.y
  result.z = v.z*c-v.x*s

proc rotateYX*(v : Vertex,deg:float=45.0):Vertex=
  result = v.rotateY(deg).rotateX(deg)

proc rotateYX*(v : var Vertex,deg:float=45.0): var Vertex=
  v = v.rotateY(deg).rotateX(deg)
  result = v
