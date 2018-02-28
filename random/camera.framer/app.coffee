# Image Upload (for mobile and web)
# @steveruizok

# background

# Having a bug with EXIF data from iPhones - they come out rotated 90deg
# so... here's the quick fix.

if Utils.isMobile()
	background = new Layer
		originY: 0
		originX: 0
		width: Screen.height
		height: Screen.width
		x: Screen.width
		rotation: 90
else
	background = new Layer
		width: Screen.width
		height: Screen.height

# input button

inputButton = new Layer
	x: Align.center
	y: Align.bottom(-32)
	width: 128
	height: 64
	borderRadius: 8
	backgroundColor: '#FFF'
	clip: true
	shadowY: 2
	shadowBlur: 6
	
camera_1 = new Layer
	parent: inputButton
	point: Align.center
	width: 48
	height: 48
	image: "images/camera%20(1).png"

# HTML input

input = document.createElement("input")

_.assign input,
	name: 'Camera Input'
	id: 'cameraInput'
	type: 'file'
	capture: 'camera'
	accept: 'image/*'

_.assign input.style,
	position: 'absolute'
	top: '-10px'
	left: '-20px'
	opacity: '0'
	height: '100px'
	width: '300px'
	zoom: '10'

inputButton._element.appendChild(input)

# Events

input.onchange = ->
	image = input.files[0]
	return if not image?
	
	url = window.URL.createObjectURL(image)
	
	background.image = url