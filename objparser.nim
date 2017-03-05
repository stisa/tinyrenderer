import strutils

type Vertex = tuple[x,y,z:float]
type IntVertex = tuple[x,y,z:int]
type Face = tuple[v,vt,vn:IntVertex]

type ObjModel = object
  verts : seq[Vertex]
  faces : seq[Face] # vertex/vertextexture/vertexnormal

proc `$`*(v:Vertex|IntVertex):string = 
  "v $1 $2 $3" % [$v.x, $v.y, $v.z]

proc `$`*(f:Face):string = 
  "f $1/$2/$3 $4/$5/$6 $7/$8/$9" % [$f.v.x, $f.vt.x, $f.vn.x,
                                    $f.v.y, $f.vt.y, $f.vn.y,
                                    $f.v.z, $f.vt.z, $f.vn.z]

proc `$`*(om:ObjModel):string =
  result = "m: \n"
  for v in om.verts: result.add(" " & $v & "\n")
  for f in om.faces: result.add(" " & $f & "\n")

proc loadObjString*(f:string):string =
  try:
    result = readFile(f)
  except :
    raise

proc parseObj(obj:string):ObjModel =
  result.verts = newseq[Vertex]()
  result.faces = newseq[Face]()

  for ln in obj.strip.splitLines:
    let sln = ln.split(" ")
    assert(sln.len == 4, "Wrong vertex length")
    if sln[0] == "v" : # vertex
      result.verts.add( (sln[1].parsefloat,sln[2].parsefloat,sln[3].parsefloat) )    
    elif sln[0] == "f" : # face
      let v1 = sln[1].split("/")
      let v2 = sln[2].split("/")
      let v3 = sln[3].split("/")
      result.faces.add( 
        (( v1[0].parseint,v2[0].parseint,v3[0].parseint ), # v
         ( v1[1].parseint,v2[1].parseint,v3[1].parseint ), # vt
         ( v1[2].parseint,v2[2].parseint,v3[2].parseint )) # vn
      )    
    else: doassert(false,"Unknown line prefix: "&ln)


when ismainmodule:
  echo parseObj(r"""
v 0.388341 0.404485 0.306953
v 0.355059 0.467372 0.356967
f 712/733/712 720/738/720 721/739/721
f 712/733/712 721/739/721 713/730/713
  """)