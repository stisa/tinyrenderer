import pnghelper,objparser,matutils

proc line*(srf:var Image, x1,y1,x2,y2:int, color : Color = White) =
  ## Draws a line between x1,y1 and x2,y2. Uses Bresenham's line algorithm.
  #echo("x$1 y$2 x$3 y$4" % [$x1,$y1,$x2,$y2])
  var steep :bool
  var 
    xx1 = x1
    yy1 = y1
    xx2 = x2
    yy2 = y2
  #echo "1 ", xx1
  #echo "2 ",xx2
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

proc wireframe(srf:var Image,m:Objmodel) =
  var 
    v0,v1 :Vertex
    x0,y0,x1,y1 :int
  for f in m.faces:
  
    v0 = srf.center((m.verts[f.v.x]))
    v1 = srf.center((m.verts[f.v.y]))
#  echo v1
    x0 = (v0.x+0.0).int
    y0 = (v0.y+0.0).int
    x1 = (v1.x+0.0).int
    y1 = (v1.y+0.0).int
    srf.line(x0,y0,x1,y1)

    #echo "y->z"
    v0 = srf.center((m.verts[f.v.y ]))
    v1 = srf.center((m.verts[f.v.z]))
    
    x0 = (v0.x+0.0).int
    y0 = (v0.y+0.0).int
    x1 = (v1.x+0.0).int
    y1 = (v1.y+0.0).int
    srf.line(x0,y0,x1,y1)
    
    #echo "z->x"
    v0 = srf.center((m.verts[ f.v.z ]))
    v1 = srf.center((m.verts[f.v.x]))
    
    x0 = (v0.x+0.0).int
    y0 = (v0.y+0.0).int
    x1 = (v1.x+0.0).int
    y1 = (v1.y+0.0).int
    srf.line(x0,y0,x1,y1)
  
proc debugDraw(name:string)=
  var model = loadObj("models/"&name)
  for v in model.verts.mitems:
    scale(rotateZ(v,180.0),200.0)
  writefile("models/" & name & ".txt",$model)
  var img = initImg(480,640)
  img.fillWith(Black)
  img.wireframe(model)
  img.saveto("models/" & name & ".png")

when ismainmodule:
  debugDraw("cube.obj")
  debugDraw("diamond.obj")
  debugDraw("african_head.obj")