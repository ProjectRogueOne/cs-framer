{ fraplin } = require 'fraplin'
cs = require 'cs'
cs.Context.setMobile()
Framer.Extras.Hints.disable()

{ idealPostcodes } = require 'npm'

app = new cs.App
	type: 'safari'
	navigation: 'default'
	collapse: true

ALWAYS_RECOGNISE_USER = false

user = {}

# Components

# Manual Form
class ManualForm extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			backgroundColor: 'rgba(0,0,0,.1)'
		
		super options

# Progress Step Row
class StepRow extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.assign options,
			backgroundColor: null
		
		_.defaults options,
			width: Screen.width
			height: 56
			animationOptions:
				time: .5
				colorModel: "rgb"
		
		super options
		
		@iconContainer = new Layer
			parent: @
			width: 56
			height: 56
			borderRadius: 32
			x: 60
			borderWidth: 3
			backgroundColor: '#FFF'
			animationOptions: @animationOptions
		
		@numberLayer = new cs.Text
			parent: @iconContainer
			type: 'body'
			y: Align.center(3)
			width: @iconContainer.width
			textAlign: 'center'
			text: options.number ? ''
			visible: options.number?
			color: '#777'
			animationOptions: @animationOptions
		
		@iconLayer = new cs.Icon
			parent: @iconContainer
			point: Align.center(3)
			visible: options.icon?
			icon: options.icon ? ''
			color: '#777'
			animationOptions: @animationOptions
			
		@labelLayer = new cs.Text 
			parent: @
			type: 'body'
			x: @iconContainer.maxX + 16
			y: Align.center(-1)
			originX: 0
			originY: 0
			color: '#777'
			text: options.text ? 'StepRow text'
			animationOptions: @animationOptions
		
		@valueLayer = new cs.Text 
			parent: @
			type: 'body'
			x: @iconContainer.maxX + 16
			y: Align.center()
			text: options.value ? 'StepRow text'
			color: '#000'
			animationOptions: @animationOptions
		
		@valueLayer.opacity = 0
		
		@editLink = new cs.Text 
			parent: @
			type: 'link'
			x: @iconContainer.maxX + 16
			y: Align.bottom(4)
			text: 'Edit'
			color: 'primary'
			animationOptions: @animationOptions
			action: => app.showNext(@view, 'right')
		
		@editLink.opacity = 0
		@editLink.fontSize = 14
		
		@onTap ->
			return if @index isnt homeView.current
			
			homeView.continueButton.action()
		
		_.assign @,
			value: options.value
			view: options.view
	
	fitContent: (layer) ->
		return if (layer.screenFrame.x + layer.screenFrame.width) < @width - 32
		layer.originX = 0
		layer.scale -= .01
		@fitContent(layer)
		
	showValue: (showEdit = true) ->
		return if not @value?
		
		@valueLayer.text = @value
		@fitContent(@valueLayer)
		
		if not showEdit
			@labelLayer.animate
				scale: .7
				y: 5
				options:
					time: .2
		
			@valueLayer.y = Align.center(5)
			@valueLayer.animate
				opacity: 1
				options:
					time: .25
					delay: .2
			return
		
		@labelLayer.animate
			scale: .75
			y: -1
			options:
				time: .2
		
		for layer in [@valueLayer, @editLink]
			layer.animate
				opacity: 1
				options:
					time: .25
					delay: .2
	
	@define "value",
		get: -> return @_value
		set: (string) ->
			return if @__constructor
			@_value = string

# RegistrationView

class RegistrationView extends cs.View
	constructor: (options = {}) ->
		
		_.assign options,
			backgroundColor: '#FFF'
		
		super options
		
		# continue button
		
		@backgroundColor = '#FFF'
	
		@continueContainer = new Layer
			name: 'Continue Container'
			parent: @
			y: Align.bottom()
			width: @width
			height: 64
			backgroundColor: '#FFF'
			shadowY: -1
			visible: false
			animationOptions: 
				time: .25
		
		@continueButton = new cs.Button
			parent: @continueContainer
			x: 16
			width: @width - 32
			y: Align.center
			type: 'body'
			color: 'white'
			text: 'Continue'
			action: -> app.showNext(deadEndView)
		
		@continueContainer.open = (animate = true) ->
			@visible = true
			@state = 'open'
			
			if animate
				@animate
					y: Align.bottom()
				return
				
			@y = Align.bottom()
		
		@continueContainer.close = (animate = true) ->
			@state = 'closed'
			
			if animate
				@animate
					y: Align.bottom(@height)
				return
				
			@y = Align.bottom(@height)
	
		# events
	
		app.footer.on "change:y", =>
			return if app.current isnt @
			return if @continueContainer.state is 'closed'
			@continueContainer.y = Align.bottom()
		
		app.header.on "change:status", (status) =>
			return if app.current isnt @
			@continueContainer.y = Align.bottom()
		
		@onLoad = => @checkCompleteStatus()
		
		# kickoff
		
		_.assign @,
			_required: []
			first: true
		
		@continueContainer.close()
	
	
	checkCompleteStatus: =>
		# if all required fields match their patterns, form is complete
		complete = _.every(@required, 'matches')
		
		for field in @required
			field.rightIcon.color = if field.matches then 'secondary' else 'grey'
		
		if complete
			return if @continueContainer.state is 'open'
			@continueContainer.open()
		else
			return if @continueContainer.state is 'closed'
			@continueContainer.close()
		
		@emit "change:complete", complete, @
		
	
	setRequiredListeners: =>
		for field in @required
			field.rightIcon = 'check'
			
			do (field) =>
				field.on "change:matches", (matches) =>
					@checkCompleteStatus()
		
			
	@define "required",
		get: -> return @_required
		set: (array) ->
			@_required = array
			@setRequiredListeners()

# Dead End View
class DeadEndView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@addToStack new cs.Text 
			type: 'body'
			text: 'Dead End'
		
		@addToStack new cs.Text 
			type: 'body1'
			text: "We haven't got here yet."
		
		delete @__constructor
		
		@onLoad = => @continueContainer.close(false) 

# -----------------------
# Views

# Account Sign In / Recovery

# Sign In View
class SignInView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@onLoad = =>
			@userNameField.value = ''
			@passwordField.value = ''
		
		@addToStack new cs.Text 
			type: 'body'
			text: 'Sign In'
			
		@padding.stack = 32
			
		@addToStack @userNameField = new cs.Field
			title: 'E-mail address'
			pattern: -> return @isEmail()
		
		@userNameField.width = @width - 32
		
		@padding.stack = 16
		
		@addToStack @passwordField = new cs.Field
			password: true
			title: 'Password'
			
		@passwordField.width = @width - 32
		
		@padding.stack = 32
		
		@addToStack new cs.Text 
			type: 'link'
			color: 'primary'
			text: "I'm having trouble signing in."
			action: -> app.showNext(accountRecoveryView)
		
		@padding.stack = 16
		
		@addToStack new cs.Text 
			type: 'link'
			color: 'primary'
			text: "Create an Account"
			action: -> app.showNext(introView)
		
		@required = [@userNameField, @passwordField]
		
		delete @__constructor
		
		@onLoad = => @continueContainer.close(false)

# Account Recovery View
class AccountRecoveryView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@addToStack new cs.Text 
			type: 'body'
			text: 'Recover My Account'
		
		@addToStack new cs.Text 
			type: 'body1'
			text: "To recover your account, enter your e-mail address below. We'll send you an e-mail with a link to reset your password."
		
		@padding.stack = 32
			
		@addToStack @emailField = new cs.Field
			title: 'E-mail address'
			pattern: -> return @isEmail()
		
		@emailField.width = @width - 32
		
		@required = [@emailField]
		
		delete @__constructor
		
		@onLoad = => @continueContainer.close(false)

# Registration Intro

# Create Account View
class CreateAccountView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@onLoad = =>
			@emailField.value = ''
			
		puller = new cs.Puller
			parent: @content
			y: -16
			text: "Let's start by creating your ClearScore account."
			arrow: true
		
		@padding.top = puller.maxY + 32
		@padding.stack = 32
		
		@addToStack @emailField = new cs.Field
			title: 'E-mail Address'
			pattern: -> return @isEmail()
			
		@emailField.width = @width - 32
		
		@emailField.on "change:focused", (isFocused) =>
			if isFocused
				window.scrollTo(0, -1)
				app.header.close()
		
		@addToStack @passwordField = new cs.Field
			title: 'Create your password'
			placeholder: ''
			size: 'full'
			password: true 
			rightIcon: 'eye'
			pattern: (value) ->
				v = value.split('')
				longEnough = 8 <= v.length <= 50
				oneNumber = _.intersection(v, ['0','1','2','3','4','5','6','7','8','9']).length > 0
				
				letterCheck.color = if v.length > 0 then 'secondary' else 'grey'
				charCheck.color = if longEnough then 'secondary' else 'grey'
				numberCheck.color = if oneNumber then 'secondary' else 'grey'
				@rightIcon.color = if longEnough and oneNumber then 'secondary' else 'grey'
				@rightIcon.icon = if longEnough and oneNumber then 'check' else 'eye'
				
				return longEnough and oneNumber
		
		@passwordField.width = @width - 32
		
		@padding.stack = 8
		
		@addToStack letterCheck = new cs.Icon
			icon: 'check'
			text: 'An upper and lowercase letter'
		
		@padding.stack = 2
		
		@addToStack numberCheck = new cs.Icon
			icon: 'check'
			text: 'At least one number'
		
		@addToStack charCheck = new cs.Icon
			icon: 'check'
			text: 'Between 8 and 50 characters'
		
		@required = [@emailField, @passwordField]
		
		@continueButton.action = =>
			user.email = @emailField.value
			
			if ALWAYS_RECOGNISE_USER or @emailField.value is 'frank@clearscore.com'
				app.showNext(haveWeMetView)
			else
				user.email = @emailField.value
				user.password = @passwordField.value
			
				app.onTransitionEnd _.once(->
					homeView.setValue(
						0, 
						user.email,
						@first,
						false # dont show edit
					)
				)
				
				app.showNext(homeView)
				
				
		
		delete @__constructor
		
		

# Have We Met? View
class HaveWeMetView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@addToStack new cs.Text 
			type: 'body'
			text: 'Have we already met?'
			
		email = user.email ? 'user@email.com'
			
		@addToStack new cs.Text 
			type: 'body'
			text: email[0] + email.replace(/([\w.-]+)(@)/, '****')
		
		@addToStack new cs.Text 
			type: 'body1'
			text: "We found an existing user with that e-mail address. If you have an account already, you can sign in or recover your account. If you're sure you haven't signed up before, you'll need to contact us so we see what's up."
			
		@addToStack new cs.Text 
			type: 'link'
			color: 'primary'
			text: "I have an account already"
			action: -> app.showNext(signInView)
		
		@addToStack new cs.Text 
			type: 'link'
			color: 'primary'
			text: "Help me recover my account"
			action: -> app.showNext(accountRecoveryView)
			
		@addToStack new cs.Text 
			type: 'link'
			color: 'primary'
			text: "Let me try that again..."
			action: -> app.showPrevious()
		
		delete @__constructor
		
		@onLoad = => @continueContainer.close(false)

# Registration Flow

# Home View
class HomeView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		_.assign @,
			rows: []
			current: 0
		
		super
		
		@onLoad = => @continueContainer.close(false)
		
		last = undefined
		
		options.steps ?= throw 'HomeView needs an array of steps objects' 
		
		for step, i in options.steps
		
			@rows[i] = new StepRow
				parent: @content
				name: step.title
				y: (last?.maxY ? 0) + 16
				text: step.title
				icon: step.icon
				view: step.view
			
			last = @rows[i]
		
		len = @rows.length
		
		@thruLine = new Layer
			name: 'thruLine'
			parent: @content
			width: 3
			midX: @rows[0].iconContainer.midX
			y: @rows[0].midY
			height: _.last(@rows).midY - @rows[0].midY
			backgroundColor: '#bdbdbd'
		
		@thruLine.sendToBack()
		
		@progressLine = new Layer
			name: 'thruLine'
			parent: @content
			width: 3
			midX: @rows[0].iconContainer.midX
			y: @rows[0].midY
			height: 0
			backgroundColor: '#555'
		
		@progressLine.placeBefore(@thruLine)
			
		delete @__constructor
		
		_.assign @,
			_current: 0
		
		@snapCurrent()
	
	snapCurrent: ->
		@continueButton.disabled = true
		if @rows[@current]?
			@progressLine.height = @rows[@current].midY - @rows[0].midY
			
		for row, i in @rows
			
			if i is @current
				row.iconContainer.props = 
					borderColor: '#555'
					backgroundColor: cs.Colors.primary
				row.iconLayer.color =  '#FFF'
				row.labelLayer.color =  '#000'
				continue
		
			if i < @current
				row.iconContainer.props = 
					backgroundColor: cs.Colors.secondary
					borderColor: '#555'
				row.iconLayer.color = '#FFF'
				row.labelLayer.color = '#555'
				row.valueLayer.color = '#333'
				continue
			
			row.iconContainer.backgroundColor = '#FFF'
			row.iconLayer.color = '#777'
			row.labelLayer.color = '#777'
		
		@updateDatabase()
		@updateNextStep()
		
	show: -> app.showOverlayBottom(@)
	
	showCurrent: (animate = true) ->
		if not animate
			snapCurrent()
			return
		
		@continueButton.disabled = true
		
		if @rows[@current]?
			@progressLine.height = @rows[@current - 1]?.midY - @rows[0].midY
			@progressLine.animate
				height: @rows[@current].midY - @rows[0].midY
				options:
					time: 1
					delay: .65
			
		for row, i in @rows
			
			if i is @current
				if Framer.Device.orientation isnt 0
					@scrollToLayer @rows[i - 1]
					
				do (row, i) =>
					Utils.delay 1.15, =>
						row.iconContainer.animate 
							borderColor: '#555'
							backgroundColor: cs.Colors.primary
						row.iconLayer.animate 
							color:  '#FFF'
						row.labelLayer.animate 
							color:  '#000'
				
						@updateDatabase()
						@updateNextStep()
						
						if Framer.Device.orientation isnt 0
							@scrollToLayer @rows[i]
				continue
		
			if i < @current
				row.iconContainer.animate 
					backgroundColor: cs.Colors.secondary
					borderColor: '#555'
				row.iconLayer.animate 
					color: '#FFF'
				row.labelLayer.animate 
					color:  '#555'
				row.valueLayer.animate 
					color:  '#333'
				continue
			
			row.iconContainer.animate 
				backgroundColor: '#FFF'
			row.iconLayer.animate 
				color: '#777'
			row.labelLayer.animate 
				color:  '#777'
	
	updateDatabase: ->
		for row in @rows
			user[row.name] = row.value
	
	updateNextStep: ->
		@continueButton.disabled = false
		Utils.delay 0, => @continueContainer.open()
		
		if !_.includes(_.values(user), undefined)
			@continueButton.animate
				backgroundColor: cs.Colors.todo
				borderColor: cs.Colors.secondary
				color: 'black'
			
			@continueButton.text = 'Complete'
			@continueButton.action = => app.showNext(completeView)
			
		@continueButton.action = =>
			app.showNext(@rows[@current].view, 'right')
	
	setValue: (index, value, animate = true, showEdit = true) ->
		
		@rows[index].value = value
		@rows[index].showValue(showEdit)
		@current = index + 1
		
		if animate then @showCurrent() else @snapCurrent()
	
	@define 'current',
		get: -> return @_current
		set: (number) ->
			return if @__constructor
			
			@_current = number

# Email View
class EmailView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@onLoad =>
			@emailField.value = user.email
		
		# Intro View		
		@addToStack new cs.Text
			type: 'body'
			x: Align.center
			text: 'Email'
		
		@padding.stack = 32
		
		@addToStack @emailField = new cs.Field
			title: 'E-mail Address'
			pattern: -> return @isEmail()
			
		@emailField.width = @width - 32
		
		@required = [@emailField]
		
		@first = true
		
		@continueButton.action = =>
			user.email = @emailField.value
			
			app.onTransitionEnd _.once(=>
				homeView.setValue(
					0, 
					@emailField.value,
					@first
				)
				
				@first = false
			)
			
			app.showNext(homeView)
		
		delete @__constructor
		
		

# Name View
class NameView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		delete @__constructor
			
		puller = new cs.Puller
			parent: @content
			y: -16
			text: "To find your report, we'll need your full name – including middle names, if you have any."
			arrow: true
			
		@padding.top = puller.maxY + 32
		
		@addToStack firstName = new cs.Field
			title: 'First Name'
			message: 'Enter your full first name – Elizabeth works better than Liz'
		
		firstName.width = @width - 32
		
		@addToStack middleName = new cs.Field
			title: 'Middle Name(s)'
			message: "Optional"
		
		middleName.width = @width - 32
		
		@addToStack familyName = new cs.Field
			title: 'Family Name'
			message: 'Your last name or surname'
		
		familyName.width = @width - 32
		
		@required = [firstName, familyName]
		
		@first = true
		
		@continueButton.action = =>
			mname = undefined 
			
			if middleName.value.length > 0
				mname = middleName.value + ' '
			else
				mname = ''
		
			app.onTransitionEnd _.once(=>
				homeView.setValue(
					1, 
					firstName.value + ' ' + mname + familyName.value
					@first
				)
				
				@first = false
			)
			
			app.showNext(homeView, 'right')
			
			
			

# Date of Birth View
class DobView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super
		
		@puller = new cs.Puller
			parent: @content
			y: -16
			text: "When were you born?"
			arrow: true
			
		@_startText = @puller.text
			
		@padding.top = @puller.maxY + 32
		
		@date = new cs.Field
			parent: @content
			x: 16
			y: @padding.top
			title: 'Date'
			message: 'e.g. 30'
		
		@date.width = (@width - 64) / 3
		
		@month = new cs.Field
			parent: @content
			x: @date.maxX + 16
			y: @padding.top
			title: 'Month'
			message: 'e.g. 3'
		
		@month.width = (@width - 64) / 3
		
		@year = new cs.Field
			parent: @content
			x: @month.maxX + 16
			y: @padding.top
			title: 'Year'
			message: 'e.g. 1920'
			pattern: (value) -> value.length is 4
		
		@year.width = (@width - 64) / 3
		
		@required = [@date, @month, @year]
		
		@first = true
		
		for layer in @required
			layer.on "change:matches", @stateDay
					
		@continueButton.action = =>
			
			app.onTransitionEnd _.once(=>
				homeView.setValue(
					2, 
					@date.value + '/' + @month.value + '/' + @year.value,
					@first
				)
				
				@first = false
			)
			
			app.showNext(homeView, 'right')
	
	stateDay: =>
		if !_.every(@required, 'matches')
			@puller.text = @_startText
			return
			
		date = new Date(@year.value, @month.value - 1, @date.value)
		@puller.text = "Hey, you were born on a #{date.toLocaleString([], {'weekday': 'long'})}. Nice!"


# AddressView
class AddressView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super

# Document View
class DocView extends RegistrationView
	constructor: (options = {}) ->
		@__constructor = true
		
		super

# originals

# Landing View

landingView = new cs.View
	showLayers: false
	backgroundColor: '#FFF'
	padding: {top: 120, left: 16, right: 16, stack: 24}

landingView.build ->
	puller = new cs.Puller
		parent: @content
		y: -16
		text: 'There are four steps you now need to complete to get your free credit score: create your account and agree to our terms and conditions, securely validate your identity, and then retrieve your credit score and report.'
		
	@addToStack @nameField = new cs.Field
		title: 'Full Name'
		placeholder: 'Your full name including middle names'
		size: 'full'
		pattern: (value) -> value.length > 0
		
	@addToStack @dobField = new cs.Field
		title: 'Date of Birth'
		placeholder: ''
		size: 'full'
		pattern: (value) -> value.length > 4
		
	@addToStack @passwordField = new cs.Field
		title: 'Create your password'
		placeholder: ''
		size: 'full'
		password: true 
		rightIcon: 'eye'
		pattern: (value) ->
			v = value.split('')
			longEnough = 8 <= v.length <= 50
			oneNumber = _.intersection(v, ['0','1','2','3','4','5','6','7','8','9']).length > 0
			
			letterCheck.color = if v.length > 0 then 'secondary' else 'grey'
			charCheck.color = if longEnough then 'secondary' else 'grey'
			numberCheck.color = if oneNumber then 'secondary' else 'grey'
			@rightIcon.color = if longEnough and oneNumber then 'secondary' else 'grey'
			@rightIcon.icon = if longEnough and oneNumber then 'check' else 'eye'
			
			return longEnough and oneNumber
		
	@checkOkay = =>
		if @passwordField.matches and @nameField.matches and @dobField.matches
			@continueContainer.open()
		else
			@continueContainer.close()
	
	
	
	@nameField.on "change:matches", @checkOkay
	@dobField.on "change:matches", @checkOkay
	@passwordField.on "change:matches", @checkOkay
	
	@addToStack letterCheck = new cs.Icon
		icon: 'check'
		text: 'An upper and lowercase letter'
	
	@padding.stack = 2
	
	@addToStack numberCheck = new cs.Icon
		icon: 'check'
		text: 'At least one number'
	
	@addToStack charCheck = new cs.Icon
		icon: 'check'
		text: 'Between 8 and 50 characters'
		
	# continue button
	
	@continueContainer = new Layer
		parent: @
		y: Align.bottom()
		width: @width
		height: 64
		backgroundColor: '#FFF'
		shadowY: -1
		visible: false
		animationOptions: 
			time: .25
	
	continueButton = new cs.Button
		parent: @continueContainer
		x: 16
		width: @width - 32
		y: Align.center
		type: 'body'
		color: 'white'
		text: 'Continue'
		action: -> app.showNext(postcodeView)
		
	@continueContainer.open = ->
		@visible = true
		@state = 'open'
		@animate
			y: Align.bottom()
	
	@continueContainer.close = ->
		@state = 'close'
		@animate
			y: Align.bottom(@height)
	
	app.footer.on "change:y", =>
		if @continueContainer.state is 'open'
			@continueContainer.y = Align.bottom()
			
	@continueContainer.close()

# PostCode View

postcodeView = new cs.View
	showLayers: false
	backgroundColor: '#FFF'
	padding: {top: 16, left: 16, right: 16, stack: 24}


postcodeView.build ->
	
	@results = []
	@city = ''
	@county = ''
	@postcode = ''
	
	# Show Manual Form
	# -------------
	# Shows the manual address submit form
	#
	@showManualForm = =>
		@puller.animate
			height: 0
			options:
				time: .25
		
		for layer in [@topSection, @manualOption]
			layer.animate
				opacity: 0
				options:
					time: .15
		
		Utils.delay .5, =>
			@topSection.visible = false
			@manualOption.visible = false
	
		@manualForm.visible = true
		@manualForm.animate
			opacity: 1
			options:
				time: .25
				delay: .15
	
	# Hide Manual Form
	# -------------
	# Hides the manual address submit form
	#
	@hideManualForm = =>
		@puller.animate
			height: @pullerHeight
			options:
				time: .25
				delay: .15
		
		@manualForm.animate
			opacity: 0
			options:
				time: .15
		
		Utils.delay .5, =>
			@manualForm.visible = false
		
		
		for layer in [@topSection, @manualOption]
			layer.visible = true
			layer.animate
				opacity: 1
				options:
					time: .25
					delay: .15
	
	# Get Addresses at Postcode
	# -------------
	# Makes buttons for postcode query results
	# @params postcode <string> response from craftyclicks api
	#
	@getAddressesAtPostcode = (postcode) =>
		postcode = _.replace(postcode, ' ', '')
		
		return if 5 > postcode.length < 7
		
		parameters =
			key: "febdd-0aec5-2195b-025a4"
			postcode: postcode
			response: "data_formatted"
		
		url = "http://pcls1.craftyclicks.co.uk/json/rapidaddress"
		
		request = new XMLHttpRequest()
		request.open('POST', url, false)
		request.setRequestHeader('Content-Type', 'application/json')
		
		request.onreadystatechange = =>
			if request.readyState is 4
				if request.status >= 200 and request.status < 400
					data = JSON.parse(request.responseText)
					@showAddresses(data)
					@showResults()
				else
					@hideResults()
					return null
			
		request.send(JSON.stringify(parameters))
	
	
	# Set Address
	# -------------
	# Sets layer content based on an address object
	# @params address <object> address from craftyclicks api response
	#
	@setAddress = (address) ->
		string = ''
		
		for datapoint in [address.line_1, address.line_2, address.line_3]
			continue if not datapoint? or datapoint.length <= 0
			
			string += _.startCase(datapoint.toLowerCase()) + '<br>'
		
		string += _.startCase(@city.toLowerCase())
		
		@addressBody.html = string
		@continueContainer.open()
	
	
	# Show Addreses
	# -------------
	# Makes buttons for postcode query results
	# @params data <object> response from craftyclicks api
	#
	@showAddresses = (data) ->
		return if not data
		
		@hideResults()
		@radioboxes = []
		
		@city = data.town
		@county = data.traditional_county
		@postcode = data.postcode
		
		@padding.top = @topSection.height + 16
		@padding.stack = 24
		@padding.bottom = 96
		
		for address in _.sortBy(data.delivery_points, 'dps')
			
			addressButton = new cs.Radiobox
				name: '.'
				x: 16
				text: _.startCase(address.line_1.toLowerCase())
				group: @radioboxes
				
			@addToStack(addressButton)
			addressButton.data = address
			
			do (addressButton, address) =>
				Utils.delay 0, => 
					addressButton.mask.width = Screen.width - 32
					addressButton.action = => @setAddress(address)
			
			@results.push(addressButton)
		
		@padding.stack = 32
		
		@addToStack cantFindIt = new cs.Accordian
			title: "Can't find your address?"
			color: '#000'
		
		cantFindIt.onAnimationEnd =>
			@contentInset.top = @padding.top
			@contentInset.bottom = @padding.bottom
			
			@updateContent()
			
			@scrollToPoint(
				x: 0, y: @content.height
				true
				time: .15
			)
		
		op1 = new cs.Text
			parent: cantFindIt
			y: 72
			x: 16
			type: 'body1'
			width: cantFindIt.width - 32
			text: "If you're sure your current postcode is #{@postcode} but your address isn't listed here, click the link below to enter your address."
			
		op2 = new cs.Text
			parent: cantFindIt
			y: op1.maxY + 16
			type: 'link'
			x: Align.center()
			width: cantFindIt.width - 32
			text: "Enter your current address"
			color: 'primary'
		
		@results.push(cantFindIt)
		
		
	
	# Show Results
	# -------------
	# Shows results state when address selections are available
	#
	@showResults = =>
		return if @results.length <= 0
		
		@postcodeField.rightIcon = 'close'
		@postcodeField.input.blur()
		
		@puller.animate 
			height: 1
			options:
				time: .25
		
		@manualOption.visible = false
		@postcodeField.animate
			width: (@width * .33) - 16
			options:
				time: .25
		
		for layer in [@addressTitle, @addressBody]
			layer.animate 
				opacity: 1
				options:
					time: .25
					delay: .15

	# Hide Results
	# -------------
	# Clears results when no address objects are available
	#
	@hideResults = =>
		for result in @results
			@removeFromStack(result)
			result.destroy()
			
		@puller.animate 
			height: @pullerHeight
			options:
				time: .25
		
		@postcodeField.rightIcon = ''
		@postcodeField.input.focus()
			
		@city = ''
		@county = ''
		@postcode = ''
		
		@manualOption.visible = true
		@postcodeField.animate
			x: 16
			width: (@width - 32)
			options:
				time: .25
				
		for layer in [@addressTitle, @addressBody]
			layer.animate
				opacity: 0
				options:
					time: .25
				
		@addressBody.html = 'Select your address below'
		
		@continueContainer.close()

	# Try to Search
	@tryToSearch = =>
		print @postcodeField
		value = @postcodeField.value
		if 5 > value.length < 7
			print value
			@hideResults()
			return
		
		@getAddressesAtPostcode(value)
	
	# Timer Stuff
	@timer = 0
	
	@resetTimer = => @timer = 0
	
	@typeTimer = undefined
	
	@tickTimer = =>
		@timer += .1
		return if @timer <= .5
		
		@timer = 0
		@tryToSearch()
	
	@setTimer = => 
		@typeTimer = Utils.interval .1, @tickTimer
	
	@clearTimer = => clearInterval(@typeTimer)
	
	
	# Layers
	# ------
	
	@puller = new cs.Puller
		parent: @
		text: 'You can quickly search fro your address by using just your postcode. ' +
		'In case we can’t find your address you can always enter it manually.'
	
	@pullerHeight = @puller.height

	# section for fixed content
	@topSection = new Layer
		name: 'Top Section'
		parent: @
		y: @puller.maxY
		width: @width
		height: 200
		backgroundColor: '#FFF'
	
	@postcodeField = new cs.Field
		parent: @topSection
		x: 16
		y: 16
		title: 'Postcode'
		placeholder: 'Search for your postcode'
	
	@topSection.height = @postcodeField.maxY + 16
	
	@postcodeField.input.onfocus = =>
		@postcodeField.focused = true
		@setTimer()
	
	@postcodeField.input.onblur = =>
		@postcodeField.focused = false
		@clearTimer()
	
	@postcodeField.on "change:value", =>
		@resetTimer()
	
	@postcodeField.rightIcon.action = => 
		@postcodeField.value = ''
		@hideResults()
			
	@postcodeField.width = @width - 32
	
	@addressTitle = new cs.Text
		parent: @topSection
		x: (@width * .33) + 32
		y: 16
		type: 'body'
		text: 'Your address'
		textAlign: 'right'
		opacity: 0
		
	@addressTitle.opacity = 0
	
	@addressBody = new Layer
		parent: @topSection
		x: (@width * .33) + 32
		y: @addressTitle.maxY + 8
		width: (@width * .66) - 16
		height: 64
		backgroundColor: null
		html: 'Select your address below'
		opacity: 0
		style:
			fontSize: '.5em'
			color: '#333'
			textAlign: 'left'
			lineHeight: '1.3'

	@puller.on "change:height", =>
		@topSection.y = @puller.maxY
	
	# manual link options
	
	@manualOption = new Layer
		name: 'Manual option'
		parent: @
		y: @topSection.maxY
		backgroundColor: 'null'
		width: @width
		opacity: 1
	
	orText = new cs.Text
		parent: @manualOption
		type: 'body'
		color: 'grey'
		x: Align.center()
		text: 'OR'
		
	linkText = new cs.Text
		parent: @manualOption
		type: 'link'
		color: 'primary'
		x: Align.center()
		y: orText.maxY + 16
		text: 'Enter your current address manually'
	
	# manual entry form
	@manualForm = new ManualForm
		parent: @content
		width: @width
		visible: false
		opacity: 0
	
	
	# continue button
	
	@continueContainer = new Layer
		name: 'Continue Container'
		parent: @
		y: Align.bottom()
		width: @width
		height: 64
		backgroundColor: '#FFF'
		shadowY: -1
		visible: false
		animationOptions: 
			time: .25
	
	continueButton = new cs.Button
		parent: @continueContainer
		x: 16
		width: @width - 32
		y: Align.center
		type: 'body'
		color: 'white'
		text: 'Continue'
		action: -> app.showNext(docUpload)
	
	@continueContainer.open = ->
		@visible = true
		@state = 'open'
		@animate
			y: Align.bottom()
	
	@continueContainer.close = ->
		@state = 'close'
		@animate
			y: Align.bottom(@height)
	
	app.footer.on "change:y", =>
		if @continueContainer.state is 'open'
			@continueContainer.y = Align.bottom()
			
	@continueContainer.close()
	@hideManualForm()
	

# Doc Upload View

docUpload = new cs.View
	showLayers: false
	backgroundColor: '#FFF'

docUpload.padding.top = 120

# top furniture

puller = undefined
uploadFrontSide = undefined
uploadBackSide = undefined


docUpload.build ->
	
	puller = new cs.Puller
		parent: @content
		y: -16
		
	@addToStack @idTitle = new cs.Text
		type: 'body'
		text: 'ID Verification'

# Front Side Upload

docUpload.build ->
	@addToStack uploadFrontSide = new cs.UploadButton
		width: 355
		height: 177
		fill: 'white'
		shadowY: 0
		shadowBlur: 0
		style:
			border: '3px dashed #777'
	
	do _.bind( ->
		
		@icon = new cs.Icon
			parent: @
			icon: 'camera'
			border: 1
			scale: 2
			x: Align.center
			y: Align.center(4)
		
		@detail = new cs.Text
			parent: @
			type: 'body'
			text: 'Driving License (front side)'
			x: Align.center
			y: 15
		
		@detail1 = new cs.Text
			parent: @
			type: 'body'
			text: 'Take a picture or select a file'
			x: Align.center
			y: @icon.maxY + 38
		
		@display = new Layer
			parent: @
			size: @size
			backgroundColor: null
		
		# iphone bug exception
		
		if Utils.isMobile()
			_.assign @display,
				originX: 0
				originY: 0
				rotation: 90
				width: @height
				height: @width
				x: @width
		
	, uploadFrontSide)
	
	uploadingFrontState = new Layer
		parent: @content
		y: @idTitle.maxY + 16
		x: 12
		width: @width - 24
		opacity: 0
		visible: false
		backgroundColor: null
	
	do _.bind( ->
	
		@box = new cs.Container
			parent: @
			width: @width
			border: 'black'
			fill: 'white'
		
		@iconLayer = new cs.Icon
			parent: @
			icon: 'file-outline'
			scale: 1.4
			x: 8
			y: 12
			color: '#4a90e2'
			visible: false
			
		@progress = new Layer
			parent: @box
			height: @box.height
			width: 1
			backgroundColor: 'b8e986'
		
		@labelLayer = new cs.Text 
			parent: @box
			type: 'body'
			width: @width
			y: Align.center
			textAlign: 'center'
			text: 'Uploading'
			color: 'black'
			
		@uploadImage = (url, callback = -> null) ->
			
			@visible = true
			
			@animate
				opacity: 1
				options:
					time: .15
					delay: .15
			
			@progress.onAnimationEnd _.once(callback)
			
			@progress.animate
				width: @box.width
				options:
					delay: .75
					time: 2
					curve: 'linear'
					
			uploadFrontSide.animate 
				height: @box.height
		
		@confirmUpload = =>
			@progress.width = 0
			@box.fill = 'dbe9f9'
			@box.border = '4a90e2'
			@labelLayer.color = '#4a90e2'
			@labelLayer.text = 'Driving license - front side'
			@iconLayer.visible = true
			uploadBackSide.open()
		
	, uploadingFrontState)
	
	uploadFrontSide.on "change:file", (url) ->
		
		@onAnimationEnd _.once(-> 
			@visible = false
			uploadingFrontState.uploadImage(url, uploadingFrontState.confirmUpload)
			)
		
		@animate
			opacity: 0
			options:
				time: .15

# Back Side Upload

docUpload.build ->
	@addToStack uploadBackSide = new cs.UploadButton
		width: 355
		height: 177
		fill: 'white'
		shadowY: 0
		shadowBlur: 0
		style:
			border: '3px dashed #777'
	
	do _.bind( ->
		
		@open = ->
			@animate
				height: 177
			@style.border = '3px dashed #777'
			
			@animate
				opacity: 1
				options:
					time: .15
					delay: .15
		
		@icon = new cs.Icon
			parent: @
			icon: 'camera'
			border: 1
			scale: 2
			x: Align.center
			y: Align.center(4)
		
		@detail = new cs.Text
			parent: @
			type: 'body'
			text: 'Driving License (back side)'
			x: Align.center
			y: 15
		
		@detail1 = new cs.Text
			parent: @
			type: 'body'
			text: 'Take a picture or select a file'
			x: Align.center
			y: @icon.maxY + 38
		
		@display = new Layer
			parent: @
			size: @size
			backgroundColor: null
		
		# iphone bug exception
		
		if Utils.isMobile()
			_.assign @display,
				originX: 0
				originY: 0
				rotation: 90
				width: @height
				height: @width
				x: @width
		
		@height = 1
		@opacity = 0
		
	, uploadBackSide)
	
	uploadingBackState = new Layer
		parent: @content
		y: uploadBackSide.y
		x: 12
		width: @width - 24
		opacity: 0
		visible: false
		backgroundColor: null
	
	do _.bind( ->
	
		@box = new cs.Container
			parent: @
			width: @width
			border: 'black'
			fill: 'white'
		
		@iconLayer = new cs.Icon
			parent: @
			icon: 'file-outline'
			scale: 1.4
			x: 8
			y: 12
			color: '#4a90e2'
			visible: false
			
		@progress = new Layer
			parent: @box
			height: @box.height
			width: 1
			backgroundColor: 'b8e986'
		
		@labelLayer = new cs.Text 
			parent: @box
			type: 'body'
			width: @width
			y: Align.center
			textAlign: 'center'
			text: 'Uploading'
			color: 'black'
			
		@uploadImage = (url, callback = -> null) ->
			
			@visible = true
			
			@animate
				opacity: 1
				options:
					time: .15
					delay: .15
			
			@progress.onAnimationEnd _.once(callback)
			
			@progress.animate
				width: @box.width
				options:
					delay: .75
					time: 2
					curve: 'linear'
					
			uploadBackSide.animate 
				height: @progress.height
		
		@confirmUpload = =>
			@progress.width = 0
			@box.fill = 'dbe9f9'
			@box.border = '4a90e2'
			@labelLayer.color = '#4a90e2'
			@labelLayer.text = 'Driving license - back side'
			@iconLayer.visible = true
			
			docUpload.continueContainer.open()
		
	, uploadingBackState)
	
	uploadBackSide.on "change:file", (url) ->
		
		uploadingBackState.y = @y
		
		@onAnimationEnd _.once(-> 
			@visible = false
			uploadingBackState.uploadImage(url, uploadingBackState.confirmUpload)
			)
		
		@animate
			opacity: 0
			options:
				time: .15

# Bottom Furniture

docUpload.build ->
	
	@padding.top = 0
	
	@addToStack new cs.Accordian
		title: 'What documents can I use?'
		color: '#000'
		
	@addToStack new cs.Divider
	
	@addToStack new cs.Text
		x: 20
		type: 'caption'
		width: @width - 32
		text: 'Files must be smaller than 4MB. We keep your ID confidential and its use is for internal use only.'
		
	# continue button
	
	@continueContainer = new Layer
		name: 'Continue Container'
		parent: @
		y: Align.bottom()
		width: @width
		height: 64
		backgroundColor: '#FFF'
		shadowY: -1
		visible: false
		animationOptions: 
			time: .25
	
	continueButton = new cs.Button
		parent: @continueContainer
		x: 16
		width: @width - 32
		y: Align.center
		type: 'body'
		color: 'white'
		text: 'Continue'
		action: -> null
	
	@continueContainer.open = ->
		@visible = true
		@state = 'open'
		@animate
			y: Align.bottom()
	
	@continueContainer.close = ->
		@state = 'close'
		@animate
			y: Align.bottom(@height)



# ----------------------
# Implementation

signInView = new SignInView
accountRecoveryView = new AccountRecoveryView

createAccountView = new CreateAccountView
haveWeMetView = new HaveWeMetView

nameView = new NameView
dobView = new DobView
emailView = new EmailView
# addressView = new AddressView
# docView = new DocView
deadEndView = new DeadEndView

homeView = new HomeView
	showLayers: true
	steps: [
		{title: 'Account', icon: 'account-circle', view: emailView}
		{title: 'Name', icon: 'account', view: nameView}
		{title: 'Date of Birth', icon: 'calendar', view: dobView}
		{title: 'Current Address', icon: 'home', view: postcodeView}
		{title: 'Documents', icon: 'file-multiple', view: docUpload}
	]
	step: 0

app.showNext(postcodeView)
