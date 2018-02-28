Framer.Extras.Hints.disable()

# Modules

Type = require 'Type'
{ Flow } = require 'Flow'
{ database } = require 'Database'
{ User } = require 'User'
{ View } = require 'View'
{ Icon } = require 'Icon'

# Colors

# set color overrides
{ colors } = require 'Colors'

_.assign colors,
	
	tint: '#FFF' 		# header link color
	bright: '#FFF'		# header title color
	medium: '#016a94'	# header background color
	
	# modal colors
	modalBackground:'#1a87c6'

	# chat colors
	chatBackground:'#FFF'
	chatFill: '#FAFAFA'
	choiceText: '#0183f3'
	choiceBackground: '#FFF'

	# modal colors
	cta: '#21aa99'
	chosen: '#000'
	suggested: 'rgba(0,0,0,.62)'
	
	# shared styles
	
	border: "#rgba(0,0,0,.2)"

# Helper Functions

Utils.timeUntil = (date) ->
	timeDifference = _.floor((date.getTime() - _.now()) / 60000)
	hours = _.floor(timeDifference / 60)
	minutes = timeDifference - (hours * 60)
	
	return {hours: hours, minutes: minutes}

# ----------------------------------------------
# Data Classes

# ----------------------------------------------

# Create Flow
flow = new Flow
flow.header.backgroundColor = colors.medium
flow.header.statusBar.invert = 100

# Create a User
user = database.user = new User

_.assign user,
	plans: []
	drafts: []


# Main Chat

# ---------------------
# Set up the view

mainChat = new ChatView
	title: 'Main Chat'
	left: 
		icon: 'menu'
	right:
		icon: 'navigation'
	leftAvatar: 
		backgroundColor: 'red'
	rightAvatar: 
		backgroundColor: 'blue'
	padding:
		sameSender: 8
		differentSenders: 24
	leftStyle:
		backgroundColor: colors.chatFill
		color: '#000'
	rightStyle:
		backgroundColor: '#0183f3'
		color: '#FFF'


# ---------------------
# Callbacks

# Stages in the chat are handled by callbacks. A callback is a function
# that is executed by a different function. For example, in Utils.delay(),
# the callback is the function's second argument; it gets executed by
# Utils.delay after the delay expires.

# In our case, each choice has its own callback, a function that handles 
# the next stage of the dialog. When a user makes that choice, its callback
# gets executed, and the conversation moves in the right direction.

# At the bottom of this page, we run greeting() to start us off.

# ---
# Greet the user

greeting = ->
	mainChat.addChat new ChatBubble
		text: 'Hi there'
		
	Utils.delay 1, => askWhat()

# ---
# Ask the user what they want to do

askWhat = ->
	
	drinkChoice = 
		text: "Drinking"
		callback: -> 
			plan.what = "drink"
			plan.choices.what = true
			suggestBar()
	
	eatChoice =
		text: "Eating"
		callback: -> 
			plan.what = "eat"
			plan.choices.what = true
			suggestRestaurant()
	
	mainChat.addChat new TextChoiceBox
		text: "What do you feel like doing?"
		choices: [drinkChoice, eatChoice]

# ---
# Suggest a Place to Drink

suggestBar = ->
		
	# links
	
	diveLink = 
		title: diveBar.name
		subtitle: "A low, low place to drink it off."
		image: diveBar.image
	
	# choices
	
	okChoice = 
		text: "Sure"
		callback: -> 
			plan.where = diveBar
			plan.choices.where = true
			confirmAdded()
			Utils.delay 1, => suggestWhen()
		
	noChoice =
		text: "No way"
		callback: -> confirmNegative()
	
	# add an intro message
	
	mainChat.addChat new ChatBubble
		text: 'How about a drink here?'
		
	# add the link choice box
	
	Utils.delay 1, => 
		mainChat.addChat new LinkChoiceBox
			chatView: mainChat
			link: diveLink
			choices: [noChoice, okChoice]

# ---
# Suggest a Place to Eat

suggestRestaurant = ->
		
	# link
	
	kebabLink = 
		title: kebabTruck.name
		subtitle: "Ask for extra garlic sauce."
		image: kebabTruck.image
		
	# choices
	
	okChoice = 
		text: "Sure"
		callback: -> 
			plan.where = kebabTruck
			plan.choices.where = true
			confirmAdded()
			Utils.delay 1, -> suggestWhen()
		
	noChoice =
		text: "No way"
		callback: -> confirmNegative()
	
	# add an intro message
	
	mainChat.addChat new ChatBubble
		text: 'How about a quick bite?'
		
	# add the link choice box
	
	Utils.delay 1, => 
		mainChat.addChat new LinkChoiceBox
			chatView: mainChat
			link: kebabLink
			choices: [noChoice, okChoice]

# ---
# Suggest a time for the activity

suggestWhen = ->
	
	sevenChoice = 
		text: "7:00PM"
		callback: -> 
			plan.when = new Date()
			plan.when.setHours(19, 0)
			plan.choices.when = true
			confirmTime(plan.when)
	
	eightChoice =
		text: "8:00PM"
		callback: -> 
			plan.when = new Date()
			plan.when.setHours(20, 0)
			plan.choices.when = true
			confirmTime(plan.when)
	
	nineChoice =
		text: "9:00PM"
		callback: -> 
			plan.when = new Date()
			plan.when.setHours(21, 0)
			plan.choices.when = true
			confirmTime(plan.when)
	
	mainChat.addChat new TextChoiceBox
		text: "When would you like to go?"
		choices: [sevenChoice, eightChoice, nineChoice]
		callback: -> askPeople()

# ---
askPeople = ->
	mainChat.addChat new ChatBubble
		text: 'Want to invite some friends?'
	
	Utils.delay 1.5, -> 
		mainChat.addChat new PersonChoiceScroll
			chatView: mainChat
			callback: -> greeting()


# ---
# Confirmations

# confirm a time
confirmTime = (time) ->
	timeOptions =
		hour: "numeric"
		minute: "2-digit"
		hour12: true
		
	timeString = time.toLocaleTimeString([], timeOptions)
	
	mainChat.addChat new ChatBubble
		text: "Ok, you're set for #{timeString.toUpperCase()}."

# confirm that something has been added to the user's plan
confirmAdded = ->
	mainChat.addChat new ChatBubble
		text: Utils.randomChoice([
			"Ok, it's on your plan.", 
			'Added to your plan.', 
			"Right on, that's sorted."
		])

# confirm that something has been added to the user's plan
confirmPeople = (sendInvites) ->
	if sendInvites
		mainChat.addChat new ChatBubble
			text: Utils.randomChoice([
				"Cool, they're added to your plan.", 
				"Ok, I'll send out the invites.", 
				"Ok, I'll invite them."
			])
	else
		mainChat.addChat new ChatBubble
			text: Utils.randomChoice([
				"Cool, we'll keep it to just you.", 
				"Ok, no invites for now.", 
				"Ok, just you for now."
			])

# confirm a positive response
confirmPositive = ->
	mainChat.addChat new ChatBubble
		text: Utils.randomChoice([
			'Sounds good.', 
			'Okay.', 
			'Right on buddy.'
		])

# confirm a negative response
confirmNegative = ->
	mainChat.addChat new ChatBubble
		text: Utils.randomChoice([
			'Ok, sorry.', 
			'My mistake.', 
			'Oops, you got it.'
		])
	
	# start over
	Utils.delay 1, -> askWhat()

# start us off!
greeting()




# ----------------------------------------------
# Start Flow

flow.bringToFront()
flow.showNext(mainChat)