cs = require 'cs'
# cs.Context.setMobile()

# ---------------------------------
# app
	
# Setup

Screen.backgroundColor = cs.Colors.page
Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()

# bigHeader = new cs.H1
# 	text: 'Your credit score and report. For free, forever.'
# 	x: 980
# 	y: 200
# 	width: 500
# 	fontWeight: 400

load = =>
	submitButton.text = ''
	submitButton.animate
		opacity: .8
	
	loadIcon.animate
		opacity: 1
		options:
			time: .25
			delay: .15
			
	loadIcon.animate
		rotation: 360
		options:
			repeat: 300
			curve: 'linear'

submitEmail = => null

# ####################
# Layers

background = new Layer
	image: 'images/background_image.png'
	size: Screen.size

header = new Layer
	width: Screen.width
	height: 101
	image: 'images/header_xl.png'

title = new Layer
	width: 656
	height: 128
	image: 'images/title_centered.png'
	x: 389
	y: 143

container = new Layer
	width: 426
	height: 50
	x: Align.center
	y: 308
	backgroundColor: null

# Email Field
email = new cs.Field
	name: 'Email'
	parent: container
	placeholder: 'Enter your e-mail'
	fill: 'white'

email.input.on "submit", submitEmail

# Submit Email Button
submitButton = new cs.Button
	name: 'Get Started'
	parent: container
	x: Align.right
	color: 'white'
	size: 'auto'
	type: 'body'
	text: 'Get Started'
	action: submitEmail

loadIcon = new cs.Icon
	name: 'Loading Icon'
	icon: 'vector-circle-variant'
	parent: submitButton
	x: Align.center
	y: Align.center
	color: 'white'
	opacity: 0
