require 'framework'

# Setup
Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# View Label

addViewLabel = (view, label, hero) ->
	new Label
		parent: view
		y: (app.header?.height ? 8) + 4 
		textAlign: "center"
		width: view.width
		text: label
		color: if hero then green else red

# ----------------
# App

app = new App
	chrome: 'safari'
	title: 'www.clearscore.com'
	contentWidth: 580

user =
	email: 'stevestevestreve@aol.com'
	newUser: undefined
	abandonedEarlier: undefined
	verified: undefined
	emailChanged: false


# Header 

header = new Layer
	y: app.header?.maxY
	x: Align.center()
	width: app.width
	height: app.width * (60/375)
	image: 'images/Header.png'
	opacity: 1

app.header.onChange "height", ->
	header.y = app.header.maxY

# Components

# Toggle Opt In
class ToggleOptIn extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
			backgroundColor: null
			toggled: null
		
		super options
		
		@toggle = new Toggle
			parent: @
			x: Align.right()
			options: ['No', 'Yes']
			toggled: options.toggled
			borderWidth: 2
			borderRadius: 4
			borderColor: yellow
			
		@toggle.maxX = @width - 20
			
		@copy = new Body
			parent: @
			x: 20
			width: @toggle.x - 30
			text: options.text
		
		Utils.define @, "toggled", null
		Utils.linkProperties @toggle, @, 'toggled'
		
		@toggle.on "change:toggled", ->
			@props = 
				borderWidth: 0
				borderRadius: 4
		
		
		@height = @copy.maxY

# Checkbox Opt In

class CheckboxOptIn extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
			backgroundColor: null
		
		super options
		
		@checkbox = new Checkbox
			parent: @
			x: 20
			
		@copy = new Body
			parent: @
			x: @checkbox.maxX + 10
			width: @width - (@checkbox.maxX + 15) - 20
			text: options.text
		
		Utils.define @, "checked", false
		Utils.linkProperties  @checkbox, @, 'checked'
		
		@height = @copy.maxY

# Settings

# x.x.x Settings View

settingsView = new View
	title: 'Loan Amount'
	key: "0.0.x"
	backgroundColor: blue80
	contentInset:
		top: 80
	
		

# user =
# 	monthlyIncome: 1200
# 	homeOwner: true
# 	mortgageInReport: true
# 	mandatory: true

settingsView.onLoad ->
	
	label = new Label
		text: 'User just finished registration'
		parent: @content
		color: white
		
	@newUserToggle = new Toggle
		parent: @content
		y: label.maxY + 8
		toggled: false
		options: ['No', 'Yes']
		showNames: true
		
	label = new Label
		text: 'User skipped last time'
		parent: @content
		color: white
		y: _.last(@content.children).maxY + 16
		
	@abandonedEarlierToggle = new Toggle
		parent: @content
		y: label.maxY + 8
		toggled: false
		options: ['No', 'Yes']
		
	label = new Label
		text: "User previously verified her email address"
		parent: @content
		color: white
		y: _.last(@content.children).maxY + 16
		
	@verifiedEmailToggle = new Toggle
		parent: @content
		y: label.maxY + 8
		toggled: false
		options: ['No', 'Yes']
			
	next = new Button
		parent: @content
		y: _.last(@content.children).maxY + 45
		x: 20
		width: @width - 40
		text: "Start prototype"
	
	next.onTap =>
	
		_.assign user,
			newUser: @newUserToggle.toggled
			abandonedEarlier: @abandonedEarlierToggle.toggled
			verified: @verifiedEmailToggle.toggled
		
		app.showNext(introView)

# 0.0.0 Home View

homeView = new View
	title: 'Framework'
	image: 'images/dashboard.png'
	contentInset:
		top: 80

homeView.onLoad ->
	@content.backgroundColor = null
	@onTap -> app.showNext(settingsView)

# Hero journeys

# 1.0.0 Intro View

introView = new View
	title: 'Intro'
	key: '1.0.0'
	contentInset:
		top: 80
		bottom: 100

introView.onLoad ->
	user.skipped = false
	
	if user.newUser and not user.abandonedEarlier
		# for returning users...
		titleText = "One last thing..."
		bodyText = "Our contact policy is now **opt-in**, meaning that we won't contact you unless you ask us to.\n\nWould you like to set your contact preferences now?"
		primaryCtaText = "Set my contact preferences"
		secondaryCtaText = "Ask me next time"
	else if user.abandonedEarlier
		# for returning users...
		titleText = "One last thing..."
		bodyText = "We weren't able to save your contact preferences earlier. Our contact policy is now **opt-in**, meaning that we won't contact you unless you ask us to.\n\nWould you like to set your contact preferences now?"
		primaryCtaText = "Set my contact preferences"
		secondaryCtaText = "Don't contact me anymore"
	else
		# for returning users...
		titleText = "Let's keep in touch"
		bodyText = "We've updated our contact policy to be **opt-in**, meaning that we won't contact you unless you ask us to.\n\nWould you like to update your contact preferences now?"
		primaryCtaText = "Update my contact preferences"
		secondaryCtaText = "Ask me next time"
	
	# for returning users...
	title = new H3
		parent: @content
		x: 20
		y: 45
		text: titleText
		
	body = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 60
		text: bodyText
	
	Utils.toMarkdown(body)
	
	# Continue
	
	@agree = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: body.maxY + 45
		text: primaryCtaText
		select: -> 
			user.skipped = false
			app.showNext(emailView)
		
	@ignore = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: @agree.maxY + 10
		secondary: true
		text: secondaryCtaText
		visible: user.abandonedEarlier
		select: ->
			user.skipped = true
			app.showNext(changeLaterView)
			
	@askMeNextTime = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: @agree.maxY + 10
		secondary: true
		text: secondaryCtaText
		visible: not user.abandonedEarlier
		select: ->
			user.skipped = true
			app.showNext(homeView)

# 2.0.0 Email Validate View

emailView = new View
	title: 'Validate'
	key: '2.0.0'
	contentInset:
		top: 80
		bottom: 100

	
emailView.onLoad ->
	
	if user.newUser
		# for returning users...
		titleText = "Did we get\nyour email right?"
		bodyText = "First things first: is the email below the one you want to use? If you've changed addresses or prefer a different one, please update your address."
		primaryCtaText = "Yep, that's my email"
	
	else
		# for returning users...
		titleText = "Do we have\nyour email right?"
		bodyText = "First things first: do we still have the right email for you? If you've changed addresses or see a mistake, please update your address."
		validateText = " If you haven't already validated your email, we can send you a new link for that, too."
		primaryCtaText = "Yep, that's my email"

	title = new H3
		parent: @content
		x: 20
		y: 45
		text: titleText
		
	body = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 60
		text: bodyText
		
	@email = new H4
		parent: @content
		x: title.x
		y: body.maxY + 30
		text: user.email[0] + '*******@aol.com'
		color: if user.emailChanged then blue else black
	
	@verifiedStatus = new Body1
		parent: @content
		x: Align.right(-20)
		y: @email.y + 3
		text: 'Verified'
		color: green40
	
	if not user.verified
		
		@verifiedStatus.props =
			text: 'Not Verified'
			color: red
			x: Align.right(-20)
		
		@updateButton = new Button
			parent: @content
			x: 15
			y: @email.maxY + 15
			width: (@width - 50) / 2
			text: "Update my address"
			secondary: true
	
		@verifyButton = new Button
			parent: @content
			x: @updateButton.maxX + 25
			y: @email.maxY + 15
			width: (@width - 50) / 2
			text: "Verify my email"
			secondary: true
			opacity: 1
		
		@linkSent = new Micro
			parent: @content
			y: @verifyButton.maxY
			x: Align.center()
			width: @width - 30
			textAlign: 'right'
			text: "Fab, we've emailed you a verification link"
			color: green
			visible: false
		
	@emailContainer = new Layer
		parent: @content
		y: @sendLink?.maxY ? @updateButton?.maxY
		x: 20
		width: @width - 40
		height: 1
		backgroundColor: null
		clip: true
		animationOptions:
			time: .2
	
	@labelLayer = new Label
		parent: @emailContainer
		x: 0
		y: 1
		text: 'Email'
		
	@emailInput = new TextInput
		parent: @emailContainer
		x: 0
		y: @labelLayer.maxY
		width: @emailContainer.width - 1
		placeholder: 'Enter your current email'
	
	
	# Continue
	@continue = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: _.last(@content.children).maxY + 45
		text: primaryCtaText
	
	if user.verified
		@updateButton = new Button
			parent: @content
			x: 15
			y: @continue.maxY + 10
			width: @width - 30
			text: "Update my address"
			secondary: true
	
	Utils.pin @continue, @emailContainer, 'bottom'
	
	# Events
	
	@updateButton.onSelect =>
		app.showNext(updateEmailView)

	@verifyButton?.onSelect =>
		app.loading = true
		Utils.delay 1, =>
			@verifyButton.opacity = .7
			app.loading = false
			@linkSent.visible = true
	
# 			@props =
# 				text: 'Link sent'
# 				x: Align.right(-20)
# 				textDecoration: null
# 				brightness: 40
				
# 	@sendLink.onSelect ->
# 		app.loading = true
# 		Utils.delay 1, =>
# 			app.loading = false
# 			@props =
# 				text: 'Link sent'
# 				x: Align.right(-20)
# 				textDecoration: null
# 				brightness: 40
		
# 	@updateLink.onSelect =>
# 		app.showNext(updateEmailView)

# 		@emailContainer.animate
# 			y: @sendLink.maxY + 15
# 			height: @emailInput.maxY + 2
	
	@continue.onSelect -> 
		app.loading = true
		Utils.delay .5, =>
			app.loading = false
			app.showNext(permissionsView)

# 3.0.0 Permissions View

permissionsView = new View
	title: 'Contact Permissions'
	key: '1.0.0'
	contentInset:
		top: 80
		bottom: 100


permissionsView.onLoad ->

	contactTypes = [
		{
			title: "Account Updates"
			body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
		}, {
			title: "Content Updates"
			body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
		}, {
			title: "Latest Offers"
			body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
		}
	]
	
	title = new H3
		parent: @content
		x: 20
		y: 45
		text: 'Contact\npermissions'
		
	body = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 60
		text: "Here's where you can choose which types of email you'd like to receive. We sent three types of email: **#{contactTypes[0].title}**, **#{contactTypes[1].title}** and **#{contactTypes[2].title}**."
		
	Utils.toMarkdown(body)
	
	# contact types
	
	start = body.maxY + 30
	
	@contactToggles = contactTypes.map (contactType) =>
		title = new H4
			parent: @content
			y: start
			x: title.x
			width: @width - 60
			text: contactType.title
		
		body = new Body
			parent: @content
			y: title.maxY + 10
			x: title.x
			width: @width - 60
			text: contactType.body
			
		Utils.toMarkdown(body)
			
		contactType.optIn = new ToggleOptIn
			parent: @content
			x: 0
			y: body.maxY + 15
			width: @width
			toggled: null
		
		user[contactType.title] = null
		
		contactType.optIn.on "change:toggled", (toggled) =>
			user[contactType.title] = toggled
			
			@continue.disabled = not _.every(@contactToggles.map (t) -> 
				_.isBoolean(t.toggled))
	
		start = contactType.optIn.maxY + 30
		
		return contactType.optIn
	
	# Continue
		
	@continue = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: _.last(@content.children).maxY + 30
		text: 'Save these preferences'
	
	@continue.disabled = true
	
	# events
	
	@continue.onSelect =>
		app.loading = true
		Utils.delay .5, =>
			app.loading = false
			app.showNext(changeLaterView)
		
# 		if _.every([@optIn1, @optIn2, @optIn3], ['toggled', true])
# # 			app.showNext(changeLaterView)
# 			app.showNext(emailView)
# 			return
# 		

# 4.0.0 Change Later View

changeLaterView = new View
	title: 'Change Later'
	key: '4.0.0'
	contentInset:
		top: 80
		bottom: 100
	
changeLaterView.onLoad =>

	arrow = new Layer
		parent: @content
		y: 13
		width: 53
		height: 173
		image: 'images/arrow.png'
		x: Align.right(-24)
	
	if user.skipped
		title = "Ok, no emails"
		lead = "We won't send you any emails from now on."
	else
		title = "We're good to go"
		lead = "THANKS for updating your settings."
	
	title = new H3
		parent: @content
		x: 20
		y: 45
		text: title
		
	lead = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 100
		text: lead
		
	body = new Body
		parent: @content
		x: title.x
		y: lead.maxY + 15
		width: @width - 100
		text: "Should you change your mind, you can always set these options in your account settings."
		
		
# 	icon = new Icon 
# 		parent: @content
# 		x: Align.right(-30)
# 		y: body.midY - 12
# 		icon: 'account-circle'
	
	# Continue
	
	@agree = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: body.maxY + 45
		text: 'Right on, right on'
	
	@goBack = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: @agree.maxY + 10
		secondary: true
		text: "Go Back"
		
	@goBack.onSelect -> app.showPrevious()
	@agree.onSelect -> app.showNext(homeView)

# Side journeys

# 5.0.0 Update Email View

updateEmailView = new View
	title: 'Update E-Mail Address'
	key: '2.1.0'
	contentInset:
		top: 80
		bottom: 100

updateEmailView.onLoad => 

	title = new H3
		parent: @content
		x: 20
		y: 45
		text: "Email address"
		
	body = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 60
		text: "Enter a new email below. We'll send you a link to verify that it's yours."
	
	@labelLayer = new Label
		parent: @content
		x: 15
		y: body.maxY + 20
		text: 'Your email address'
		
	@emailInput = new TextInput
		parent: @content
		x: 15
		y: @labelLayer.maxY
		width: @width - 30
		placeholder: 'Enter your current email'
		
	@emailInput.value = ''
	
	# Continue
	@continue = new Button
		parent: @content
		x: 15
		width: @width - 30
# 		y: @goBack.maxY + 15
		y: @emailInput.maxY + 35
		text: 'Update my email address'
	
	@continue.disabled = true
		
	@emailInput.on "change:value", (value) =>
		validTypes = ['.com', '.edu', '.org', '.net']
		@continue.disabled = !_.includes(validTypes, value.slice(-4))
	
	
	# Go Back
	@goBack = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: @continue.maxY + 10
		secondary: true
		text: 'Cancel'
	
	@continue.onSelect =>
		app.loading = true
		
		_.assign user,
			verified: false
			emailChanged: true
			email: @emailInput.value
		
		emailView.load()
		
		Utils.delay 1, =>
			app.loading = false
			app.showPrevious()
		
	@goBack.onSelect app.showPrevious
 
app.showNext settingsView