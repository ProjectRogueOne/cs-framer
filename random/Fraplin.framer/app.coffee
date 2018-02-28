# @steveruizok
{ fraplin } = require "fraplin"


# Press ` to enable mode; press ` again to disable it.


Screen.backgroundColor= '#FFF'
layer = new Layer
	height: 100
	width: 100, y: 258, x: 10, backgroundColor: "rgba(131,72,23,0.5)"

layer = new Layer
	height: 100
	width: 100, y: 258, x: 257

layer = new Layer
	height: 100
	width: 100, y: 38, x: 24


layer = new Layer
	height: 100
	width: 100, y: 82, x: 60
layer = new Layer
	height: 100
	width: 100, y: 82, x: 238
layer = new Layer
	height: 100
	width: 100, y: 38, x: 257

layer = new Layer
	name: 'big border'
	height: 100
	width: 100
	x: 129, y: 308
	borderRadius: 4
	borderWidth: 10

layer = new Layer
	name: 'square'
	height: 100
	width: 100
	x: 60, y: 439
	borderRadius: 4

layer = new Layer
	name: 'hi'
	height: 100
	width: 100
	x: 207, y: 439
	borderRadius: 4
	
layer = new Layer
	name: 'hey'
	height: 100
	width: 100
	x: 238, y: 489
	borderRadius: 4



layerB = new Layer
	height: 100
	width: 100
	x: 26, y: 486, scale: 1.05
	shadowX: 1
	shadowY: 3
	shadowBlur: 6
	shadowColor: 'rgba(0,0,0,.30)'
