cs = require 'cs'
cs.Context.setStandard()

# ---------------------------------
# app

# furniture

background = new Layer
	size: Screen.size
	backgroundColor: '#e3e3e3'

header_bar.bringToFront()
header_bar.width = Screen.width
header_bar.height = header_bar.height * 2
header_bar.x = 0
header_bar.y = 0

topCopy = new cs.H1
	text: 'Your credit score and report. For free, forever.'
	y: 250
	x: 857
	width: 530
	fontWeight: 400
	textAlign: 'center'
	
resize = => 
	background.
	header_bar.width = Screen.width
	

betterResize = Utils.debounce(.1, resize)

window.addEventListener "resize", betterResize