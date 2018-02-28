cs = require 'cs'
cs.Context.setStandard()


# ---------------------------------
# app

# css

Utils.insertCSS(
	""".ityped-cursor {
	    font-size: 2.2rem;
	    opacity: 1;
	    -webkit-animation: blink 0.4s infinite;
	    -moz-animation: blink 0.4s infinite;
	    animation: blink 0.4s infinite;
	    animation-direction: alternate;
	    color: #FFF;
	}
	
	@keyframes blink {
	    100% {
	        opacity: 0;
	    }
	}
	
	@-webkit-keyframes blink {
	    100% {
	        opacity: 0;
	    }
	}
	
	@-moz-keyframes blink {
	    100% {
	        opacity: 0;
	    }
	}
	"""
)

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

# ---------------------------------
# Prototype Settings

TYPE_DELAY = .1
# number: time between adding characters

DELETE_DELAY = 0.05
# number: time between deleting characters

BETWEEN_DELAY = .8
# numnber: time between delete and add

TEXT_DELAY = 0
# number: the delay between when the new videos start 
#	and when the text changes

TEXT_DELAY = 0
# number: the delay between when the new videos start 
#	and when the text changes

FADE_IN_TIMING = .8
# number: how long the new videos take to fade in 
#	during a transition

CYCLE_VIDEOS = false
# true, videos will keep changing
# false: videos will end back on dashboard

CHANGE_BOTH_TEXT = true
# true: both lines of text will change (using the
#	typeform effect)
# false: only the second line of text will change

# ---------------------------------
# Copy

# -

# If only the second line of text is changing:

# Copy to use for second line of text
textEntries = [
	'credit score', 
	'full credit report', 
	'personalised offers', 
	'financial Coaching plans'
	]

# -

# If both lines of text are changing:

# Copy to use for first line of text
firstTextEntries = [
	'See your', 
	'Browse your', 
	'Discover your', 
	'Improve your',
	'See your', 
	]

# Copy to use for second line of text
secondTextEntries = [
	'credit score', 
	'full credit report', 
	'personalised offers', 
	'finances with Coaching',
	'credit score', 
	]

# ---------------------------------
# Names of the videos to cycle through

videos = [
	"",
	"credit_score",
	"report",
	"offers",
	"coaching"
]

newFirstText = undefined
newSecondText = undefined
currentTextLength = undefined

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
	midX: topCopy.midX
	width: 300
	fontSize: 36
	fontWeight: 300
	color: '#FFF'
	textAlign: 'center'
	text: if CHANGE_BOTH_TEXT is false then 'Discover your' else ' '

changeText2 = new TextLayer
	name: 'Copy Text 2'
	text: '{value}'
	y: changeText1.y + 50
	x: topCopy.x
	width: topCopy.width
	fontWeight: 300
	color: '#E5A86B'
	textAlign: 'center'
	text: ' '

currentText = ''

cursor = document.createElement('span')
cursor.classList.add('ityped-cursor')
cursor.textContent = "|"

# - single line of changing text

nextText = Utils.cycle(textEntries) 

clearSingleLine = ->
	letters = _.split(changeText2.text, '')
	text = changeText2.text
	
	for letter, i in letters
		do (i) ->
			Utils.delay (i * DELETE_DELAY), ->
				changeText2.text = text.substring(0, letters.length - i - 1)
				
				if changeText2.text is ''
					changeText2.text = ' '
				else
					changeText2._element.childNodes[1].childNodes[0].appendChild(cursor)
	
# 	Utils.delay letters.length * DELETE_DELAY + BETWEEN_DELAY, ->
# 		setSingleLine()

setSingleLine = ->
	string = ""
	
	for letter, i in newFirstText
		do (letter, i) ->
			Utils.delay (i * TYPE_DELAY), ->
				string += letter
				changeText2.text = string
				changeText2._element.childNodes[1].childNodes[0].appendChild(cursor)



firstText = Utils.cycle(firstTextEntries)
secondText = Utils.cycle(secondTextEntries)


# - two lines of changing text

# clear second line

clearSecondLine = ->
	text = changeText2.text
	letters = _.split(text, '')
	
	for letter, i in letters
		do (i) ->
			Utils.delay (i * DELETE_DELAY), ->
				changeText2.text = text.substring(0, letters.length - i - 1)
				
				if changeText2.text is ''
					changeText2.text = ' '
				else
					changeText2._element.childNodes[1].childNodes[0].appendChild(cursor)
				
	Utils.delay letters.length * DELETE_DELAY, ->
		clearFirstLine()

# clear first line

clearFirstLine = ->
	text = changeText1.text
	letters = _.split(text, '')
	
	for letter, i in letters
		do (i) ->
			Utils.delay (i * DELETE_DELAY), ->
				changeText1.text = text.substring(0, letters.length - i - 1)
				
				if changeText1.text is ''
					changeText1.text = ' '
				else
					changeText1._element.childNodes[1].childNodes[0].appendChild(cursor)
				
	
# 	Utils.delay (letters.length * DELETE_DELAY) + BETWEEN_DELAY, ->
# 		setFirstText()

# set both text lines

getNewText = ->
	if CHANGE_BOTH_TEXT
		newSecondText = _.split(secondText(), '')
		newFirstText = _.split(firstText(), '')
		currentTextLength = newFirstText.length + newSecondText.length
	else
		newFirstText = _.split(nextText(), '')
		currentTextLength = newFirstText.length

setBothLines = ->
	firstDelay = 0
	secondDelay = 0
	
	setFirstLine()

setFirstLine = ->
	firstString = ""
	for letter, i in newFirstText
		do (letter, i) ->
			Utils.delay (i * TYPE_DELAY), ->
				firstString += letter
				changeText1.text = firstString + ""
				changeText1._element.childNodes[1].childNodes[0].appendChild(cursor)
	
	firstDelay = i * TYPE_DELAY
	
	Utils.delay firstDelay, ->
		setSecondLine()

setSecondLine = ->
	secondString = ""
	for letter, i in newSecondText
		do (letter, i) ->
			Utils.delay (i * TYPE_DELAY), ->
				secondString += letter
				changeText2.text = secondString + ""
				unless lastInCycle
					changeText2._element.childNodes[1].childNodes[0].appendChild(cursor)
				
# 		Utils.delay (i * TYPE_DELAY) + .15, ->
# 			if lastInCycle
# 				cursor.parentNode.removeChild(cursor)


# video

videoContainer = new Layer
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
	opacity: 0
	
video2 = new VideoLayer
	parent: videoContainer
	video: ''
	x: 196, y: 26
	width: 956
	height: 717
	scaleX: .555
	scaleY: .53
	backgroundColor: null
	opacity: 0


cycleVideos = Utils.cycle(videos)

activePlayer = video1

lastInCycle = false


getTimings = ->
	return if lastInCycle
	
	currentVideoDuration = activePlayer.player.duration
	pauseBetweenTyping = (BETWEEN_DELAY / 2)
	deletingDuration = DELETE_DELAY * currentTextLength
	startDeletingTime = currentVideoDuration - (deletingDuration + pauseBetweenTyping)
	
	Utils.delay startDeletingTime, ->
		if CHANGE_BOTH_TEXT
			clearSecondLine()
		else
			clearSingleLine()


i = 0

loadNext = ->
	# switch the active player
	if activePlayer is video1
		activePlayer = video2
	else
		activePlayer = video1
	
	if CYCLE_VIDEOS
		activePlayer.video = "images/#{cycleVideos()}.mp4"
	else
		if i < (videos.length - 1)
			i++ 
			activePlayer.video = "images/#{videos[i]}.mp4"
			lastInCycle = false
		else
			activePlayer.video = "images/#{videos[1]}.mp4"
			lastInCycle = true

			Events.wrap(video1.player).off "ended", loadNext
			Events.wrap(video2.player).off "ended", loadNext

startText = ->
	Utils.delay BETWEEN_DELAY / 2, =>
		if CHANGE_BOTH_TEXT 
			setBothLines()
		else 
			setSingleLine()

fadeInActive = ->
	
	# start the next video at opacity 0
	activePlayer.opacity = 0
	activePlayer.bringToFront()
	
	# fade in the new active player
	activePlayer.animate
		opacity: 1
		options:
			time: FADE_IN_TIMING

# checkForDeleting = ->
# 	currentVideoDuration = activePlayer.player.duration
# 	pauseBetweenTyping = (BETWEEN_DELAY / 2)
# 	deletingDuration = DELETE_DELAY * currentTextLength
# 	
# 	if activePlayer.player.currentTime
# 	
# 	if deletingDuration >

startDeleting = ->
	if CHANGE_BOTH_TEXT
		clearSecondLine()
	else
		clearSingleLine()

playNext = ->
	getNewText()
	activePlayer.player.play()
	startText()
	fadeInActive()
	getTimings()

Events.wrap(video1.player).on "ended", loadNext
Events.wrap(video2.player).on "ended", loadNext

Events.wrap(video1.player).on "durationchange", playNext
Events.wrap(video2.player).on "durationchange", playNext


# sign up button

signUpButton = new cs.Button
	name: 'Signup Button'
	midX: topCopy.midX
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

# start
videoContainer.bringToFront()


loadNext()
