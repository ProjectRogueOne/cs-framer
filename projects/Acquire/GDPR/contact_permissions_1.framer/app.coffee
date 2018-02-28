require 'cs'

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
# 	chrome: null
	title: 'www.clearscore.com'
# 	contentWidth: 580

user =
	email: 'clarence.s.corman@aol.com'
	newUser: false
	abandonedEarlier: false
	verified: false
	emailChanged: false
	showValidateEmail: false


# Header 

header = new Layer
	y: app.header?.maxY
	x: Align.center()
	width: app.width
	height: app.width * (60/375)
	image: 'images/Header.png'
	opacity: 1

app.header?.onChange "height", ->
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


# Settings

# x.x.x Settings View

settingsView = new View
	title: 'Loan Amount'
	key: "0.0.x"
	backgroundColor: blue80
	contentInset:
		top: 80

settingsView.onLoad ->
	# show validation?
		
	label = new Label
		text: "Show email validation"
		parent: @content
		color: white
		
	@showValidateEmailToggle = new Toggle
		parent: @content
		toggled: true
		options: ['No', 'Yes']
	
	# verified email
	Utils.offsetY @content.children, 16
			
	next = new Button
		parent: @content
		x: 16
		y: _.last(@content.children).maxY + 45
		width: @width - 32
		text: "Start prototype"
	
	next.onTap =>
	
		_.assign user,
			showValidateEmail: @showValidateEmailToggle.toggled
		
		app.showNext(policyAgreementView)

# Hero journeys

# 0.0.0 Dashboard View

dashboardView = new View
	title: 'Framework'
	image: 'images/dashboard.png'
	contentInset:
		top: 80

dashboardView.onLoad ->
	@content.backgroundColor = null
	@onTap -> window.location.reload()

# 1.0.0 Policy Agreement View View

policyAgreementView = new View
	title: 'Policy Agreement'
	key: '1.0.0'
	contentInset:
		top: 80
		bottom: 100

policyAgreementView.load = ->
	user.skipped = false
	
	titleText = "Our privacy policy\nhas changed"
	bodyText = "Like the rest of Europe, we've had to change the way we handle our **contact preferences** and our **privacy policy**.\n\nWe've made some human-readable ones too:"
	primaryCtaText = "Agree and Continue"
	
	# for returning users...
	title = new H1
		parent: @content
		x: 20
		y: 32
		text: titleText
		
	body = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 40
		text: bodyText
	
	Utils.toMarkdown(body)
	
	# Privacy Policy link
	
	privacyPolicyLink = new H4Link
		parent: @content
		y: body.maxY + 32
		x: 48
		text: "Privacy Policy"
		color: yellow80
		select: -> app.showNext(privacyPolicyView)
		
	
	contactPolicyLink = new H4Link
		parent: @content
		y: body.maxY + 32
		x: Align.right(-48)
		text: "Contact Policy"
		color: yellow80
		select: -> app.showNext(contactPolicyView)
		
	Utils.distribute([privacyPolicyLink, contactPolicyLink], 'horizontal')

	# Continue
	
	@agree = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: privacyPolicyLink.maxY + 45
		text: primaryCtaText
		select: -> 
			app.showNext(permissionsView)


# 1.1.0 Privacy Policy View

privacyPolicyView = new View
	title: 'Privacy Policy'
	key: '1.1.0'
	contentInset:
		top: 80
		bottom: 100

privacyPolicyView.load = ->
	user.skipped = false
	
	titleText = "Privacy Policy"
	bodyText = Utils.randomText(800, true, true)
	primaryCtaText = "Back"
	
	# for returning users...
	title = new H1
		parent: @content
		x: 20
		y: 32
		text: titleText
		
	body = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 40
		text: bodyText
	
	@updateContent()
	
	# Back
	
	@backContainer = new Layer
		parent: @
		y: Align.bottom()
		width: @width
		height: 64
		backgroundColor: white
		shadowY: -1
	
	@agree = new Button
		parent: @backContainer
		x: 15
		width: @width - 30
		y: 8
		text: primaryCtaText
		select: app.showPrevious

# 1.2.0 Contact Policy View

contactPolicyView = new View
	title: 'Privacy Policy'
	key: '1.1.0'
	contentInset:
		top: 80
		bottom: 100

contactPolicyView.load = ->
	user.skipped = false
	
	titleText = "Contact Policy"
	bodyText = Utils.randomText(800, true, true)
	primaryCtaText = "Back"
	
	# for returning users...
	title = new H1
		parent: @content
		x: 20
		y: 32
		text: titleText
		
	body = new Body
		parent: @content
		x: title.x
		y: title.maxY + 30
		width: @width - 40
		text: bodyText
	
	@updateContent()
	
	# Back
	
	@backContainer = new Layer
		parent: @
		y: Align.bottom()
		width: @width
		height: 64
		backgroundColor: white
		shadowY: -1
	
	@agree = new Button
		parent: @backContainer
		x: 15
		width: @width - 30
		y: 8
		text: primaryCtaText
		select: app.showPrevious

# 2.0.0 Permissions View

permissionsView = new View
	title: 'Contact Permissions'
	key: '2.0.0'
	contentInset:
		top: 80
		bottom: 100

permissionsView.onLoad ->

	contactTypes = [
		{
			title: "Content communication"
			body: "New report, password reset, deleted account, terms and conditions."
		}, {
			title: "Core communication"
			body: "features & news, research, coaching, RTC (weekly update), tips."
		}, {
			title: "Latest Offers"
			body: "Offers and marketing."
			optIn: true
		}
	]
	
	title = new H1
		parent: @content
		x: 20
		y: 32
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
		
		if contactType.optIn
			
			contactType.optIn = new Toggle
				parent: @content
				x: 20
				y: body.maxY + 15
				width: @width - 40
				toggled: null
				options: [
					'No thanks'
					'Send me my offers'
					]
			
			user[contactType.title] = null
			
			contactType.optIn.on "change:toggled", (toggled) =>
				user[contactType.title] = toggled
				
				@continue.disabled = contactType.optIn.value?
		
			start = contactType.optIn.maxY + 30
			
			return contactType.optIn
		
		start = body.maxY + 30
		return body
	
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
		next = if user.showValidateEmail then emailView else confirmationView
		app.showNext(next, .5)
		
# 		if _.every([@optIn1, @optIn2, @optIn3], ['toggled', true])
# # 			app.showNext(changeLaterView)
# 			app.showNext(emailView)
# 			return
# 		

# 3.0.0 Email View

emailView = new View
	title: 'Validate'
	key: '3.0.0'
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

	title = new H1
		parent: @content
		x: 20
		y: 32
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
		text: user.email
		color: if user.emailChanged then blue else black
	
	# Continue
	@continue = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: _.last(@content.children).maxY + 45
		text: primaryCtaText
		select: => app.showNext(confirmationView)
	
	@updateButton = new Button
		parent: @content
		x: 15
		y: @continue.maxY + 10
		width: @width - 30
		text: "Update my address"
		secondary: true
		select: => app.showNext(emailUpdateView)
 
# 3.1.0 Update Email View

emailUpdateView = new View
	title: 'Update E-Mail Address'
	key: '3.1.0'
	contentInset:
		top: 80
		bottom: 100

emailUpdateView.onLoad -> 

	title = new H3
		parent: @content
		x: 20
		y: 32
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
		@continue.disabled = !Utils.isEmail(value)
	
	
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
 
# 4.0.0 ConfirmationView

confirmationView = new View
	title: 'Change Later'
	key: '4.0.0'
	contentInset:
		top: 80
		bottom: 100
	
confirmationView.onLoad ->

	title = "We're good to go"
	lead = "Thanks for updating your settings."
	body = "Should you change your mind, you can always set these options in your account settings."
	
	arrow = new Layer
		parent: @content
		y: 13
		width: 53
		height: 173
		image: 'images/arrow.png'
		x: Align.right(-24)
	
	title = new H1
		parent: @content
		x: 20
		y: 32
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
		text: body
	
	# Continue
	
	@agree = new Button
		parent: @content
		x: 15
		width: @width - 30
		y: body.maxY + 45
		text: 'Right on, right on'

	@agree.onSelect -> app.showNext(dashboardView)

 
app.showNext settingsView
