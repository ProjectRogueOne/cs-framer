cs = require 'cs'
cs.Context.setStandard()

# ---------------------------------
# app

# device
Framer.Device.customize
	deviceType: Framer.Device.Type.Tablet
	screenWidth: 1440
	screenHeight: 1024
	deviceImage: 'modules/cs-ux-images/safari_device.png'
	deviceImageWidth: 1442	
	deviceImageHeight: 1087
	devicePixelRatio: 1

Framer.Device.screen.y = 62

state = "start"

TEXT_DELAY = 0
FADE_IN_TIMING = 1
CYCLE_VIDEOS = false
SHOW_GREY_SLIDER = false

videos = [
	"",
	"dashboard",
	"report",
	"offers",
	"coaching"
]

textEntries = [
	'dashboard', 
	'credit report', 
	'offers', 
	'coaching'
	]
	
# furniture

background = new Layer
	size: Screen.size
	backgroundColor: '#f0f0f0'

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
	

slider = new SliderComponent
	x: 32
	y: Align.bottom(-32)
	width: Screen.width - 64
	visible: 	SHOW_GREY_SLIDER
slider.min = 0
slider.max = 1

slider.on "change:value", ->
	background.backgroundColor = Color.mix('#333', '#FFF', slider.value/slider.max)

# change text

header = new TextLayer
	text: 'Take a look at your'
	fontSize: 32
	fontWeight: 300
	x: 887
	y: 375
	color: '#777'

changeText = new TextLayer
	text: '{value}'
	fontSize: 32
	fontWeight: 300
	x: header.maxX + 4
	y: 375
	fontWeight: 400
	color: '#d22d2e'

changeText.teplate = textEntries[0]

nextText = Utils.cycle(textEntries) 

setNextText = ->
	newText = _.split(nextText(), '')
	string = ""
	for letter, i in newText
		do (letter, i) ->
			Utils.delay (i * .054), ->
				string += letter
				changeText.text = string + "|"


# video

videoContainer = new Layer
	perspective: 120
	rotationX: 14
	rotationZ: -15
	rotationY: 29
	width: 1800
	backgroundColor: null
	x: -117
	y: 53
	
video1 = new VideoLayer
	parent: videoContainer
	video: ''
	width: 956
	height: 720
	scale: .365
	scaleY: 1.2
	backgroundColor: '#FFF'
	
video2 = new VideoLayer
	parent: videoContainer
	video: ''
	width: 956
	height: 720
	scale: .365
	scaleY: 1.2
	backgroundColor: '#FFF'

cycleVideos = Utils.cycle(videos)

activePlayer = video1

i = 0

playNext = ->
	# pause the active player
	activePlayer.player.pause()
	
	# switch the active player
	if activePlayer is video1
		activePlayer = video2
	else
		activePlayer = video1
	
	# start the next video at opacity 0
	activePlayer.opacity = 0
	if CYCLE_VIDEOS
		activePlayer.video = "images/#{cycleVideos()}.mov"
	else
		if i < (videos.length - 1)
			i++ 
			activePlayer.video = "images/#{videos[i]}.mov"
		else
			activePlayer.video = "images/#{videos[1]}.mov"
			Events.wrap(video1.player).off "pause", playNext
			Events.wrap(video2.player).off "pause", playNext
			
	activePlayer.bringToFront()
	activePlayer.player.play()
	
	# fade in the new active player
	activePlayer.animate
		opacity: 1
		options:
			time: FADE_IN_TIMING
	
	# show the next text
	Utils.delay TEXT_DELAY, setNextText
	
Events.wrap(video1.player).on "pause", playNext
Events.wrap(video2.player).on "pause", playNext

playNext()

# email input

emailField = new cs.Field
	x: 930
	y: 468
	size: 'large'
	fill: 'white'
	placeholder: 'Enter your email address'
	pattern: (value) -> 
		_.includes(value, '.com') and
		_.includes(value, '@')
		


# password input

passwordField = new cs.Field
	x: emailField.x
	y: emailField.maxY + 16
	size: 'large'
	fill: 'white'
	placeholder: 'Enter your password'
	password: true

for layer in [emailField, passwordField]
	layer.input.style['text-align'] = 'center'

# terms

termsBox = new cs.Checkbox
	x: emailField.x
	y: passwordField.maxY + 16

termsText = new cs.Text
	x: termsBox.maxX + 16
	y: termsBox.y
	width: 300
	text: 'By clicking sign up you agree to our Terms and that you have read our Data Use Policy'

# sign up button

signUpButton = new cs.Button
	x: emailField.x
	y: emailField.maxY + 32
	size: 'large'
	color: 'white'
	type: 'body'
	text: 'Sign Up'
	fill: '#0592bc'
# 	disabled: true
# 	action: -> emailField.submit()
	
do _.bind( -> #signUpButton

	@loadingLine = new Layer
		name: 'Loading Line'
		height: 4
		width: 0
		x: signUpButton.x
		y: signUpButton.maxY
		backgroundColor: '0592bc'
		
	@on "change:y", =>
		@loadingLine.y = @maxY
	
	@loadingLine.states =
		
		start:
			width: 0
		
		load:
			width: @width


	@states =
		start:
			y: emailField.maxY + 32
		
		registration:
			y: emailField.maxY + 32
		
		login:
			y: passwordField.maxY + 32

, signUpButton)

passwordField.visible = false
termsBox.visible = false
termsText.visible = false
emailField.visible = false

# functions

submitEmail = -> 
	return if not emailField.matches
	
	Utils.delay .1, =>
		if Math.random() > .5
# 			showRegistration()
			loadNext()
		else
			showLogin()

showStart = ->
	state = "start"
	
	signUpButton.animate state
	
	passwordField.visible = false
	termsBox.visible = false
	termsText.visible = false
	
	emailField.focused = true
	
	signUpButton.text = "Sign Up for Free"
	signUpButton.action = submitEmail

showRegistration = ->
	if state is "registration"
		showStart()
		return
		
	state = "registration"

	signUpButton.animate state

	passwordField.visible = false
	termsBox.visible = false
	termsText.visible = false
	
	passwordField.focused = true
	
	signUpButton.text = "Sign Up"
	
	signUpButton.action = loadNext

showLogin = ->
	if state is "login"
		showStart()
		return
		
	state = "login"
	
	signUpButton.animate state
	
	passwordField.visible = true
	termsBox.visible = false
	termsText.visible = false
	
	passwordField.focused = true
	
	signUpButton.text = "Sign In"
	
	signUpButton.action = loadNext


loadNext = ->
	signUpButton.loadingLine.animate "load"
	
	Utils.delay 4, =>
		showStart()
		emailField.value = ""
		emailField.focused = true
		
		termsBox.isOn = false

# header navigation buttons

# signUpHeader = new Layer
# 	x: 1108
# 	y: 25
# 	height: 45
# 	width: 108
# 	backgroundColor: null
# 
# signUpHeader.onTap showRegistration
# 
# loginHeader = new Layer
# 	x: 1231
# 	y: 25
# 	height: 45
# 	width: 108
# 	backgroundColor: null
# 
# loginHeader.onTap showLogin

# events

# emailField.on "change:matches", (matches) =>
# 	signUpButton.disabled = !matches
	
emailField.on "submit", loadNext

signUpButton.y = emailField.y

# 	x: 148
# 	y: -42
# 	rotation: -6

