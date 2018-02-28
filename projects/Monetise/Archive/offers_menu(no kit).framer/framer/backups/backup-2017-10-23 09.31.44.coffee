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

# Plan

class Plan
	constructor: (options = {}) ->
		defaultWhen = new Date()
		defaultWhen.setHours(21, 0)
		
		@what = options.what ? 'eat'
		@where = options.where ? kebabTruck
		@when = options.when ? defaultWhen
		@budget = options.budget ? 0
		
		@people = options.people ? []
		@confirmed = options.confirmed ? false
		
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
	_.defaults options,
		name: "Tammy Williams"
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

# chat view

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
		
# 		chatButton = new ChatViewButton
# 			view: @
# 			parent: flow?.header
# 			x: Align.right(-8 - (chatViews.length * 36))
# 			y: Align.bottom(-8)
		
		# Create Eezy Button
		eezyButton = new EezyButton()
		_.assign eezyButton,
			parent: @
			x: Align.right(-16)
			y: Align.bottom(-eezyButton.height / 2)
			
		eezyButton.onTap -> new PlanModal	
		
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
			@_inputs = array ? []
			
			@emit "change:inputs", array, @

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
	
	icon = new Layer
		name: "Icon"
		parent: background
		width: 40
		height: 40
		point: Align.center
		image: eezy_icon.image
	
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
			backgroundColor: '#FFF'
			borderRadius: 16
			borderWidth: 1
			borderColor: colors.choiceText
		
		@contentLayer = new Type.Regular
			parent: @
			padding: {left: 16, right: 16}
			x: 0
			y: Align.center
			color: colors.choiceText
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
	
	hideAvatar: ->
		@avatarLayer?.destroy()
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

# Choice Scroll

class ChoiceScroll extends ChatContainer
	constructor: (options = {}) ->
		@__constructor = true
		
		super _.defaults options,
			name: "Image Choice Scroll"
			align: "full"
					
		@hideAvatar()
		
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
	
	hideAvatar: ->
		@avatarLayer?.destroy()

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
			
		@contentLayer = new Type.Regular
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

# to do

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
			backgroundColor: colors.chatBackground
			borderWidth: 1
			borderColor: colors.border
		
		noThanksLink = new Type.Regular
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
			backgroundColor: colors.chatBackground
			borderWidth: 1
			borderColor: colors.border
		
		doneLink = new Type.Regular
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
# 		@chatView.removeChat(@)
# 		@destroy()
		
		@height = @scrollLayer.maxY
		@backgroundLayer.height = @scrollLayer.maxY
		@_active = false
		
		if sendInvites
			Utils.delay 1, => @chatView.addChat new ChatBubble
				text: "Invite these friends."
				align: 'right'
			Utils.delay 2, => @chatView.addChat new ChatBubble
				text: Utils.randomChoice([
					"Cool, I'll see if they want to come too.", 
					"Ok, I'll send out the invites.", 
					"Ok, I'll invite them."
				])
		else
			for linkLayer in @linkLayers
				linkLayer.selected = false
			
			Utils.delay 1, => @chatView.addChat new ChatBubble
				text: "No thanks."
				align: 'right'
				
			Utils.delay 2, => @chatView.addChat new ChatBubble
				text: Utils.randomChoice([
					"Cool, we'll keep it to just you.", 
					"Ok, no invites for now.", 
					"Ok, just you for now."
				])
			
		Utils.delay 2, => @callback()

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
			plan.confirmed = true
		
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

# Create Chat Views
chatViews = []

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
			chatView: @
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
			Utils.delay 1, => suggestWhen()
		
	noChoice =
		text: "No way"
		callback: -> confirmNegative()
	
	# add an intro message
	
	mainChat.addChat new ChatBubble
		text: 'How about a quick bite?'
		
	# add the link choice box
	
	Utils.delay 1, => 
		mainChat.addChat new LinkChoiceBox
			chatView: @
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
	
	Utils.delay 1.5, -> mainChat.addChat new PersonChoiceScroll
		chatView: mainChat


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
suggestWhen()




# ----------------------------------------------
# Start Flow

flow.bringToFront()
flow.showNext(mainChat)