Framer.Extras.Hints.disable()

# Fonts

Quicksand = Utils.loadWebFont("Quicksand")

Utils.insertCSS """

	@font-face {
		font-family: "Quicksand";
		src: url(fonts/Quicksand-Light.ttf);
		fontWeight: 300
	}
	
	@font-face {
		font-family: "Quicksand";
		src: url(fonts/Quicksand-Regular.ttf);
		fontWeight: 400
	}
	
	@font-face {
		font-family: "Quicksand";
		src: url(fonts/Quicksand-Medium.ttf);
		fontWeight: 500
	}
	
	@font-face {
		font-family: "Quicksand";
		src: url(fonts/Quicksand-Bold.ttf);
		fontWeight: 600
	}
	
"""

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
	medium: '#5dd6db'	# header background color
	
	# modal colors
	modalBackground:'#1a87c6'

	# chat colors
	chatBackground:'#f1f3f4'
	chatFill: '#ffffff'
	choiceText: '#23c7cf'
	choiceBackground: '#FFF'

	# modal colors
	cta: '#21aa99'
	chosen: '#000'
	suggested: 'rgba(0,0,0,.62)'
	
	# shared styles
	
	border: "#rgba(0,0,0,.08)"

# Helper Functions

Utils.timeUntil = (date) ->
	timeDifference = _.floor((date.getTime() - _.now()) / 60000)
	hours = _.floor(timeDifference / 60)
	minutes = timeDifference - (hours * 60)
	
	return {hours: hours, minutes: minutes}
	

# Giphy

Utils.getGiphy = (layer, query) ->
	
	q = query
	
	api = "CvTVnQK6zvQ6PDkzlXYuzhJn1mTqTHQR"
	
	request = new XMLHttpRequest
	request.open('GET', "https://api.giphy.com/v1/gifs/search?api_key=#{api}&q=#{q}&limit=25&offset=0&rating=G&lang=en", true)
	
	request.onload = ->
		if 200 <= request.status < 400
			data = JSON.parse(request.responseText).data[0].images.fixed_width.url
			layer.image = data
			return data
	
	request.onerror = -> return Utils.randomImage()

	request.send()

# ----------------------------------------------
# Data Classes

# Plan

class Plan
	constructor: (options = {}) ->
		defaultWhen = new Date()
		defaultWhen.setHours(21, 0)
		
		@name = options.name ? 'Plan Name'
		
		@what = options.what ? 'eat'
		@where = options.where ? kebabTruck
		@when = options.when ? defaultWhen
		@budget = options.budget ? 0
		
		@people = options.people ? []
		@confirmed = options.confirmed ? false
		
		@venues = options.venues ? []
		
		@choices =
			what: false
			where: false
			when: false
			who: false
		
	confirm: -> 
		@confirmed = true
		user.plans.push(@)
	
	saveDraft: ->
		user.drafts.push(@)

# Person
Person = (options = {}) ->
	
	sex = _.sample(['male', 'female'])
	mfirstName = _.sample(['Andy', 'Bob', 'Carl', 'Daniel', 'Ed', 'Frank', 'Gary'])
	ffirstName = _.sample(['Andrea', 'Betty', 'Cindy', 'Donna', 'Eve', 'Frannie', 'Greta'])
	
	firstName = if sex is 'male' then mfirstName else ffirstName
	lastName = _.sample(['Harrison', 'Iverson', 'Joules', 'Kim', 'Lianes', 'Morris'])

	_.defaults options,
		sex: sex
		firstName: firstName
		lastName:  lastName
		name: firstName + ' ' + lastName
		image: Utils.randomImage()
	
	_.assign @, options
	
	return @

# Place
Place = (options = {}) ->
	_.assign @, options
	return @

# ----------------------------------------------
# Chat Components

# remove avatar from containers? make that managed by view?
# selecting more than one person from person scroll?

# Chat View Components

# Chat View

# leftAvatar - the options to use for the avatar of chats in the left alignment
# rightAvatar - the options to use for the avatar of chats in the right alignment

# addChat( chatBubble ) - Method for adding new chat bubbles to the view

class ChatView extends View
	constructor: (options = {}) ->
		@__constructor = true
		
		@_inputs = []
		@inputChoices = []
		
		@choices = []
		@chats = []
		@leftAvatarOptions = options.leftAvatar
		@rightAvatarOptions = options.rightAvatar
		
		@leftStyle = options.leftStyle ? {
			backgroundColor: '#f0f0f0'
			color: '#000'
		}
		
		@rightStyle = options.rightStyle ? {
			backgroundColor: '#0183f3'
			color: '#FFF'
		}
		
		@padding = options.padding ? {
			sameSender: 8
			differentSenders: 24
		}
		
		super _.defaults options,
			name: "Chat View"
			backgroundColor: colors.chatBackground
			
		# layers
		
		@inputScroll = new ScrollComponent
			name: 'Input Button Scroll'
			parent: @
			y: Align.bottom
			width: @width
			height: 64
			backgroundColor: '#FFF'
			shadowY: -1
			shadowColor: 'rgba(0,0,0,.24)'
			scrollVertical: false
		
		@inputScroll.content.backgroundColor = null
		
		chatButton = new ChatViewButton
			view: @
			parent: flow?.header
			x: Align.right(-8 - (chatViews.length * 36))
			y: Align.bottom(-8)
		
		# Create Eezy Button
		@eezyButton = new EezyButton()
		_.assign @eezyButton,
			parent: @
			x: Align.right(-16)
			y: Align.bottom(-@eezyButton.height / 2)
			visible: false
			
		@eezyButton.onTap -> new PlanModal	
		
		chatViews.push(@)
		
		delete @__constructor
		
		@on "change:inputs", @setInputs
	
	setInputs: =>
		last = undefined
		for input in @inputs
			inputChoice = new InputChoice
				parent: @inputScroll.content
				x: (last?.maxX ? 0) + 16
				y: 8
				text: input.text
			
			do (input) =>
				inputChoice.onTap =>
					if not input.silent
						@addChat new ChatBubble
							text: input.text
							align: 'right'
					@clearInputs()
					@inputs = []
					Utils.delay 1, => input.callback()
				
				@inputChoices.push(inputChoice)
			
			last = inputChoice
		
		@inputScroll.updateContent()
			
	clearInputs: =>
		for input in @inputChoices
			input.destroy()
	
	resetChatIndices: =>
		for chatBubble, i in @chats
			chatBubble.i = i
			
	resetChatPositions: =>
		last = undefined
		
		for chatBubble, i in @chats
			# for the first chat... 
			if i is 0
				chatBubble.y = 0
				last = chatBubble
				continue
			
			# when last sender is same as this one
			if last.align is chatBubble.align
				chatBubble.y = last.maxY + @padding.sameSender
				last = chatBubble
				continue
			
			# for the rest of them (different senders)
			chatBubble.y = last.maxY + @padding.differentSenders
			
			# assign this chat as last for next iteration
			last = chatBubble
		
		@updateContent()
	
	removeChat: (chatBubble) =>
		_.pull(@chats, chatBubble)
		@resetChatIndices()
		@resetChatPositions()
		
	addChat: (chatBubble) =>
			
		switch chatBubble.align
			when "left" 
				chatBubble.setStyle(@leftStyle)
				_.assign chatBubble.avatarLayer, @leftAvatarOptions
			when "right" 
				_.assign chatBubble.avatarLayer, @rightAvatarOptions
				chatBubble.setStyle(@rightStyle)
			when "full"
				chatBubble.setStyle(@leftStyle)
				_.assign chatBubble,
					width: @width
					x: 0
				
		i = @chats.length
		yGap = @padding.differentSenders
			
		if i > 0
		
			# get the last message
			last = _.last(@chats)
			
			# get rid of the avatar on the last message
			last.hideAvatar()
			
			if last.align is chatBubble.align or
			last.align is "full" and chatBubble.align is "left" or
			last.align is "left" and chatBubble.align is "full"
				yGap = @padding.sameSender
			
		_.assign chatBubble,
			parent: @content
			chatView: @
			y: (last?.maxY ? -yGap) + yGap
		
		chatBubble.on "change:height", (lastHeight, newHeight, layer) =>
			@chats[layer.i + 1]?.y = layer.maxY + yGap
			@updateContent()
		
		chatBubble.on "change:y", (lastHeight, newHeight, layer) =>
			@chats[layer.i + 1]?.y = layer.maxY + yGap
		
		@resetChatIndices()
		@updateContent()
		
		# scroll to layer
		
		@animateStop()
		if chatBubble.maxY > (Screen.height * .7)
			@scrollToPoint(
				x: 0, y: chatBubble.maxY - Screen.height * .7,
				true
				time: .25
			)
		
		@chats.push(chatBubble)
		
	@define "inputs",
		get: -> return @_inputs
		set: (array) ->
			@clearInputs()
			
			if array? and not _.isArray(array) then array = [array]
			@_inputs = array ? []
			
			@emit "change:inputs", array, @

# Side Chat View

class SideChatView extends ChatView
	constructor: (options = {}) ->
		
		_.defaults options, 
			title: 'Main Chat'
			left: 
				icon: 'menu'
				action: -> flow.showOverlayLeft(side_menu)
			# right:
			# icon: 'navigation'
			leftAvatar: 
				backgroundColor: '#23c7cf'
			rightAvatar: 
				backgroundColor: colors.chatFill
			padding:
				sameSender: 8
				differentSenders: 24
			leftStyle:
				backgroundColor: colors.chatFill
				color: '#000'
			rightStyle:
				backgroundColor: '#484848'
				color: '#FFF'
			plan: new Plan
		
		@plan = options.plan
		
		super options
		
		sideChatViews.push(@)
		
		@headerLayer = new Layer
			name: 'Header'
			parent: @
			y: flow?.header.maxY ? 0
			height: 160
			width: @width
			backgroundColor: '#4455bb'
			
		@planImage = new Layer
			name: 'Image'
			parent: @headerLayer
			x: 32
			y: 32
			width: 72
			height: 72
			borderRadius: 36
			backgroundColor: colors.medium
			
		@planName = new Type.Regular
			name: 'Plan Name'
			parent: @headerLayer
			x: 128
			y: 32
			width: @width - 128 - 16
			borderRadius: 36
			color: "#FFF"
			text: plan.name
		
		startTime = plan.when.toLocaleTimeString([], {'hour': '2-digit', 'hour12': true})
		
		@planTime = new Type.Regular
			name: 'Plan Name'
			parent: @headerLayer
			x: 128
			y: @planName.maxY + 16
			width: @width - 128 - 16
			borderRadius: 36
			color: "#FFF"
			text: "Starts at #{startTime.toUpperCase()} today"
		
		@planDetails = new Type.Regular
			name: 'Plan Name'
			parent: @headerLayer
			x: 128
			y: @planTime.maxY + 16
			width: @width - 128 - 16
			borderRadius: 36
			color: "#CCC"
			text: "#{plan.venues.length} venues, #{plan.people.length} friends"
			
		@headerLayer.height = @planDetails.maxY + 32
				
		@headerLayer.onTap -> 
			flow.showOverlayBottom(new PlanDetailModal)
		
		@contentInset = {top: @headerLayer.height + flow.header.height + 16}
		
		@addChat new ChatBubble
		@addChat new ChatBubble
		@addChat new ChatBubble
		@addChat new ChatBubble
		@addChat new ChatBubble


# Chat View Button

class ChatViewButton extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		options.view ?= throw 'ChatViewButton needs a view property.'
		
		super _.defaults options,
			name: "Chat View Button"
			width: 32
			height: 32
			borderRadius: 16
		
		delete @__constructor
		
		@onTap -> flow.showNext(options.view)

# Eezy Button

EezyButton = ->
	
	background = new Layer
		name: 'Eezy Button'
		width: 64
		height: 64
		borderRadius: 36
		backgroundColor: '#4455bb'
		
	background.pulse = ->
		@visible = true
		
		@animate
			scale: 1.12
			rotation: -25
			options:
				curve: Spring
				time: .15
		
		Utils.delay .2, =>
			@animate
				scale: 1
				rotation: 0
				options:
					curve: Spring
					time: .1
		
	
	return background

# InputChoice

class InputChoice extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		options.text ?= "Choice"
		options.callback ?= -> null
		
		super _.defaults options,
			name: "Input Choice"
			height: 48
			backgroundColor: colors.choiceText
			borderRadius: 16
# 			borderWidth: 1
# 			borderColor: colors.choiceText
		
		@contentLayer = new Type.Regular
			parent: @
			padding: {left: 16, right: 16}
			x: 0
			y: Align.center
			color: colors.choiceBackground
			text: options.text
		
		@width = @contentLayer.width
		
		delete @__constructor

# ChatAvatar

# Just a regular layer - set it with an image or background color, etc.

class ChatAvatar extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.assign options,
			height: 24
			width: 24
			borderRadius: 16
			backgroundColor: '#333'
		
		super _.defaults options,
			name: "Chat Avatar"
		
		delete @__constructor

# Chat Base Components

# Chat Container

# base class for all chat contents

class ChatContainer extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		@align = options.align ? "left"
		
		super _.defaults options,
			name: "Chat Container"
			backgroundColor: null
			width: Screen.width
			animationOptions:
				time: .35
			
		# layers
			
		@backgroundLayer = new Layer
			name: "Background Container"
			parent: @
			x: 32
			width: @width
			borderRadius: 16
			backgroundColor: '#fff'
			borderWidth: 1
			borderColor: colors.border
			clip: true
			animationOptions: @animationOptions
		
		
		# avatar 
		@avatarLayer = new ChatAvatar
			parent: @
			y: Align.bottom
			image: options.image
			animationOptions: @animationOptions
		
		delete @__constructor
		
		@backgroundLayer.on "change:height", => 
			@height = @backgroundLayer.height
		
		@on "change:height", -> @avatarLayer?.y = Align.bottom()
		
	hide: ->
		@animate
			height: 0
	
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor
	
	setAlignment: ->
		switch @align
			when "left"
				@avatarLayer.x = 16
				@backgroundLayer.x = 48
			when "right"
				@avatarLayer.x = Align.right(-16)
				@backgroundLayer.x = Align.right(-48)
	
	clampLayerWidth: (layer) ->
		layer.width = _.clamp(
			layer.width,
			32,
			Screen.width - 64
			)
	
	setSizeToLayer: (layer, padding = 16) ->
		_.assign @backgroundLayer,
			height: layer.maxY + padding
			width: layer.maxX + padding
	
	hideAvatar: (animate = true) ->
		return if not @avatarLayer
		@avatarLayer?.destroy()
		delete @avatarLayer
		
		if animate
			@backgroundLayer.animate
				x: if @align is "left" then 16 else Align.right(-16)


# Choice Container

class ChoiceContainer extends ChatContainer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.defaults options,
			name: "Choice Container"
			text: "Choice Container's header text."
			callback: -> null
		
		@choices = options.choices ?= [
			{text: "Choice 1", callback: -> null},
			{text: "Choice 2", callback: -> null}
		]
		
		@choice = undefined
		@callback = options.callback
		
		super options
		
		# layers
		
		# header
		
		@header = new Layer
			name: "Header"
			parent: @backgroundLayer
			width: 268
			height: 50
			x: 0
			backgroundColor: null
			image: options.image
		
		@clampLayerWidth(@header)
		
		# choices
		
		@choicesContent = new Layer
			name: "Choices Content"
			parent: @backgroundLayer
			y: @header.maxY
			width: @header.width
			height: @choices.length * 50
			backgroundColor: null
		
		@clampLayerWidth(@header)
		@setSizeToLayer(@choicesContent, 0)
		
		# make text choices
		
		for choice, i in @choices
		
			textBox = new TextChoice
				parent: @choicesContent
				width: @choicesContent.width - 2
				x: 1
				y: i * 50
				box: @
				text: choice.text
				callback: choice.callback

		delete @__constructor
		
		@setAlignment()
	
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor
	
	makeChoice: (choice) =>
		return if _.last(@chatView.chats) isnt @
		
		@emit "choice", choice, @
		@chatView?.addChat new ChatBubble
			align: "right"
			text: choice.text
			
		@chatView?.inputs = []
		
		Utils.delay 1, => choice.callback()
		Utils.delay 2, => @callback()
		
		@choice = choice

# Grid Choice Container

# chatView: the chat view where this grid choice container lives
# choices: array of choice objects
# height: the height of the grid choices
# spacing: the spacing between choices
# callback: what happens when the user confirms a choice

class GridChoiceContainer extends ChatContainer
	constructor: (options = {}) ->
		@__constructor = true

		options.chatView ?= throw "Grid Choice Container needs a chatView"
		
		_.defaults options,
			name: "Grid Choice Container"
			callback: -> null
			align: 'full'
			radio: false
		
		@choices = options.choices ? [
			{text: "Choice 1", image: Utils.randomImage(), callback: -> null},
			{text: "Choice 2", image: Utils.randomImage(), callback: -> null},
			{text: "Choice 3", image: Utils.randomImage(), callback: -> null},
			{text: "Choice 4", image: Utils.randomImage(), callback: -> null},
			{text: "Choice 5", image: Utils.randomImage(), callback: -> null},
			{text: "Choice 6", image: Utils.randomImage(), callback: -> null},
		]
		
		@selections = []
		
		@callback = options.callback
		@chatView = options.chatView
		
		super options
		
		# add a "done" input to chatview inputs
		doneChoice = {
			text: 'Done'
			callback: => @makeChoice()
			silent: true
		}
		
		@chatView.inputs = doneChoice
					
		@hideAvatar(animate = false)
		
		_.assign @backgroundLayer, 
			x: 0
			width: @width
			borderRadius: 0
			borderWidth: 0
			backgroundColor: null
		
		_.defaults options,
			height: 96
			spacing: 8
		
		# layers
		
		# header
		
		# choices
		
		# make text choices
		
		for choice, i in @choices
		
			choiceBox = new GridChoice
				parent: @backgroundLayer
				x: options.spacing + (i % 2 * ((@width - options.spacing) / 2))
				y: (options.height + options.spacing) * Math.floor( i / 2 )
				width: (@width - (options.spacing * 3)) / 2
				height: options.height
				image: choice.image
				callback: choice.callback
				choice: choice
			
			do (choiceBox, choice) =>
				choiceBox.onTap =>
					return if _.last(@chatView.chats) isnt @
					
					choiceBox.toggleSelected()
					
					if options.radio
						for box in choiceBox.siblings
							box.selected = false
						
					if choiceBox.selected then @selections.push(choice)
					else _.pull(@selections, choiceBox)
				
		@backgroundLayer.height = choiceBox.maxY

		delete @__constructor
		
		@setAlignment()
	
	setStyle: (style) -> null
	
	makeChoice: =>
		return if _.last(@chatView.chats) isnt @
		return if not @selections[0]?
		
		@emit "selection", @selections, @
		@chatView?.addChat new ChatBubble
			align: "right"
			text: ' ' + choice.text for choice in @selections
		
		Utils.delay 2, => @callback()

# Grid Choice

class GridChoice extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
# 		_.assign options,
		
		_.defaults options,
			name: "Grid Choice"
			width: (Screen.width / 2) - 8
			height: 128
			borderRadius: 16
			saturate: 80
			
		@link = options.link ? {
			text: 'Choice', 
			image: Utils.randomImage(), 
			callback: -> null
		}
		
		@choice = options.choice
		
		super options
		
		# layers
		
		@labelLayer = new Type.H3
			parent: @
			x: 0
			y: Align.center
			width: @width
			textAlign: 'center'
			color: '#FFF'
			text: @choice.text
		
		@selectedIcon = new Icon
			parent: @
			x: Align.right(-8)
			y: 8
			icon: 'menu'
			color: '#FFF'
		
		@on "change:selected", @setSelected
		
		delete @__constructor
		
		@selected = options.selected
	
	toggleSelected: =>
		@selected = !@selected
	
	setSelected: =>
		if @selected then @showSelected()
		else @showDeselected()
	
	showSelected: ->
		@selectedIcon.icon = 'radiobox-marked'
		
	showDeselected: ->
		@selectedIcon.icon = 'radiobox-blank'
	
	@define "selected",
		get: -> return @_selected
		set: (bool) ->
			return if @__constructor
			
			@_selected = bool
			
			@emit "change:selected", bool, @

# Choice Scroll

class ChoiceScroll extends ChatContainer
	constructor: (options = {}) ->
		@__constructor = true
		
		super _.defaults options,
			name: "Image Choice Scroll"
			align: "full"
					
		@hideAvatar(animate = false)
		
		_.assign @backgroundLayer, 
			x: 0
			width: @width
			height: 340
			borderRadius: 0
		
		@scrollLayer = new ScrollComponent
			name: "Scroll"
			parent: @backgroundLayer
			width: @width
			height: @height
			scrollVertical: false
			contentInset: {right: 16}
			
		# hacky scroll solution
		
		Utils.delay 0, =>
			@parent.parent.onScrollStart => @scrollLayer.scrollHorizontal = false
			@parent.parent.onScrollEnd => @scrollLayer.scrollHorizontal = true
		
		@scrollLayer.onScrollStart => @parent.parent.scrollVertical = false
		@scrollLayer.onScrollEnd => @parent.parent.scrollVertical = true
		
		delete @__constructor
			
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor
	
	makeChoice: (choice, link) =>
		return if _.last(@chatView.chats) isnt @
		
		@chatView?.addChat new ChatBubble
			align: "right"
			text: choice.text
			
		@chatView?.inputs = []
		
		Utils.delay 1, => choice.callback()
		
		@choice = choice

# Text Choice

class TextChoice extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		@text = options.text ?= "Example Choice"
		@callback = options.callback ?= throw "Text Choice needs a callback."
		@box = options.box ? throw 'Text Choice needs a TextChoiceBox.'
		
		super _.defaults options,
			name: "Text Choice"
			height: 50
			backgroundColor: colors.choiceBackground
			shadowY: -1
			shadowColor: colors.border
			
		@contentLayer = new Type.Link
			name: "Text Content"
			parent: @
			x: 0
			y: Align.center
			width: @width
			textAlign: 'center'
			color: colors.choiceText
			text: options.text
			animationOptions: @animationOptions 
		
		delete @__constructor
		
		@onTap @sendChoice 
	
	sendChoice: =>
		return if @box.choice?
		
		@box.makeChoice(@)

# Chat Components

# Chat Bubble
# -- Just a text message in the chat, extends chat container

# properties:
# chat.text (The chat bubble's text content)

class ChatBubble extends ChatContainer
	constructor: (options = {}) ->
		@__constructor = true
		
		options.text ?= "Chat bubble text content."
		
		super _.defaults options,
			name: "Chat Bubble"
			
		# layers
		
		@contentLayer = new Type.Regular
			name: "Text Content"
			parent: @backgroundLayer
			x: 16
			y: 16
			text: options.text
			animationOptions: @animationOptions
			padding: {}
		
		@clampLayerWidth(@contentLayer)
		@setSizeToLayer(@contentLayer)
		@setAlignment()

		delete @__constructor
	
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor
		@contentLayer.color = style.color

# Chat Giphy
# -- A giphy chat bubble. Returns a random giphy image using a search query.

# properties:
# chat.query (The search query to make)

class ChatGiphy extends ChatContainer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.defaults options,
			name: "Chat Giphy"
			query: "easy"
		
		super options
			
		# layers
		
		@gifLayer = new Layer
			name: "Text Content"
			parent: @backgroundLayer
			width: 200
			height: 129
		
		Utils.getGiphy(@gifLayer, options.query)
		
		@clampLayerWidth(@gifLayer, 0)
		@setSizeToLayer(@gifLayer, 0)
		@setAlignment()

		delete @__constructor
	
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor

# Text Choice Box

class TextChoiceBox extends ChoiceContainer
	constructor: (options = {}) ->
		@__constructor = true
		
		super _.defaults options,
			name: "Text Choice Box"
			text: "Text choice header content."
			choices: [
				{text: "Choice 1", callback: -> null}
				{text: "Choice 2", callback: -> null}
				{text: "Choice 3", callback: -> null}
			]
			
		# layers
		
		# header
		
		@headerContent = new Type.Regular
			name: "Header Content"
			parent: @header
			x: 0
			y: 16
			width: @header.width
			textAlign: "center"
			text: options.text
			animationOptions: @animationOptions
		
		delete @__constructor
	
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor
		@headerContent.color = style.color

# Link Choice Box

class LinkChoiceBox extends ChoiceContainer
	constructor: (options = {}) ->
		@__constructor = true
		
		@chatView = undefined

		@link = options.link ?= {
			title: "Example Link"
			subtitle: "examplelink.geocities.com"
			image: Utils.randomImage()
		} 
		
		options.choices ?= [
			{text: "More like this", callback: -> null},
			{text: "Less like this", callback: -> null}
		]
		
		super _.defaults options,
			name: "Link Choice Box"
			text: "Link Choice's header text."
			
		# layers
		
		# header
		
		@header.height = 240
		@header.backgroundColor = '#FFF'
		
		link = @link
		
		do _.bind(-> # header
			
			@linkImage = new Layer
				parent: @
				width: @width 
				height: @height - 64
				image: link.image
			
			@linkTitle = new Type.Regular
				parent: @
				width: @width
				height: 18
				y: @linkImage.maxY + 16
				text: link.title
				truncate: true
			
			@linkSubtitle = new Type.Caption
				parent: @
				width: @width
				height: 18
				y: @linkTitle.maxY + 4
				text: link.subtitle
				truncate: true
		
		, @header)
		
		# move choices
		@choicesContent.y = @header.maxY
		@setSizeToLayer(@choicesContent, 0)

		delete @__constructor
		
		@setAlignment()
	
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor
		@header.linkTitle.color = style.color
		@header.linkSubtitle.color = new Color(style.color).alpha(.8)
	
	makeChoice: (choice, link) =>
		@emit "choice", choice, @link, @
		
		@chatView?.addChat new ChatBubble
			align: "right"
			text: choice.text ? link.title
			
		@choice = choice
		
		@chatView?.inputs = []
		
		Utils.delay 1, => choice.callback()

# Link Choice Scroll

class LinkChoiceScroll extends ChoiceScroll
	constructor: (options = {}) ->
		@__constructor = true
		
		@links = options.links ?= [
			{
				title: "Example Link 1"
				subtitle: "examplelink.geocities.com"
				image: Utils.randomImage()
				callback: -> null
			}, {
				title: "Example Link 2"
				subtitle: "examplelink.geocities.com"
				image: Utils.randomImage()
				callback: -> null
			}, {
				title: "Example Link 3"
				subtitle: "examplelink.geocities.com"
				image: Utils.randomImage()
				callback: -> null
			}
		]
		
		super _.defaults options,
			name: "Link Choice Scroll"
			align: "full"
		
		# make links 
		
		last = undefined
		
		for link, i in @links
			newLink = new LinkChoiceBox
				parent: @scrollLayer.content
				link: link
				choices: link.choices
				
			newLink.avatarLayer.destroy()
			newLink.backgroundLayer.x = 0
			newLink.size = newLink.backgroundLayer.size
			newLink.x = (last?.maxX ? 0) + 16
			newLink.on "choice", (choice, link) => 
				return if @choice?
				@choice = choice
				
			last = newLink
		
		@scrollLayer.updateContent()
		
		delete @__constructor
	
	setStyle: (style) ->
		@backgroundLayer.backgroundColor = style.backgroundColor

# Person Choice Scroll


class PersonChoiceScroll extends ChoiceScroll
	constructor: (options = {}) ->
		@__constructor = true
		
		@links = options.links ?= [new Person, new Person]
		
		@callback = options.callback ?= -> null
		
		@chatView = options.chatView ? throw 'PersonChoiceScroll needs a chatView.'
		
		@linkLayers = []
		
		@_active = true
		
		_.defaults options,
			name: "Person Choice Scroll"
			align: "full"
			clip: true
			
		super options
		
		_.assign @backgroundLayer,
			height: 112
		
		# make links
		
		last = undefined
		lowest = {maxY: 0}
		
		for person, i in @links
			linkLayer = new PersonChoice
				parent: @scrollLayer.content
				x: (last?.maxX ? 0) + 16
				
			do (linkLayer, person) => 
				linkLayer.onTap => @makeChoice(linkLayer, person)
			
			if linkLayer.maxY > lowest.maxY then lowest = linkLayer
			
			last = linkLayer
			
			@linkLayers.push(linkLayer)
		
		# set heights based on tallest link
		
		@scrollLayer.height = lowest.maxY
		
		# done Button
		
		noThanksContainer = new Layer
			parent: @
			height: @height
			y: @scrollLayer.maxY
			width: @width / 2
			height: 50
			backgroundColor: colors.chatFill
			borderWidth: 1
			borderColor: colors.border
		
		noThanksLink = new Type.Link
			parent: noThanksContainer
			x: Align.center
			y: Align.center
			color: colors.choiceText
			text: 'No Thanks'
		
		doneContainer = new Layer
			parent: @
			height: @height
			x: Align.right
			y: @scrollLayer.maxY
			width: @width / 2
			height: 50
			backgroundColor: colors.chatFill
			borderWidth: 1
			borderColor: colors.border
		
		doneLink = new Type.Link
			parent: doneContainer
			x: Align.center
			y: Align.center
			color: colors.choiceText
			text: 'Invite These Friends'
		
		@backgroundLayer.height = doneContainer.maxY
		
		@scrollLayer.updateContent()
			
		# events
		
		doneContainer.onTap => @hideButtons(true)
		noThanksContainer.onTap => @hideButtons(false)
		
		delete @__constructor
			
	setStyle: (style) ->
		@scrollLayer.content.backgroundColor = style.backgroundColor
		@backgroundLayer.backgroundColor = style.backgroundColor

	hideButtons: (sendInvites) =>
		
		if sendInvites
			
			@height = @scrollLayer.maxY
			@backgroundLayer.height = @scrollLayer.maxY
			@_active = false
			
			Utils.delay .75, => 
				
				@chatView.addChat new ChatBubble
					text: "Sure, invite these friends."
					align: 'right'
					
			Utils.delay 2, => 
				mainChat.eezyButton.pulse()
				@chatView.addChat new ChatBubble
					text: Utils.randomChoice([
						"Cool, I'll see if they want to come too.", 
						"Ok, I'll send out the invites.", 
						"Ok, I'll invite them."
					])
		
		else
		
			@chatView.removeChat(@)
			@destroy()
		
			for linkLayer in @linkLayers
				linkLayer.selected = false
			
			Utils.delay .75, => 
				@chatView.addChat new ChatBubble
					text: "No thanks."
					align: 'right'
				
			Utils.delay 2, => 
				@chatView.addChat new ChatBubble
					text: Utils.randomChoice([
						"Cool, we'll keep it to just you.", 
						"Ok, no invites for now.", 
						"Ok, just you for now."
					])
			
		Utils.delay 3, => 
			@callback()

	makeChoice: (linkLayer, person) =>
		return if not @_active
		
		linkLayer.toggleSelected()
		
		# add or remove selected person from plan
		if linkLayer.selected then plan.people.push(person)
		else _.pull(plan.people, person)

# Person Choice

class PersonChoice extends Layer
	constructor: (options = {}) ->
		@__constructor = true
	
		_.assign options,
			width: 80
			backgroundColor: null
			
		_.defaults options,
			name: "Person Choice"
			link: new Person
			selected: false
			
		@link = options.link
		
		super options
		
		# layers
	
		@imageLayer = new Layer
			parent: @
			x: Align.center
			y: 16
			width: 64
			height: 64
			borderRadius: 32
			borderColor: colors.border
			borderWidth: 1
			image: @link.image
			link: @link
		
		@labelLayer = new Type.Caption
			parent: @
			x: 0
			y: @imageLayer.maxY + 8
			width: @width
			textAlign: 'center'
			color: '#000'
			text: @link.name
			
		@selectedIcon = new Icon
			parent: @
			icon: 'check'
			color: colors.cta
			x: Align.right
			visible: false
		
		@height = @labelLayer.maxY + 14
		
		@on "change:selected", @setSelected
		
		delete @__constructor
		
		@selected = options.selected
	
	toggleSelected: =>
		@selected = !@selected
	
	setSelected: =>
		if @selected then @showSelected()
		else @showDeselected()
	
	showSelected: -> 
		@imageLayer.brightness = 75
		@selectedIcon.visible = true
		
	showDeselected: -> 
		@imageLayer.brightness = 100
		@selectedIcon.visible = false
	
	@define "selected",
		get: -> return @_selected
		set: (bool) ->
			return if @__constructor
			
			@_selected = bool
			
			@emit "change:selected", bool, @

# Plan Modal

class PlanModal extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.assign options,
			size: Screen.size
			backgroundColor: 'rgba(0,0,0,.88)'
			opacity: 0
		
		super _.defaults options,
			name: "Plan Modal"
			animationOptions:
				time: .25
		
		# layers
		
		@modalLayer = new Layer
			parent: @
			point: Align.center
			width: Screen.width * .8
			height: Screen.height * .62
			backgroundColor: colors.modalBackground
			opacity: 0
			borderRadius: 4
			clip: true
			animationOptions: @animationOptions
		
		do _.bind(->
				
			@imageLayer = new Layer
				name: 'Image'
				parent: @
				width: @width
				image: plan.where.image
				opacity: .78
			
			budgetColor = if plan.choices.where then colors.chosen else colors.suggested 
			
			for i in _.range(5) 
				new Icon
					name: '.'
					parent: @
					y: 16, x: 16 + (i * 16)
					icon: 'currency-usd'
					color: if i < plan.where.budget then budgetColor else 'rgba(0,0,0,.25)'
			
			# call to action 
			
			@addToPlanCTA = new Layer
				parent: @
				width: @width * .82
				height: 48
				x: Align.center
				y: @imageLayer.maxY - 24
				borderRadius: 4
				backgroundColor: colors.cta
			
			@addToPlanLabel = new Type.Regular
				parent: @addToPlanCTA
				width: @addToPlanCTA.width
				textAlign: 'center'
				fontWeight: 600
				x: 0
				y: Align.center
				text: 'Add to Plan'
				color: '#000'
				
			# where
			
			@whereIcon = new Icon
				parent: @
				name: '.'
				icon: 'fire'
				y: @imageLayer.maxY + 40
				x: 16
			
			@venueName = new Type.Regular
				parent: @
				name: 'Venue name'
				y: @whereIcon.y + 4
				x: @whereIcon.maxX + 8
				text: plan.where.name
				color: if plan.choices.where then colors.chosen else colors.suggested
			
			# when
			
			@whenIcon = new Icon
				parent: @
				name: '.'
				icon: 'clock'
				y: @whereIcon.maxY + 16
				x: 16
			
			timeUntil = Utils.timeUntil(plan.when)
			
			@howSoon = new Type.Regular
				parent: @
				name: 'How soon'
				y: @whenIcon.y + 4
				x: @whenIcon.maxX + 8
				text: timeUntil.hours + ' hours, ' + timeUntil.minutes + " minutes"
				color: if plan.choices.when then colors.chosen else colors.suggested
			
			# distance
			
			@distanceIcon = new Icon
				parent: @
				name: '.'
				icon: 'map'
				y: @whenIcon.maxY + 16
				x: 16
			
			@howFar = new Type.Regular
				parent: @
				name: 'How far'
				y: @distanceIcon.y + 4
				x: @distanceIcon.maxX + 8
				text: plan.where.distance + ' miles'
				color: if plan.choices.where then colors.chosen else colors.suggested
			
			# who
			
			@whoIcon = new Icon
				parent: @
				name: '.'
				icon: 'account'
				y: @distanceIcon.maxY + 16
				x: 16
				
			@sendInvite = new Type.Regular
				parent: @
				name: 'Send invite'
				y: @whoIcon.y + 4
				x: @whoIcon.maxX + 8
				text: "Send an invite to: "
			
		
		, @modalLayer)
		
		delete @__constructor

		@modalLayer.onTap (event) -> event.stopPropagation()
		@onTap @close
		
		@modalLayer.addToPlanCTA.onTouchStart -> @brightness = 80
		@modalLayer.addToPlanCTA.onTouchEnd ->	 @brightness = 100
		
		@modalLayer.addToPlanCTA.onTap => 
			Utils.delay .15, @close
			plan.confirm()
			
			makeSideChat({plan: plan})
		
		@open()
	
	open: =>
		@animate
			opacity: 1
		
		@modalLayer.animate
			opacity: 1
			delay: .1
	
	close: =>
		@animate
			opacity: 0
		
		@onAnimationEnd _.once(@destroy)

# Plan Detail Modal

class PlanDetailModal extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.assign options,
			size: Screen.size
			backgroundColor: '#4455bb'
			opacity: 1
		
		_.defaults options,
			name: "Plan Modal"
			plan: new Plan
			animationOptions:
				time: .25
		
		@plan = options.plan
		
		super options
		
		# layers
		
		@planImage = new Layer
			name: 'Image'
			parent: @
			x: Align.center
			y: 32
			width: 48
			height: 48
			borderRadius: 36
			backgroundColor: colors.medium
			
		@planName = new Type.Regular
			name: 'Plan Name'
			parent: @
			x: 0
			y: @planImage.maxY + 16
			width: @width
			fontSize: 18
			textAlign: 'center'
			color: "#FFF"
			text: @plan.name
		
		@userName = new Type.Regular
			name: 'Plan Name'
			parent: @
			x: 0
			y: @planName.maxY + 8
			width: @width
			textAlign: 'center'
			color: "#CCC"
			text: "User Namingtion"
		
		for plan, i in user.plans
			# make class
			planContainer = new Layer
				parent: @
				width: @width - 32
				x: 16
				y: @userName.maxY + 32 + (i * 96 + 16)
				height: 96
				backgroundColor: '#00a8f9'
			
			planImage = new Layer
				name: 'Plan Image'
				parent: planContainer
				x: 16
				width: 48
				height: 48
				borderRadius: 24
				backgroundColor: colors.medium
				y: 16
			
			venueName = new Type.Regular
				name: 'Venue Name'
				parent: planContainer
				x: 80
				y: 16
				fontSize: 18
				width: planContainer.width - 32
				color: "#FFF"
				text: plan.where.name
			
			venueType = new Type.Regular
				name: 'Venue Type'
				parent: planContainer
				x: 80
				y: venueName.maxY + 4
				width: planContainer.width - 32
				color: colors.medium
				text: _.startCase(plan.where.type)
				
			startTime = plan.when.toLocaleTimeString([], {'hour': '2-digit', 'hour12': true})
		
			venueTime = new Type.Regular
				name: 'Venue Type'
				parent: planContainer
				x: 80
				y: venueType.maxY + 4
				width: planContainer.width - 32
				color: colors.medium
				text: startTime.toUpperCase()
				
			planIcon = new Icon
				name: 'Plan Icon'
				parent: planContainer
				x: Align.right(-16)
				icon: 'chevron-right'
				color: '#FFF'
				
				
			planContainer.height = venueTime.maxY + 16
			planImage.y = Align.center
			planIcon.y = Align.center
				
		@onTap -> flow.showPrevious()

# ----------------------------------------------

# Create Flow
flow = new Flow
flow.header.backgroundColor = colors.medium
flow.header.visible = false
# flow.header.statusBar.invert = 100

# Create a User
user = database.user = new User

_.assign user,
	plans: []
	drafts: []

# Create an Itinerary

# Create Some Data
kebabTruck = new Place
	name: "Whitmore's Fyne Kebabs"
	type: 'restaurant'
	location: 'london'
	address: '54th and Broadway'
	image: Utils.randomImage()
	budget: 3 # out of 5
	rating: 4 # out of 5
	distance: 1.5

diveBar = new Place
	name: 'The Black Cell'
	type: 'bar'
	location: 'london'
	address: '21st and Canal'
	image: Utils.randomImage()
	budget: 1 # out of 5
	rating: 2 # out of 5
	distance: .8

# Create Temporary Plan
plan = new Plan

# Onboarding

# States for visual animations

Phone.states.hide = 
	opacity: 0
	y: 60
	
Phone.states.show = 
	opacity: 1
	y: 40
	options: 
		time: 1

Mac.states.hide = 
	opacity: 0
	y: 30

Mac.states.show = 
	opacity: 1
	y: 5
	options: 
		time: 1
		delay: 0.1

Message1.states.hide = 
	opacity: 0
	y: 260

Message1.states.show = 
	opacity: 1
	y: 290
	options: 
		time: 1

Message2.states.hide = 
	opacity: 0
	y: 350

Message2.states.show = 
	opacity: 1
	y: 340
	options: 
		time: 1
		delay: 0.2

Photo1.states.hide = 
	opacity: 0
	x: 155
	y: 260
	rotation: 0

Photo1.states.show = 
	opacity: 1
	x: 120
	y: 260
	rotation: -15
	options: 
		time: 1
	
Photo2.states.hide = 
	opacity: 0
	x: 165
	y: 270
	rotation: 0
	
Photo2.states.show = 
	opacity: 1
	x: 200
	y: 270
	rotation: 15
	options: 
		time: 1

for layer in [Fiber, description, eezy_icon, GetStarted]
	layer.opacity = 0
	
eezy_icon.animate
	opacity:1
	rotation: 0
	options:
		delay: 0.5
		
description.animate
	opacity:1
	rotation: 0
	y: 449
	options:
		delay: 0.8		
				
# Animate the title and start button in when the last logo piece animates
eezy_icon.onAnimationStart ->
	Fiber.animate
		opacity: 1
		y: 390
			
	GetStarted.animate
		opacity: 1
		y: 530
		options: 
			delay: 0.9

IndicatorDots.opacity = 0
activateDot = (index) ->
	IndicatorDots.children[index].animate
		opacity: 1
		scale: 1.1	

# Fires right after the Flow Component changes a page 
flow.onTransitionEnd ->
	for layer in [Phone, Mac, Message1, Message2, Photo1, Photo2]
		layer.stateSwitch("hide")
		
	for dot in IndicatorDots.children
		dot.animate
			opacity: 0.5
			scale: 1
	
	if flow.current is OnboardingConnect
		Phone.animate("show")
		Mac.animate("show")
		activateDot(0)
	
	if flow.current is OnboardingChat
		Message1.animate("show")
		Message2.animate("show")
		activateDot(1)
	
	if flow.current is OnboardingShare
		Photo1.animate("show")
		Photo2.animate("show")
		activateDot(2)
	
	# Show indicator dots after welcome screen
	if flow.current isnt Welcome
		IndicatorDots.animate
			opacity: 1
			options: 
				time: 0.3

GetStarted.onTap ->
	flow.showNext(OnboardingConnect)

ConnectNext.onTap ->
	flow.showNext(OnboardingChat)
	
ChatNext.onTap ->
	flow.showNext(OnboardingShare)

Restart.onTap ->
	flow.showNext(mainChat)
	flow.header.opacity = 0
	flow.header.visible = true
	flow.header.animate { opacity: 1 }
	
	greeting()

# Create Chat Views
chatViews = []
sideChatViews = []

# Main Chat

# ---------------------
# Set up the view

mainChat = new ChatView
	title: 'Main Chat'
	left: 
		icon: 'menu'
		action: -> flow.showOverlayLeft(side_menu)
# 	right:
# 		icon: 'navigation'
	leftAvatar: 
		backgroundColor: '#23c7cf'
	rightAvatar: 
		backgroundColor: '#a4a3a5'
	padding:
		sameSender: 8
		differentSenders: 24
	leftStyle:
		backgroundColor: colors.chatFill
		color: '#000'
	rightStyle:
		backgroundColor: '#484848'
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
	mainChat.inputs = []
	
	Utils.delay .75, => 
		mainChat.addChat new ChatGiphy
			query: 'hi'
		
		
	Utils.delay 4, => askFood()

# ---
# Ask the user what they want to do

askFood = ->
	
	mainChat.addChat new ChatBubble
		text: "So... what food don't you like?"
	
	foodChoices = [
		{text: "Italian", image: Utils.randomImage(), callback: -> null},
		{text: "Pub Food", image: Utils.randomImage(), callback: -> null},
		{text: "Mexican", image: Utils.randomImage(), callback: -> null},
		{text: "Sushi", image: Utils.randomImage(), callback: -> null},
		{text: "Algae", image: Utils.randomImage(), callback: -> null},
		{text: "Kebabs", image: Utils.randomImage(), callback: -> null}
	]
	
	Utils.delay 1, -> 
		mainChat.addChat food = new GridChoiceContainer
			text: 'Hi there'
			chatView: mainChat
			choices: foodChoices
			callback: -> 
				
				mainChat.addChat new ChatBubble
					text: "Ok, none of those."
		
				Utils.delay 1.5, -> 
					mainChat.addChat new ChatGiphy
						query: food.selections[0].text
					
				Utils.delay 3, -> askWhat()

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
	
	people = [
		new Person, 
		new Person, 
		new Person, 
		new Person, 
		new Person
		]
	
	mainChat.addChat new ChatBubble
		text: 'Want to invite some friends?'
	
	Utils.delay 1.5, -> 
		mainChat.addChat new PersonChoiceScroll
			chatView: mainChat
			links: people
			callback: -> 
				
				mainChat.inputs = [
					{
						text: 'Start over.', callback: -> greeting()
					}
				]


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
	
	mainChat.eezyButton.pulse()

# confirm that something has been added to the user's plan
confirmAdded = ->
	mainChat.addChat new ChatBubble
		text: Utils.randomChoice([
			"Ok, it's on your plan.", 
			'Added to your plan.', 
			"Right on, that's sorted."
		])
	
	mainChat.eezyButton.pulse()

# confirm that something has been added to the user's plan
confirmPeople = (sendInvites) ->
	if sendInvites
		mainChat.addChat new ChatBubble
			text: Utils.randomChoice([
				"Cool, they're added to your plan.", 
				"Ok, I'll send out the invites.", 
				"Ok, I'll invite them."
			])
		mainChat.eezyButton.pulse()
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

# Sticker Sheet

showStickerSheet = ->
	stickerSheet = new ChatView
		title: 'Main Chat'
		left: 
			icon: 'menu'
			action: -> flow.showOverlayLeft(side_menu)
		leftAvatar: 
			backgroundColor: '#23c7cf'
		rightAvatar: 
			backgroundColor: '#a4a3a5'
		padding:
			sameSender: 8
			differentSenders: 24
		leftStyle:
			backgroundColor: colors.chatFill
			color: '#000'
		rightStyle:
			backgroundColor: '#484848'
			color: '#FFF'
	
	stickerSheet.subject = "a stickersheet"
	
	# ---------------------
	# Callback Script
		
	stickerSheetGreeting = ->
		stickerSheet.addChat new ChatBubble
			text: 'This chat is for ' + stickerSheet.subject
		
		Utils.delay 1, -> 
			showChatBubble()
	
	
	# Chat Bubble
	
	showChatBubble = ->
		stickerSheet.addChat new ChatBubble
			text: 'This a chat bubble.'
			
		Utils.delay 1, -> 
			showRightChatBubble()
	
	# right aligned Chat Bubble
	showRightChatBubble = ->
		stickerSheet.addChat new ChatBubble
			text: 'This a right chat bubble.'
			align: 'right'
			
		Utils.delay 1, -> 
			showChatGiphy()
	
	
	# Chat Giphy
	
	showChatGiphy = ->
		stickerSheet.addChat new ChatGiphy
			query: 'welcome'
		
		Utils.delay 1, -> 
			showTextChoice()
	
	# Text Choice
	
	showTextChoice = ->
		drinkChoice = 
			text: "Drinking"
			callback: -> null
		
		eatChoice =
			text: "Eating"
			callback: -> null
		
		stickerSheet.addChat new TextChoiceBox
		
		Utils.delay 1, -> 
			showLinkChoiceBox()
	
	# Link Choice Box
	
	showLinkChoiceBox = ->
		
		link = 
			title: "Example Link 1"
			subtitle: "examplelink.geocities.com"
			image: Utils.randomImage()
			callback: -> null
		
		okay = 
			text: "Okay"
			callback: -> null
			
		noThanks =
			text: "No way"
			callback: -> null
		
		stickerSheet.addChat new LinkChoiceBox
			link: link
			choices: [okay, noThanks]
		
		Utils.delay 1, ->
			showLinkChoiceScroll()
	
	# Link Choice Scroll
	
	showLinkChoiceScroll = ->
		
		okay = 
			text: "Okay"
			callback: -> null
			
		noThanks =
			text: "No way"
			callback: -> null
		
		link1 = 
			title: "Example Link 1"
			subtitle: "examplelink.geocities.com"
			image: Utils.randomImage()
			callback: -> null
			choices: [okay, noThanks]
		
		link2 =
			title: "Example Link 1"
			subtitle: "examplelink.geocities.com"
			image: Utils.randomImage()
			callback: -> null
			choices: [okay, noThanks]
	
		link3 =
			title: "Example Link 2"
			subtitle: "examplelink.geocities.com"
			image: Utils.randomImage()
			callback: -> null
			choices: [okay, noThanks]
		
		stickerSheet.addChat new LinkChoiceScroll
			links: [link1, link2, link3]
			chatView: stickerSheet
		
		Utils.delay 1, -> showPersonChoiceScroll()
	
	# Person Choice Scroll
	
	showPersonChoiceScroll = ->
		stickerSheet.addChat new PersonChoiceScroll
			chatView: stickerSheet
		
		people = [
			new Person, 
			new Person, 
			new Person, 
			new Person, 
			new Person
			]
		
		mainChat.addChat new ChatBubble
			text: 'Want to invite some friends?'
			links: people
			callback: -> null
			
		Utils.delay 1, -> showGridChoice()
	
	# Grid Choice
	
	showGridChoice = ->
		
		foodChoices = [
			{text: "Italian", image: Utils.randomImage(), callback: -> null},
			{text: "Pub Food", image: Utils.randomImage(), callback: -> null},
			{text: "Mexican", image: Utils.randomImage(), callback: -> null},
			{text: "Sushi", image: Utils.randomImage(), callback: -> null},
			{text: "Algae", image: Utils.randomImage(), callback: -> null},
			{text: "Kebabs", image: Utils.randomImage(), callback: -> null}
		]
		
		stickerSheet.addChat new GridChoiceContainer
			chatView: stickerSheet
			choices: foodChoices
			
	stickerSheetGreeting()
	flow.showNext(stickerSheet)
	
	


# Make Side Chat (when plan is confirmed)

makeSideChat = (options = {}) ->
	
	viewAlready = _.find(sideChatViews, {plan: options.plan})
	if viewAlready?
		flow.showNext(viewAlready)
		return
	
	newChat = new SideChatView options
	
	flow.showNext(newChat)
	
	newChat.addChat new ChatBubble
		text: 'Your plan is confirmed!'
	
	

# ----------------------------------------------
# Start Flow

flow.header.visible = true
flow.bringToFront()
flow.showNext(mainChat)
greeting()

# flow.showOverlayBottom(new PlanDetailModal)

# showStickerSheet()