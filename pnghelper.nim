#
#
#              The Nim Forum
#        (c) Copyright 2012 Andreas Rumpf, Dominik Picheta
#        Look at license.txt for more info.
#        All rights reserved.
#

import os, strutils
from nimPNG import savepng32

type Color* = uint32
type Image* = object
  data: seq[Color]
  height*,width*:int

const
  ## Common colors used for testing
  Transparent* = Color(0x00000000)
  Black* = Color(0x000000FF)
  Blue* = Color(0x0000FFFF)
  Green* = Color(0x00FF00FF)
  Red* = Color(0xFF0000FF)
  Purple* = Color(0xFF00FFFF)
  White* = Color(0xFFFFFFFF)
  HalfTBlack* = Color(0x00000088) ## HalfT<Color> colors are <color> at half alpha
  HalfTBlue* = Color(0x0000FF88)
  HalfTGreen* = Color(0x00FF0088)
  HalfTRed* = Color(0xFF000088)
  HalftWhite* = Color(0xFFFFFF88)

proc `$`*(c:Color):string =
  result = "    "
  result[0] = cast[uint8](c shr 24).char
  result[1] = cast[uint8](c shr 16).char
  result[2] = cast[uint8](c shr 8).char
  result[3] = cast[uint8](c shr 0).char

proc `[]=`*(im:var Image,x,y:int,val:Color) =
  #assert(j*im.width+i < im.data.len, $(j*im.width+i) & "is greater than " & $im.data.len)
  if y<0 or x<0 or y>=im.height or x>=im.width: 
    when defined debug: echo "tried to draw out of image, skipping"
    return
  #assert(j*im.width+i >= 0, $(j*im.width+i) & "is less than 0")
  im.data[y*im.width+x] = val

proc initImg*(w,h:int) :Image =
  result.width = w
  result.height = h
  result.data = newSeq[Color](w*h)

proc fillWith*(img: var Image,color:Color=Color(0xFFFFFFFF)) =
  ## Loop over every pixel in `img` and sets its color to `color` 
  for pix in img.data.mitems: pix = Color(color) 

proc saveTo*(img:Image,filename:string) =
  ## Convience function. Saves `img` into `filename`
  var dt :string = ""
  for d in img.data:
    dt.add($d) 
  if not filename.savepng32(
    dt,img.width,img.height
  ): echo "todo: error saving"


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