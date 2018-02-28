cs = require 'cs'
# cs.Context.setMobile()

# ####################
# app



CLOSE_BUTTON = true
BLUR = false

# gnail.com error

ERROR_TEXT_ONLY = false
MOVE_BACKGROUND_ON_ERROR = false
FULL_WIDTH_ERROR = false
RIGHT_SIDE_ERROR = false
LEFT_SIDE_ERROR = true



# Setup

Screen.backgroundColor = '#FFF'
Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()

status = 'null'

# ####################
# Functions

# Load
load = (duration = 2, button, callback) =>
	button.textLabel.animate
		opacity: 0
		options:
			time: .15
			
	button.animate
		opacity: .8
	
	loadIcon.parent = button
	loadIcon.x = Align.center
	loadIcon.rotation = 0
	
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
	
	Utils.delay duration, ->
		finishLoad(button)
		callback()

# Finish Load
finishLoad = (button) ->
	loadIcon.animate
		opacity: 0
		options:
			time: .25
			
	button.textLabel.animate
		opacity: 1
		options:
			time: .1
			delay: .25
			
	button.animate
		opacity: 1
		options:
			time: .1
			delay: .25
	

# Submit Email
submitEmail = => 
	email.disabled = true
	if Math.random() > .5 
		load(2, submitButton, showRegistration)
	else 
		load(2, submitButton, showLogin)
	
# Show Registration
showRegistration = ->
	return if status is 'registration'
		 
	if status isnt 'null'
		close()
		Utils.delay .45, showRegistration
		return
	
	
	status = 'registration'
	
	duration = 
		time: .45
	
	background.animate
		y: 100
		blur: 30
		opacity: .6
		options: duration
	
	signinButton.y = agreeToTerms.maxY + 32
	signinButton.text = 'Sign Up Free'
	
	for layer in [
		email, password, 
		signinButton, agreeToTerms
	]
		layer.animateStop()
		layer.visible = true
		layer.animate
			x: Align.center
			opacity: 1
			options: duration
	
	password.focused = true
	email.disabled = false
	
	submitButton.animate
		x: 398
		opacity: 0
		blur: 15
		options: duration
		
	closeButton.animate
		opacity: if CLOSE_BUTTON then 1 else 0
		x: 378
		options: duration
		
	
	

# Show Login
showLogin = ->
	return if status is 'login'
	if status isnt 'null'
		close()
		Utils.delay .45, showLogin
		return
		
	status = 'login'
	
	duration = 
		time: .45
	
	background.animate
		y: 100
		blur: 30
		opacity: .6
		options: duration
		
	signinButton.text = 'Sign In'
	email.disabled = false
	signinButton.y = password.maxY + 32


	for layer in [email, password, signinButton]
		layer.visible = true
		layer.animate
			x: Align.center
			opacity: 1
			options: duration
			
	
	password.focused = true
	password.on "submit", ->
		load(2, signinButton, signin)
	
	submitButton.animate
		x: 398
		opacity: 0
		blur: 15
		options: duration
		
	closeButton.animate
		opacity: if CLOSE_BUTTON then 1 else 0
		x: 378
		options: duration
		

# Sign In

signin = ->
	password.disabled = true
	email.disabled = true
	
	Utils.delay .35, ->
		for layer in [
			email, password, signinButton,
			agreeToTerms, title, signinButton,
			closeButton
			]
		
			layer.animate
				y: layer.y + 32
				opacity: 0
				options: 
					time: .25
					
		background.animate
			opacity: 0
			y: background.y + 100
			
		
		Utils.delay 2, => window.location.reload()

# close
close = ->
	
	status = 'null'

	duration = 
		time: .45
	
	background.animate
		y: 0
		blur: 0
		opacity: 1
		brightness: 100
		options: 
			time: .65
	
	email.animate
		x: 1
		options: duration

	for layer in [password, agreeToTerms, signinButton, agreeToTerms]
		layer.animate
			x: 0
			opacity: 0
			options: duration
	
		Utils.delay duration, ->
			layer.visible = true
	
	email.focused = true
	email.disabled = false
	
	submitButton.animate
		x: 266
		opacity: 1
		blur: 0
		options: duration
		
	closeButton.animate
		opacity: 0
		x: 282
		options: duration



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

# Inputs Container
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
	pattern: (value) ->
		_.includes(value, '@') and
		_.includes(value, 'gnail.com')

email.focused = true
email.on "submit", submitEmail

if ERROR_TEXT_ONLY
	tooltip = new Layer
		height: 50
		width: 200
		backgroundColor: null
		visible: false
		opacity: 0
		animationOptions:
			time: .25
else
	tooltip = new Layer
		x: email.x
		y: email.maxY + 4
		height: 50
		width: container.width
		borderWidth: 1
		borderColor: 'black'
		borderRadius: 4
		backgroundColor: "rgba(255, 251, 245, 1.000)"
		visible: false
		opacity: 0
		animationOptions:
			time: .25
	
do _.bind( ->
	
	@intro = new TextLayer
		parent: @
		x: 16
		y: Align.center
		fontSize: 14
		text: "Did you mean"
		color: 'black'
		
	@fix = new TextLayer
		parent: @
		x: @intro.maxX
		y: Align.center
		padding: {left: 6}
		fontSize: 14
		text: "{email}@gmail.com?"
		color: 'orange'
		textDecoration: 'underline'
		
	@nope = new TextLayer
		parent: @
		x: @fix.maxX + 24
		y: Align.center
		fontSize: 12
		text: "Nope"
		color: '#777'
		
	@set = (email) =>
		@fix.template = _.trimEnd(email.value, '@gnail.com')
		
		@visible = true
		
		if FULL_WIDTH_ERROR
			@width = container.width
			@nope.x = Align.right(-16)
		else
			@nope.x = @fix.maxX + 16
			@width = @nope.maxX + 16
		
		if RIGHT_SIDE_ERROR
			@x = submitButton.screenFrame.x +
			submitButton.width
			@y = submitButton.screenFrame.y
			
			@animate 
				x: submitButton.screenFrame.x +
				submitButton.width + 16
				opacity: 1
				
		else if LEFT_SIDE_ERROR
			@x = email.screenFrame.x -
			@width
			@y = email.screenFrame.y
			
			@animate 
				x: email.screenFrame.x -
				@width - 16
				opacity: 1
		else
			@x = email.screenFrame.x
		
			shift = if ERROR_TEXT_ONLY then -4 else 16
			
			@animate 
				y: email.screenFrame.y + email.height + shift
				opacity: 1
			
		if MOVE_BACKGROUND_ON_ERROR
			background.animate
				y: @height
				options:
					time: .25
					
	@close = =>
		@animate 
			y: email.screenFrame.y + email.height
			opacity: 0
		
		background.animate
			y: 0
			options:
				time: .25

	# close when nope is tapped
	@nope.onTap @close
	@fix.onTap =>
		email.value = 

, tooltip)

email.on "change:matches", (matches) ->
	if matches
		tooltip.set(@)
	else
		tooltip.close()

# Password Field
password = new cs.Field
	name: 'Password'
	parent: container
	y: email.maxY + 32
	placeholder: 'Enter your Password'
	fill: 'white'
	password: true
	visible: false
	opacity: 0

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

# Loading Icon (on submit button)
loadIcon = new cs.Icon
	name: 'Loading Icon'
	icon: 'vector-circle-variant'
	parent: submitButton
	x: Align.center
	y: Align.center
	color: 'white'
	opacity: 0
	
# Agree to Terms
agreeToTerms = new Layer
	parent: container
	height: 16
	y: password.maxY + 32
	width: password.width
	backgroundColor: null
	visible: false
	opacity: 0

checkbox = new cs.Checkbox 
	parent: agreeToTerms
	y: Align.center

label = new cs.Text
	type: 'body1'
	parent: agreeToTerms
	y: Align.center
	x: 32
	text: "I agree to the terms and conditions."


# Sign in Button
signinButton = new cs.Button
	name: 'Sign In'
	parent: container
	y: password.maxY + 32
	color: 'white'
	size: 'medium'
	type: 'body'
	text: 'Get Started'
	visible: false
	opacity: 0
	action: ->
		load(2, signinButton, signin)

# close
closeButton = new cs.Icon
	name: 'Close Button'
	type: 'close'
	parent: container
	x: email.maxX + 32
	y: 12
	color: 'grey'
	opacity: 0

closeButton.onTap close

# signup hit area
signupHitArea = new Layer
	name: 'Sign in Header Button'
	x: 1107
	y: 27
	width: 125
	height: 58
	backgroundColor: null
	
signupHitArea.onTap showRegistration

# login hit area
loginHitArea = new Layer
	name: 'Log in Header Button'
	x: 1232
	y: 27
	width: 109
	height: 58
	backgroundColor: null

loginHitArea.onTap showLogin

# cancelLink = new cs.Text
# 	name: 'Cancel'
# 	parent: container
# 	y: submitButton.maxY + 32
# 	type: 'link'
# 	text: 'Cancel'
# 
