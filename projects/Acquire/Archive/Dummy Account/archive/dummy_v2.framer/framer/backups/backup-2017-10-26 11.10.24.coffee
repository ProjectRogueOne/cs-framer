cs = require 'cs'
cs.Context.setStandard()

# ---------------------------------
# app

# device
Framer.Device.customize
	deviceType: Framer.Device.Type.Tablet
	screenWidth: 1440
	screenHeight: 876
	deviceImage: 'modules/cs-ux-images/safari_device.png'
	deviceImageWidth: 1442	
	deviceImageHeight: 1087
	devicePixelRatio: 1

Framer.Device.screen.y = 62

state = "start"

# ---------------------------------
# Prototype Settings



TEXT_DELAY = 0
# number: the delay between when the new videos start 
#		  and when the text changes

FADE_IN_TIMING = 1
# number: how long the new videos take to fade in 
#		  during a transition

CYCLE_VIDEOS = false
# true, videos will keep changing
# false: videos will end back on dashboard


CHANGE_BOTH_TEXT = true
# true: both lines of text will change (using the
#		typeform effect)
# false: only the second line of text will change
# ---------------------------------

videos = [
	"",
	"dashboard",
	"report",
	"offers",
	"coaching"
]

# If only the second line of text is changi
# Copy to use for second line of text, if only the
# second line is changing.

textEntries = [
	'credit score', 
	'full credit report', 
	'personalised offers', 
	'financial Coaching plans'
	]

# If both lines of text are changing:

# Copy to use for first line of text
firstTextEntries = [
	'See your', 
	'Browse your', 
	'Discover your', 
	'Improve your'
	]

# Copy to use for second line of text
secondTextEntries = [
	'credit score', 
	'full credit report', 
	'personalised offers', 
	'finances with Coaching'
	]

# furniture

background = new Layer
	size: Screen.size
	image: static_v2_image.image

header_bar.bringToFront()
header_bar.width = Screen.width
header_bar.height = header_bar.height * 2
header_bar.x = 0
header_bar.y = 0

topCopy = new cs.H1
	name: 'Top Copy'
	text: 'Your credit score and report. For free, forever.'
	y: 286
	x: 890
	width: 530
	fontSize: 48
	fontWeight: 300
	color: '#FFF'
	textAlign: 'center'


# change text


changeText1 = new cs.H1
	name: 'Copy Text 1'
	text: 'Discover your'
	y: topCopy.maxY + 35
	x: topCopy.x
	width: topCopy.width
	fontSize: 36
	fontWeight: 300
	color: '#FFF'
	textAlign: 'center'

changeText2 = new TextLayer
	name: 'Copy Text 2'
	text: '{value}'
	y: changeText1.y + 50
	x: topCopy.x
	width: topCopy.width
	fontWeight: 300
	color: '#E5A86B'
	textAlign: 'center'

changeText2.template = textEntries[0]

nextText = Utils.cycle(textEntries) 

setNextText = ->
	newText = _.split(nextText(), '')
	string = ""
	for letter, i in newText
		do (letter, i) ->
			Utils.delay (i * .054), ->
				string += letter
				changeText2.text = string + "|"


firstText = Utils.cycle(firstTextEntries)
secondText = Utils.cycle(secondTextEntries)

setBothText = ->
	newFirstText = _.split(firstText(), '')
	newSecondText = _.split(secondText(), '')
	
	firstString = ""
	for letter, i in newFirstText
		do (letter, i) ->
			Utils.delay (i * .038), ->
				firstString += letter
				changeText1.text = firstString + ""
	
	
	firstDelay = i * .054
	
	changeText2.text = ''
	secondString = ""
	for letter, i in newSecondText
		do (letter, i) ->
			Utils.delay (firstDelay + (i * .04)), ->
				secondString += letter
				changeText2.text = secondString + "|"


# video

bigLayer = new Layer
	size: Screen.size
	backgroundColor: null

videoContainer = new Layer
	parent: bigLayer
	rotationX: 14
	rotationZ: 1
	rotationY: -2
	width: 0
	backgroundColor: null
	x: -117
	y: 53
	
video1 = new VideoLayer
	parent: videoContainer
	video: ''
	x: 196, y: 26
	width: 956
	height: 717
	scaleX: .555
	scaleY: .53
	backgroundColor: null
	
video2 = new VideoLayer
	parent: videoContainer
	video: ''
	x: 196, y: 26
	width: 956
	height: 717
	scaleX: .555
	scaleY: .53
	backgroundColor: null

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
	Utils.delay TEXT_DELAY, =>
	
		if CHANGE_BOTH_TEXT then setBothText()
		else  setNextText()
	
Events.wrap(video1.player).on "pause", playNext
Events.wrap(video2.player).on "pause", playNext

playNext()

# sign up button

signUpButton = new cs.Button
	name: 'Signup Button'
	midX: changeText2.midX
	y: Align.bottom(-206)
	size: 'medium'
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

, signUpButton)

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

videoContainer.bringToFront()

