cs = require 'cs'
# cs.Context.setMobile()

# ---------------------------------
# app
	
# Setup

Screen.backgroundColor = cs.Colors.page
Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()
background = new Layer
	image: 'images/site_background_3.png'
	size: Screen.size

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

submitEmail = => 
	email.input.focused = false
	email.disabled = true
	
	load()
			
	Utils.delay 1, =>
		if Math.random() > .5 then showNewUser()
		else showUserHasAccount()

showUserHasAccount = =>
	greeting.text = 'Sign In'
	greeting.animate
		opacity: 1
		options:
			time: .35
	
	loadIcon.animate
		opacity: 0
		options:
			time: .25
				
	
	
	submitButton.animate
		opacity: 1
		y: password.maxY + 32
		
	submitButton.action = login
	submitButton.text = "Log In"
	
	email.disabled = false
	
	password.visible = true
	password.focused = true
	password.animate 
		opacity: 1
		options:
			time: .25
			
showNewUser = =>
	greeting.text = 'Sign Up Free'
	greeting.animate
		opacity: 1
		options:
			time: .35
	
	loadIcon.animate
		opacity: 0
		options:
			time: .25
	
	email.disabled = false
	
	birthday_wrapper.visible = true
	birthday_day.focused = true
	birthday_wrapper.animate 
		opacity: 1
		options:
			time: .25
			delay: .05
	
	password.y = birthday_wrapper.maxY + 32
	password.visible = true
	password.animate 
		opacity: 1
		options:
			time: .25
			delay: .1
	
	agreeToTerms.visible = true
	agreeToTerms.y = password.maxY + 32
	agreeToTerms.animate
		opacity: 1
		options:
			time: .25
			
	submitButton.animate
		opacity: 1
		y: agreeToTerms.maxY + 32
		
	submitButton.action = register
	submitButton.text = "Sign Up for Free"

register = =>
	load()
	email.disabled = true
	password.disabled = true
	birthday_wrapper.opacity = .5
	
	Utils.delay 1, =>
		submitButton.animate
			opacity: 0
			options:
				time: .4
		
		password.animate
			opacity: 0
			options:
				time: .4
				delay: .1
				
		birthday_wrapper.animate
			opacity: 0
			options:
				time: .4
				delay: .2
				
		email.animate
			opacity: 0
			options:
				time: .4
				delay: .3
		
		greeting.animate
			opacity: 0
			options:
				time: .4
				delay: .4
				
	Utils.delay 2, reload

login = =>
	load()
	email.disabled = true
	password.disabled = true
	
	Utils.delay 1, =>
		submitButton.animate
			opacity: 0
			options:
				time: .4
		
		password.animate
			opacity: 0
			options:
				time: .4
				delay: .1
		
		email.animate
			opacity: 0
			options:
				time: .4
				delay: .2
		
		greeting.animate
			opacity: 0
			options:
				time: .4
				delay: .3
				
	Utils.delay 2, reload

reload = -> window.location.reload()

# ####################
# Layers

container = new Layer
	width: 426
	height: 50
	x: Align.ce

# Email Field
email = new cs.Field
	name: 'Email'
	parent: container
	placeholder: 'Enter your e-mail'

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
