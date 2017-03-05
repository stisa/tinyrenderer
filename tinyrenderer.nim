#
#
#              The Nim Forum
#        (c) Copyright 2012 Andreas Rumpf, Dominik Picheta
#        Look at license.txt for more info.
#        All rights reserved.
#

import os, strutils, jester
from nimPNG import savepng32

proc getCaptchaFilename*(i: int): string {.inline.} =
  result = "public/captchas/capture_" & $i & ".png"

proc getCaptchaUrl*(req: Request, i: int): string =
  result = req.makeUri("/captchas/capture_" & $i & ".png", absolute = false)

type Color = uint32
type Image = object
  data: seq[Color]
  height,width*:int

const
  ## Common colors used for testing
  Transparent = Color(0x00000000)
  Black = Color(0x000000FF)
  Blue = Color(0x0000FFFF)
  Green = Color(0x00FF00FF)
  Red = Color(0xFF0000FF)
  Purple = Color(0xFF00FFFF)
  White = Color(0xFFFFFFFF)
  HalfTBlack = Color(0x00000088) ## HalfT<Color> colors are <color> at half alpha
  HalfTBlue = Color(0x0000FF88)
  HalfTGreen = Color(0x00FF0088)
  HalfTRed = Color(0xFF000088)
  HalftWhite = Color(0xFFFFFF88)
import pnghelper

proc drawline*(srf:var Image, x1,y1,x2,y2:int, color : Color = Red) =
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
