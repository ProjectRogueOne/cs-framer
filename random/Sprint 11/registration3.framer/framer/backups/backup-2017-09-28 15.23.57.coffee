cs = require 'cs'
# cs.Context.setMobile()

# ---------------------------------
# app
	
# Setup

Screen.backgroundColor = cs.Colors.page
Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()
background = new Layer
	image: 'images/site_background.png'
	size: Screen.size


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
		y: submitButton.y + 82
		
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
			
	submitButton.animate
		opacity: 1
		y: password.maxY + 32
		
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

login_container = new Layer
	name: "Container"
	y: 200
	x: Align.right(-80)
	width: 250
	backgroundColor: null

# Title Copy

greeting = new cs.H1
	parent: login_container
	x: 0
	y: 0
	text: 'Sign in or'
	opacity: 1


# Email Field
email = new cs.Field
	parent: login_container
	name: 'Email'
	y: 82
	placeholder: 'Enter your e-mail'
	x: Align.center

email.input.on "submit", submitEmail

# Submit Email Button
submitButton = new cs.Button
	parent: login_container
	name: 'Get Started'
	x: Align.center
	y: email.maxY + 32
	color: 'white'
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

# Birthday Field
birthday_wrapper = new Layer
	parent: login_container
	name: 'Birthday Wrapper'
	width: submitButton.width
	height: 50
	x: Align.center
	y: submitButton.y
	backgroundColor: null
	opacity: 0
	visible: false
	
birthday_day = new cs.Field
	name: 'Day'
	parent: birthday_wrapper
	placeholder: 'Day'
	opacity: 1

birthday_day.input.width = 55

birthday_month = new cs.Field
	name: 'Month'
	parent: birthday_wrapper
	x: 80
	placeholder: 'Month'
	opacity: 1

birthday_month.input.width = 72

birthday_year = new cs.Field
	name: 'Year'
	parent: birthday_wrapper
	x: 177
	placeholder: 'Year'
	opacity: 1

birthday_year.input.width = 72
	

# Password Field
password = new cs.Field
	parent: login_container
	name: 'Password'
	x: Align.center
	y: email.maxY + 32
	placeholder: 'Enter your Password'
	password: true
	visible: false
	opacity: 0
	rightIcon: 'eye'
	
password.input.on "submit", login

