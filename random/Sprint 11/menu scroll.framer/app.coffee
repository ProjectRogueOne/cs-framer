cs = require 'cs'
cs.Context.setMobile()
{SafariBar} = require 'SafariBar'
# Page Setup
Screen.backgroundColor = cs.Colors.page
Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()

Screen.backgroundColor = 'FFF'

bg = new Layer
	size: Screen.size
	backgroundColor: '#ccc'

page = new cs.StackView
	opacity: 0

new SafariBar

toolbar = new Layer
	width: Screen.width
	height: 45
	y: Align.bottom
	backgroundColor: 'rgba(248, 248, 248, 1.000)'
	shadowY: -1
startY = 162

closeButton = new cs.Icon
	icon: 'close'
	x: Align.right(-20)
	y: 85
	opacity: 0

closeButton.onTap -> close()

open = new cs.Icon
	icon: 'menu'
	x: 20
	y: 85

open.onTap -> open()

buttons = []

for label, i in ['home', 'about', 'blog', 'learn', 'careers', 'help']
	button = new cs.Large
		parent: page
		fill: 'transparent'
		text: _.capitalize(label)
		type: 'large'
		y: startY
		x: 125
		height: 22
		opacity: 0
	
	buttons.push(button)
	
	startY = button.maxY + 20
	
signup = new cs.Button 
	parent: page
	y: startY + 10
	x: 125
	size: 'auto'
	color: 'white'
	type: 'large'
	text: 'Sign up'
	opacity: 0
	

login = new cs.Button 
	parent: page
	y: signup.maxY + 20
	x: 125
	size: 'auto'
	type: ''
	fill: 'transparent'
	color:  'primary'
	border: 'primary'
	type: 'large'
	text: ' Log in '
	opacity: 0
	

open = ->
	
	page.animate
		opacity: 1, 
		options: 
			time: .32
	for button, i in buttons
		button.animate
			opacity: 1
			options:
				time: .44
				delay: .2 + (i * .04)
	
	signup.animate
		opacity: 1, 
		options:
			time: .36
			delay: .4
			
	login.animate
		opacity: 1, 
		options:
			time: .36
			delay: .44
			
	closeButton.animate
		opacity: 1
		options:
			time: .36
			

close = ->	
	page.animate
		opacity: 0, 
		options:
			time: .32
			delay: .15
			
	for button, i in _.reverse(buttons.slice())
		button.animate
			opacity: 0
			options:
				time: .24
				delay: (i * .02)
	
	signup.animate
		opacity: 0, 
		options:
			time: .24
			
	login.animate
		opacity: 0, 
		options:
			time: .24
			
	closeButton.animate
		opacity: 0
		options:
			time: .24

# # ---------------------------------
# # TextField
# 
# page.addToStack new cs.TextField
# 	placeholder: 'testing'
# 	border: 'black'
# 	leftIcon: 'information-outline'
# 	rightIcon: 'eye'
# 
# # ---------------------------------
# # Text
# 
# # Text Type
# 
# page.addToStack new new cs.Text
# 	type: 'caption'
# 
# page.addToStack new new cs.Text
# 	type: 'body'
# 
# page.addToStack new new cs.Text
# 	type: 'body1'
# 
# page.addToStack new new cs.Text
# 	type: 'button'
# 
# page.addToStack new new cs.Text
# 	type: 'link'
# 
# page.addToStack new new cs.Text
# 	type: 'subheader'
# 
# page.addToStack new cs.Divider
# 
# # Text Color
# 
# page.addToStack new new cs.Text
# 	color: 'primary'
# 	text: 'Primary'
# 
# page.addToStack new new cs.Text
# 	color: 'secondary'
# 	text: 'Secondary'
# 
# page.addToStack new new cs.Text
# 	color: 'tertiary'
# 	text: 'Tertiary'
# 
# page.addToStack new new cs.Text
# 	color: 'accent'
# 	text: 'Accent'
# 
# page.addToStack new new cs.Text
# 	color: 'grey'
# 	text: 'Grey'
# 
# page.addToStack new new cs.Text
# 	color: 'white'
# 	text: 'White'
# 
# page.addToStack new new cs.Text
# 	color: 'black'
# 	text: 'Black'
# 	
# page.addToStack new new cs.Text
# 	color: 'disabled'
# 	text: 'Disabled'
# 
# page.addToStack new cs.Divider
# 
# # Text Actions
# 
# page.addToStack new new cs.Text
# 	type: 'link'
# 	text: 'Click Here!'
# 	action: -> @text = 'Clicked!'
# 
# page.addToStack new cs.Divider
# 
# # ---------------------------------
# # Buttons
# 
# # Button Actions
# 
# page.addToStack new cs.Button
# 	action: -> @text = 'Tapped!'
# 
# page.addToStack new cs.Divider
# 
# # Button Sizes
# 
# page.addToStack new cs.Button
# 	size: 'small'
# 
# page.addToStack new cs.Button
# 	size: 'medium'
# 
# page.addToStack new cs.Button
# 	size: 'large'
# 
# page.addToStack new cs.Button
# 	size: 'auto'
# 
# page.addToStack new cs.Divider
# 
# # Button Fill
# 
# page.addToStack new cs.Button
# 	fill: 'todo'
# 
# # Button Border
# 
# page.addToStack new cs.Button
# 	fill: 'todo'
# 	border: 'secondary'
# 	
# page.addToStack new cs.Divider
# 
# # Label Text
# 
# page.addToStack new cs.Button
# 	text: 'Click Here!'
# 
# # Label Types
# 
# page.addToStack new cs.Button
# 	text: 'Click Here!'
# 	type: 'body'
# 
# # Label Color
# 
# page.addToStack new cs.Button
# 	text: 'Click Here!'
# 	type: 'body'
# 	color: 'white'
# 
# page.addToStack new cs.Divider
# 
# # Disabled 
# 
# page.addToStack new cs.Button
# 	text: 'Click Here!'
# 	type: 'body'
# 	color: 'white'
# 	disabled: true
