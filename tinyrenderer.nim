import pnghelper,objparser,matutils

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