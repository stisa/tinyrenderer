import os, strutils, jester
from nimPNG import savepng32
import pnghelper,objparser

proc drawlineOld*(srf:var Image, x1,y1,x2,y2:int, color : Color = Red) =
  ## Draws a line between x1,y1 and x2,y2. Uses Bresenham's line algorithm.
  var dx = x2-x1
  var dy = y2-y1
   
  let ix = if dx > 0 : 1 elif dx<0 : -1 else: 0
  let iy = if dy > 0 : 1 elif dy<0 : -1 else: 0
  dx = abs(dx) shl 1
  dy = abs(dy) shl 1
  var xi = x1
  var yi = y1
  srf[xi,yi] = color
       
  if dx>=dy:
    var err = dy-(dx shr 1)
    while xi != x2:
      if (err >= 0):
        err -= dx
        yi+=iy
      err += dy
      xi += ix
      srf[xi,yi] = color
  else:
    var err = dx - (dy shr 1)
    while yi!=y2:
      if err >= 0:
        err -= dy
        xi += ix
      err += dx
      yi += iy
      srf[xi,yi] = color

proc drawline*(srf:var Image, x1,y1,x2,y2:int, color : Color = Red) =
  ## Draws a line between x1,y1 and x2,y2. Uses Bresenham's line algorithm.
  var steep :bool
  var 
    xx1 = x1
    yy1 = y1
    xx2 = x2
    yy2 = y2
  if abs(xx1-xx2)<abs(yy1-yy2):
    swap(xx1,yy1)
    swap(xx2,yy2)
    steep = true
  if xx1>xx2:
    swap(xx1,xx2)
    swap(yy1,yy2)
  
  let dx = xx2-xx1
  let dy = yy2-yy1
  let de2 = abs(dy)*2
  var e2 = 0
  var y = yy1
  for x in xx1..<xx2:
    if steep:
      srf[y,x] = color
    else:
      srf[x,y] = color
    e2 += de2
    if e2>dx:
      y = if yy2>yy1: y+1 else: y-1
      e2 -= dx*2

proc wireframe*(srf:var Image, om:ObjModel) =
  let w2 = srf.width div 2
  let h2 = srf.height div 2
  var v0,v1:Vertex
  var x0,x1,y0,y1: int
  echo len om.faces
  for f in om.faces:
    # x->y
    assert(om.verts.len>f.v.y, $f.v.y & "  " & $om.verts.len)
    v0 = om.verts[f.v.x]
    v1 = om.verts[f.v.y]
    
    x0 = (v0.x+1.0).int*w2
    y0 = (v0.y+1.0).int*h2
    x1 = (v1.x+1.0).int*w2
    y1 = (v1.y+1.0).int*h2
    srf.drawline(x0,y0,x1,y1)
    # y->z
    v0 = om.verts[ f.v.y ]
    v1 = om.verts[f.v.z]
    
    x0 = (v0.x+1.0).int*w2
    y0 = (v0.y+1.0).int*h2
    x1 = (v1.x+1.0).int*w2
    y1 = (v1.y+1.0).int*h2
    srf.drawline(x0,y0,x1,y1)
    # z->x
    v0 = om.verts[ f.v.z ]
    v1 = om.verts[f.v.x]
    
    x0 = (v0.x+1.0).int*w2
    y0 = (v0.y+1.0).int*h2
    x1 = (v1.x+1.0).int*w2
    y1 = (v1.y+1.0).int*h2
    srf.drawline(x0,y0,x1,y1)
  
when ismainmodule:
  let model = loadObj("models/cube.obj")
  var img = initImg(640,480)
  img.fillWith(Black)
  #img.wireframe(model)
  img.drawline(0,0,640,480)
  img.saveto("models/cube.png")