cs = require 'cs'
cs.Context.setStandard()

# ---------------------------------
# app

state = "start"


testBos = new Layer
	perspective: 120
	rotationX: 14
	rotationZ: -15
	rotationY: 29
	width: 1800
	backgroundColor: null
	x: -117
	y: 53
	
test = new VideoLayer
	parent: testBos
	video: 'images/recording_low.mov'
	width: 956
	height: 720
	scale: .365
	scaleY: 1.2

test.player.autoplay = true
test.player.loop = true

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
	
iPad = new Layer
	image: laptop_static.image
	height: 616
	width: 802
	x: 85
	y: 226


window.addEventListener "resize", resize

