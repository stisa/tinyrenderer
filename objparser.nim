import strutils
when defined js:
  import ../ajax/src/ajax,dom

type Vertex* = tuple[x,y,z:float]
type IntVertex* = tuple[x,y,z:int]
type Face* = object
  v*,vt*,vn*:IntVertex

type ObjModel* = object
  verts* : seq[Vertex]
  normals* : seq[Vertex]
  tangents* : seq[Vertex]
  faces* : seq[Face] # vertex/vertextexture/vertexnormal

proc `$`*(v:Vertex):string = 
  "v $1 $2 $3" % [$v.x, $v.y, $v.z]

proc `$`*(f:Face):string = 
  "f $1/$2/$3 $4/$5/$6 $7/$8/$9" % [$(f.v.x+1), $(f.vt.x+1), $(f.vn.x+1),
                                    $(f.v.y+1), $(f.vt.y+1), $(f.vn.y+1),
                                    $(f.v.z+1), $(f.vt.z+1), $(f.vn.z+1)]

proc `$`*(om:ObjModel):string =
  result = ""
  for v in om.verts: result.add($v & "\n")
  for f in om.faces: result.add($f & "\n")

proc loadObjString*(f:string):string =
  when defined js:
    var httpRequest = newXMLHttpRequest()

    if httpRequest.isNil:
      window.alert("Giving up :( Cannot create an XMLHTTP instance")
      return
    proc resultcontent(e:Event) =
      if httpRequest.readyState == rsDONE:
        if httpRequest.status == 200:
          result = $(httpRequest.responseText)
        else:
          window.alert("There was a problem with the request.")
    httpRequest.onreadystatechange = resultcontent
    httpRequest.open("GET", f,false)
    httpRequest.send()
  else:
    try:
      result = readFile(f)
    except :
      raise
    
proc parseint(s:string):int =
  if s.len == 0 : 0
  else: strutils.parseint(s) 

proc parseObj(obj:string):ObjModel =
  result.verts = newseq[Vertex]()
  result.faces = newseq[Face]()
  
  var i = 0
  var header : string = ""

  for ln in obj.strip.splitLines:
    inc i
    #echo i
    let sln = ln.strip.splitWhitespace
    #echo sln
    if sln.len == 0 or sln.len == 1 : continue # skip comments
    header = sln[0].strip
    if header == "#" : continue
    if header in ["vt", "vn", "g", "s", " "]: continue # skip unimplemented
    assert(sln.len == 4, "Wrong vertex length at line: "& $i & "> " & $sln & " header:"& header)
    if header == "v" : # vertex
      result.verts.add( (sln[1].parsefloat,sln[2].parsefloat,sln[3].parsefloat) )    
    elif header == "f" : # face
      var v1 = sln[1].split("/")
      var v2 = sln[2].split("/")
      var v3 = sln[3].split("/")
      v1.setLen(3)
      v2.setLen(3)
      v3.setLen(3)
      result.faces.add( 
        Face(v: ( v1[0].parseint - 1, v2[0].parseint - 1, v3[0].parseint - 1 ), 
             vt:( v1[1].parseint - 1, v2[1].parseint - 1, v3[1].parseint - 1 ), 
             vn:( v1[2].parseint - 1, v2[2].parseint - 1, v3[2].parseint - 1 ))
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
  echo loadObj("models/cube.obj")