import strutils

type ObjModel = object
  verts : seq[tuple[x,y,z:float]]
  triangles : seq[tuple[v,vt,vn:int]] # vertex/vertextexture/vertexnormal

proc loadObjString*(f:string):string =
  try:
    result = readFile(f)
  except :
    raise

proc parseObj(obj:string):ObjModel =
  for ln in obj.strip.splitLines:
    let sln = ln.split(" ")
    if sln[0] == "v" : # vertex
      echo sln
    elif sln[0] == "f" : # face
      echo sln
    else: doassert(false,"Unknown line prefix: "&ln)


when ismainmodule:
  echo parseObj(r"""
v 0.388341 0.404485 0.306953
v 0.355059 0.467372 0.356967
f 712/733/712 720/738/720 721/739/721
f 712/733/712 721/739/721 713/730/713
  """)