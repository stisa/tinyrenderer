import strutils

type Vertex* = tuple[x,y,z:float]
type IntVertex* = tuple[x,y,z:int]
type Face* = tuple[v,vt,vn:IntVertex]

type ObjModel* = object
  verts* : seq[Vertex]
  normals* : seq[Vertex]
  tangents* : seq[Vertex]
  faces* : seq[Face] # vertex/vertextexture/vertexnormal

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
  
  var i = 0
  var header : string = ""

  for ln in obj.strip.splitLines:
    inc i
    let sln = ln.split(" ")
    if sln.len == 0 : continue # skip comments
    header = sln[0].strip
    if header == "#" : continue
    if header in ["vt", "vn", "g", "s"]: continue # skip unimplemented
    assert(sln.len == 4, "Wrong vertex length at line: "& $i & "> " & $sln)
    if header == "v" : # vertex
      result.verts.add( (sln[1].parsefloat,sln[2].parsefloat,sln[3].parsefloat) )    
    elif header == "f" : # face
      let v1 = sln[1].split("/")
      let v2 = sln[2].split("/")
      let v3 = sln[3].split("/")
      result.faces.add( 
        (( v1[0].parseint - 1, v2[0].parseint - 1, v3[0].parseint - 1 ), # v
         ( v1[1].parseint - 1, v2[1].parseint - 1, v3[1].parseint - 1 ), # vt
         ( v1[2].parseint - 1, v2[2].parseint - 1, v3[2].parseint - 1 )) # vn
      )    
    else: doassert(false,"Unknown line prefix: "&ln)

proc loadObj*(f:string):ObjModel = f.loadObjString.parseObj

when ismainmodule:
  echo parseObj(r"""
v 0.388341 0.404485 0.306953
v 0.355059 0.467372 0.356967
f 712/733/712 720/738/720 721/739/721
f 712/733/712 721/739/721 713/730/713
  """)