require 'cs'

SHOW_ALL = true
SHOW_LAYER_TREE = false

# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# Add View Label
addViewLabel = (view, label, hero) ->
	new Label
		parent: view
		x: Align.center
		y: header?.maxY
		text: label
		color: if hero then green else red

# User

user =
	monthlyIncome: 1200
	homeOwner: true
	mortgageInReport: true
	mandatory: true

# ----------------
# App

app = new App
	chrome: 'safari'
	title: 'www.clearscore.com'

# Header 
header = new Layer
	parent: app.header
	y: app.header?.height
	width: app.width
	height: 60
	image: 'images/Header.png'

app.header.height = header.maxY

# Copy Input

copyElement = document.createElement "textarea"
app.header._element.appendChild(copyElement)
copyElement.style.opacity = 0

copyTextLayerToClipboard = (layer) ->
	copyElement.value = layer.text
	copyElement.select()
	document.execCommand('copy')
	copyElement.blur()
	

# Toggle Opt In
class ToggleOptIn extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
			backgroundColor: null
		
		super options
		
		@toggle = new Toggle
			parent: @
			x: Align.right()
			options: ['No', 'Yes']
			
		@toggle.maxX = @width - 20
			
		@copy = new Body
			parent: @
			x: 20
			width: @toggle.x - 30
			text: options.text
		
		Utils.define @, "toggled", false
		Utils.linkProperties @toggle, @, 'toggled'
		
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

# 0.0.0 Home View

homeView = new View
	title: 'Framework'
	image: 'images/dashboard.png'


Utils.bind homeView.content, ->
	@backgroundColor = bg1.alpha(0)

	@onTap -> window.location.reload()

# Hero journeys

# x.x.x Settings View

settingsView = new View
	title: 'Loan Amount'
	padding: {top: 32, left: 20, right: 20}
	contentInset:
		bottom: 100
		

# user =
# 	monthlyIncome: 1200
# 	homeOwner: true
# 	mortgageInReport: true
# 	mandatory: true

Utils.bind settingsView, ->
	addViewLabel(@, 'User Settings', true)
	@content.backgroundColor = blue80
	
	label = new Label
		text: 'Monthly Income'
		parent: @content
		color: white
		
	@monthlyIncomeField = new TextInput
		parent: @content
		y: label.maxY + 8
		width: Screen.width - 40
		placeholder: '£'
		value: 1200
	
	label = new Label
		text: 'Home Owner'
		parent: @content
		color: white
		y: @monthlyIncomeField.maxY + 30
		
	@homeOwnerToggle = new Toggle
		parent: @content
		y: label.maxY + 8
	
	label = new Label
		text: 'Mortgage in Report'
		parent: @content
		color: white
		y: @homeOwnerToggle.maxY + 30
		
	@mortgageInReportToggle = new Toggle
		parent: @content
		y: label.maxY + 8
		
	next = new Button
		parent: @content
		y: @mortgageInReportToggle.maxY + 45
		x: 20
		width: @width - 40
	
	next.onTap =>
		_.assign user,
			monthlyIncome: @monthlyIncomeField.value
			homeOwner: @homeOwnerToggle.toggled
			mortgageInReport: @mortgageInReportToggle.toggled
		
		
		app.showNext(loanAmountView)
	

# 1.0.0 Loan Amount View

loanAmountView = new View
	title: 'Loan Amount'
	padding: {top: 32, left: 20, right: 20}
	contentInset:
		bottom: 100

	
Utils.bind loanAmountView, ->
	addViewLabel(@, '1.0.0', true)
	@backgroundColor = white
	
	@onLoad =>
		for child in @content.children
			child.destroy()
			
		copy = new Body1
			parent: @content
			width: @width - 40
			text: "How much are you interested in borrowing and for how long?"
			
		label = new H4 
			parent: @content
			y: copy.maxY + 15
			text: 'Loan Amount'
		
		@loanAmountField = new TextInput
			parent: @content
			y: label.maxY + 8
			width: (Screen.width - 60) / 2
			placeholder: '£'
			
		label = new H4 
			parent: @content
			x: ((Screen.width - 30) / 2) + 20
			y: copy.maxY + 15
			text: 'Duration'
		
		@durationField = new Select
			parent: @content
			y: label.maxY + 8
			x: label.x
			width: (Screen.width - 45) / 2
			options: [
				'1 Year',
				'3 Year',
				'5 Year'
				'7 Year'
				'10 Year'
			]
		
		if not user.mandatory
			copy = new Body1
				parent: @content
				width: @width - 40
				y: @durationField.maxY + 30
				text: "We can show you results for secured loans that might have lower rates, if you provide an estimate of your house value."
				
			label = new H4 
				parent: @content
				y: copy.maxY + 15
				text: 'House value'
		
		else 
		
			label = new H4 
				parent: @content
				y: @durationField.maxY + 30
				text: 'House value'
		
		@houseValueField = new TextInput
			parent: @content
			y: label.maxY + 8
			width: Screen.width - 40
			placeholder: '£'
	
	
		# mortgage?
		
		if not user.mortgageInReport
			
			label = new H4 
				parent: @content
				y: @houseValueField.maxY + 30
				text: 'Do you currently have a mortgage?'
				
			@mortgageToggle = new Toggle
				parent: @content
				x: 20
				y: label.maxY + 20
				options: [
					'No'
					'Yes'
				]
			
			@mortgageAmountContainer = new Layer
				parent: @content
				width: @width
				y: @mortgageToggle.maxY
				height: 78
				clip: true
				backgroundColor: null
				height: 1
			
			@mortgageAmountLabel = new H4 
				parent: @mortgageAmountContainer
				text: 'Mortgage Amount'
				y: 30
		
			@mortgageAmountField = new TextInput
				parent: @mortgageAmountContainer
				y: @mortgageAmountLabel.maxY + 10
				width: Screen.width - 40
				placeholder: '£'
		
		# Continue
		
		@continue = new Button
			parent: @content
			x: 20
			width: @width - 30
			y: (@mortgageAmountContainer?.maxY ? @houseValueField?.maxY ? @durationField.maxY) + 45
			text: 'Continue'
		
		# set stack
		
		for child, i in @content.children
			if i is 0
				last = child
				continue
				
			Utils.pin(child, last, 'bottom')
			last = child
			
		
		# events 
		@continue.onSelect -> app.showNext(expensesView)
	
		@mortgageToggle?.on "change:toggled", (toggled) =>
			if toggled
				@mortgageAmountContainer.animate
					height: 108
					options:
						time: .15
				return
			
			
			@mortgageAmountContainer.animate
				height: 1
				options:
					time: .15

# 2.0.0 Expenses View

expensesView = new View
	title: 'Expenses'
	padding: {top: 32, left: 20, right: 20}
	contentInset:
		bottom: 100

	
Utils.bind expensesView, ->
	addViewLabel(@, '2.0.0', true)
	@backgroundColor = white
	
	# definitions 
	
	Utils.define @, 'tooMuchSpending', false, @_showTooMuchSpending
	
	@onLoad =>
		for child in @content.children
			child.destroy()
			
		label = new H4 
			parent: @content
			text: 'Total monthly spending'
		
		copy = new Body1
			parent: @content
			width: @width - 40
			y: label.maxY + 5
			text: "This includes your rent payments, household bills, living costs and any other regular spending."
		
		@monthlySpendingField = new TextInput
			parent: @content
			y: copy.maxY + 15
			width: Screen.width - 40
			placeholder: '£'
						      
		@tooMuchSpendingCopy = new Body3
			parent: @content
			width: @width - 40
			y: @monthlySpendingField.maxY + 5
			text: "The total monthly spending amount you’ve entered is more than your monthly income. Is that right?"
			opacity: 0
				
		label = new H4 
			parent: @content
			y: @tooMuchSpendingCopy.maxY + 15
			text: 'Monthly mortgage payments'
		
		copy = new Body1
			parent: @content
			width: @width - 40
			y: label.maxY + 5
			text: "Your mortgage payments only."
			
		@monthlyMortgagePayments = new TextInput
			parent: @content
			y: copy.maxY + 15
			width: Screen.width - 40
			placeholder: '£'
			
			
		# Continue
		
		@continue = new Button
			parent: @content
			x: 20
			y: @monthlyMortgagePayments.maxY + 45
			width: @width - 30
			text: 'Continue'
		
		@continue.onSelect -> app.showNext(resultsView)
		
		# set stack
		
		for child, i in @content.children
			if i is 0
				last = child
				continue
				
			Utils.pin(child, last, 'bottom')
			last = child
			
			
		@_showTooMuchSpending = (bool) =>
			if bool
			# too much spending
				@tooMuchSpendingCopy.animate
					opacity: 1
					options:
						time: .15
				return
				
			@tooMuchSpendingCopy.animate
				opacity: 0
				options:
					time: .15
		# events
		
		@monthlySpendingField.on "change:value", (value) =>
			@tooMuchSpending = value > user.monthlyIncome

	
	
	
	
	
# 	@ignore = new Button
# 		parent: @content
# 		x: 15
# 		width: @width - 30
# 		y: @agree.maxY + 10
# 		secondary: true
# 		text: "Don't contact me"
# 		
# 	@ignore.onSelect -> app.showNext(reenableView)

# 3.0.0 Results View

resultsView = new View
	title: 'Results'
	padding: {top: 32, left: 20, right: 20}
	contentInset:
		bottom: 100

	
Utils.bind resultsView, ->
	addViewLabel(@, '3.0.0', true)
	@backgroundColor = white


	# Continue
	
# 	@continue = new Button
# 		parent: @content
# 		x: 20
# 		y: @monthlyMortgagePayments.maxY + 45
# 		width: @width - 30
# 		text: 'Continue'
	
# 	@ignore = new Button
# 		parent: @content
# 		x: 15
# 		width: @width - 30
# 		y: @agree.maxY + 10
# 		secondary: true
# 		text: "Don't contact me"
# 		
# 	@agree.onSelect -> app.showNext(permissionsView)
# 	@ignore.onSelect -> app.showNext(reenableView)

app.showNext settingsView