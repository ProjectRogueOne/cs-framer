### Notes / Todo

REFERENCE:
https://material.io/guidelines/
https://materialdesignicons.com/

###

md = require "md"
Screen.backgroundColor = 'efefef'

# Page

# Pages are scroll componets that hold content. They have a stack view, a refresh function that fires when a page becomes a flow component's current view, and instructions for the header - what what title to show, what buttons to show, and what those buttons should do. They also have some functions to work with a collapsing header.

class Page extends ScrollComponent
	constructor: (options = {}) ->
		
		# stack related
		@_stack = []
		@padding = options.padding ? {
			top: 16, right: 0, 
			bottom: 0, left: 16
			stack: 16
			}
		
		# header settings
		@left = options.left
		@right = options.right
		@title = options.title
		
		super _.defaults options,
			size: Screen.size
			scrollHorizontal: false
			
		@content.backgroundColor = Screen.backgroundColor
		
		# collapsing header related
		@_startScroll = undefined
		@onScrollStart => @_startScroll = @scrollPoint
	
	# add a layer to the stack
	addToStack: (layers = []) =>
		if not _.isArray(layers) then layers = [layers]
		
		for layer in layers
			layer.parent = @content
			layer.x = @padding.left ? 0
			layer.y = @padding.top ? 0
			@stack.push(layer)
		
		@stackView()
	
	# pull a layer from the stack
	removeFromStack: (layer) =>
		_.pull(@stack, layer)
	
	# stack layers in stack, with optional padding and animation
	stackView: (
		animate = false, 
		padding = @padding.stack, 
		top = @padding.top, 
		animationOptions = {time: .25}
	) =>
	
		for layer, i in @stack
			
			if animate is true
				if i is 0 then layer.animate
					y: top
					options: animationOptions
					
				else layer.animate
					y: @stack[i - 1].maxY + padding
					options: animationOptions
			else
				if i is 0 then layer.y = top
				else layer.y = @stack[i - 1].maxY + padding
				
		@updateContent()
	
	# build with page as bound object
	build: (func) -> do _.bind(func, @)

	# refresh page
	refresh: -> null
	
	@define "stack",
		get: -> return @_stack
		set: (layers) ->
			layer.destroy() for layer in @stack
			@addToStack(layers)
			
	
# #####################################	

accounts = [
	'courneyportnoy@aol.com',
	'jonny@apple.com'
]

page = new Page

email = new md.TextField
	parent: page
	x: Align.center
	y: Align.center
	labelText: 'E-mail'
	inputType: 'email'
	pattern: (value) -> _.includes(accounts, value)
	animationOptions: { time: .25 }
	
loading = new Layer
	x: Align.center
	y: Align.center(14)
	width: 10
	height: 1
	backgroundColor: 'blue'
	opacity: 0
	
loading.on "change:width", -> loading.x = Align.center
	
Utils.delay .5, => email.focus()
12/
email.on "change:value", (value, matchesPattern) ->
	if _.endsWith(value, '.com')
		currentStep.template = 'When e-mail detected, async to check if account exists.'
		email.disabled = true
		email.animate
			y: Align.center(-64)
			delay: .25
		email.focused = false
		
		loading.opacity = 1
		loading.animate { width: email.width, options: {time: 4, curve: 'linear'}}
		
		Utils.delay 4, =>
			loading.props = {width: 10, opacity: 0}
			if matchesPattern
				currentStep.template = 'If account exists, show login fields.'
				login.bringToFront()
				login.visible = true
				login.animate { opacity: 1 }
				Utils.delay .25, => login.password.focus()
			else
				currentStep.template = 'If account does not exist, show sign up fields.'
				signup.bringToFront()
				signup.visible = true
				signup.animate { opacity: 1 }
				Utils.delay .25, => signup.dateOfBirth.focus()
	else
		currentStep.template = 'User enters e-mail.'
	
# account exists ---> login

login = new Layer
	parent: page
	y: Align.center,
	width: page.width
	backgroundColor: null
	visible: false
	opacity: 0
	animationOptions: { time: .25 }

do _.bind( -> 
	
	@password = new md.TextField
		parent: @
		point: Align.center
		labelText: 'Password'
		inputType: 'password'
	
	# show submit button when password is "valid"
	
	@password.on "change:value", (value) =>
		if value.length > 8
			@submit.visible = true
			@submit.animate
				opacity: 1
				y: Align.center(64)
			
			# submit form when password is entered
			
			@password.on "keyup", (event) =>
				if event.keyCode is 13
					next()
			
			@password.on "change:focused", (isFocused) => 
				if isFocused is false
					next()
	
	# submit form when submit is tapped
	
	@submit = new md.Button
		parent: @
		raised: true
		x: Align.center
		y: Align.center(56)
		text: 'log in'
		visible: false
		opacity: 0
		action: -> next()
		
, login)

	
# account doesnt exist ---> login

signup = new Layer
	parent: page
	y: Align.center,
	width: page.width
	backgroundColor: null
	visible: false
	opacity: 0
	animationOptions: { time: .25 }

do _.bind( -> 
	
	@dateOfBirth = new md.TextField
		parent: @
		point: Align.center
		labelText: 'Date of Birth'
	
	# show 'create password' field when date of birth is entered
	
	@dateOfBirth.on "keyup", (event) =>
		if event.keyCode is 13
			@showPassword()
	
	@dateOfBirth.on "change:focused", (isFocused) => 
		if isFocused is false
			@showPassword()
	
	@showPassword = =>
		event.preventDefault()
		email.animate
			y: Align.center(-128)
			delay: .2
		email.focused = false
		
		@dateOfBirth.disabled = true
		@dateOfBirth.animate
			y: Align.center(-64)
			delay: .25
			
		Utils.delay .3, =>
			@createYourPassword.visible = true
			@createYourPassword.animate { opacity: 1}
			Utils.delay .25, => @createYourPassword.focus()
	
	@createYourPassword = new md.TextField
		parent: @
		x: Align.center
		y: Align.center
		labelText: 'Create Your Password'
		helperText: 'Your password must be 8 characters or more.'
		inputType: 'password'
		visible: false
		opacity: 0
		animationOptions: { time: .25 }
	
	# show submit button when password is 'valid'
	
	@createYourPassword.on "change:value", (value) =>
		if value.length > 8
		
			@createYourPassword.helperText = ''
		
			@submit.visible = true
			@submit.animate
				opacity: 1
				y: Align.center(64)
				
			@createYourPassword.on "keyup", (event) =>
				if event.keyCode is 13
					next()
			
			@createYourPassword.on "change:focused", (isFocused) => 
				if isFocused is false
					next()
	
	# submit form when submit is tapped
	
	@submit = new md.Button
		parent: @
		raised: true
		x: Align.center
		y: Align.center(56)
		text: 'sign up'
		visible: false
		opacity: 0
		action: -> next()
	
, signup)

next = ->
	page.animate
		opacity: 0
		options: { time: .15 }
		
		
# furniture

validEmailsLabel = new md.Caption
	text: 'Valid Emails:'
	width: Screen.width - 32
	x: 16
	y: 16

validEmails = new md.Regular
	width: Screen.width - 32
	text: 'courneyportnoy@aol.com, jonny@apple.com'
	x: 16
	y: validEmailsLabel.maxY + 8

currentStepLabel = new md.Caption
	text: 'Current Step:'
	width: Screen.width - 32
	x: 16
	y: validEmails.maxY + 16

currentStep = new md.Regular
	text: '{step}'
	width: Screen.width - 32
	x: 16
	y: currentStepLabel.maxY + 8
	
currentStep.template = 'User lands on page, email field focuses.'
	
