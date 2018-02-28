require "gotcha/gotcha"
cs = require 'cs'
cs.Context.setMobile()

app = new cs.App 
# 	type: 'safari'

# Responsive View
class ResponsiveView extends cs.View
	constructor: (options = {}) ->
		
		super options
		
		@containerWidth = undefined
		
		@container = new Layer
			name: 'container'
			parent: @
			x: Align.center()
			width: Screen.width - 30
			backgroundColor: null
			
		@container.on "change:children", (changes, layer) =>
			for layer in changes.added
				layer.on "change:height", @updatePosition
			for layer in changes.removed
				layer.off "change:height", @updatePosition
			
		switch app.breakpoint
			when 's'
				_.assign @container,
					width: Screen.width - 30
					x: Align.center()
					y: 15
			else
				_.assign @container,
					width: 580
					x: Align.center
					
				@container.on "change:height", =>
					@container.y = Align.center()
				
	updatePosition: =>
		_.assign @container,
			height: _.last(@container.children)?.maxY ? 0

# Landing View
class LandingView extends ResponsiveView
	constructor: (options = {}) ->
		
		_.assign options,
			backgroundColor: '2e3b4c'
		
		super options
		
		@closeButton = new cs.Icon
			name: 'close'
			parent: @
			y: 27
			x: Align.right(-27)
			borderWidth: 1
			type: 'close'
			color: '#FFF'
			
		@topContainer = new Layer
			name: 'top container'
			parent: @container
			width: @container.width
			y: 15
			backgroundColor: null
			
		do _.bind(->
			
			@title = new cs.H4
				name: 'title'
				parent: @
				fontSize: 24
				width: 999
				color: '#FFF'
				text: 'Sign up to ClearScore UK 🇬🇧'
			
			@heading1 = new cs.H3
				name: 'heading'
				parent: @
				width: 999
				color: '#FFF'
				text: "Let's start with your email"
			
			@caption = new cs.Caption 
				name: 'caption'
				parent: @
				y: @heading1.maxY
				width: 999
				color: '#FFF'
				text: "Your email address will be your ClearScore username, so please make sure you enter it correctly"
			
			@input = new cs.Field 
				name: 'input'
				parent: @
				width: 999
				fill: 'none'
				border: '#8d9499'
				type: 'Body'
				placeholder: "Enter your email"
				placeholderColor: '#969da5'
				color: '#FFF'
			
			@height = @input.maxY
			
		, @topContainer)
		
		@midContainer = new Layer
			name: 'mid container'
			parent: @container
			y: @topContainer.maxY + 40
			width: @container.width
			backgroundColor: null
		
		do _.bind(->
			
			@cta = new cs.Button 
				name: 'cta'
				parent: @
				fill: '#8d9499'
				border: 'none'
				type: 'Body'
				color: "#5a6470"
				text: "Yes, that's my email"
				
			@cta.showDisabled = (isDisabled) ->
				if isDisabled
					@fill = '#8d9499'
					@color = "#5a6470"
					return
				
				@fill = '#FFF'
				@color = '#273649'
				
			@cta.disabled = true
			
			@security = new Layer
				name: 'security'
				parent: @
				height: 35
				
			@registrationLink = new cs.Small
				name: 'already registered?'
				parent: @
				width: @width
				textAlign: 'center'
				text: 'Already registered? Login here'
				color: '#8d9499'
				
			@southAfricaLink = new cs.Small
				name: 'south africa link'
				parent: @
				width: @width
				textAlign: 'center'
				text: 'Are you looking for\nClearScore South Africa 🇿🇦?'
				color: '#8d9499'
			
			@height = @southAfricaLink.maxY
			
		, @midContainer)
		
		@topContainer.input.on "change:value", (value, layer) =>
			
			if value is ''
				_.assign @topContainer.input,
					color: '#FFF'
					border: '#8d9498'
					message: ''
					
				@midContainer.cta.disabled = true
				return
			
			if layer.isEmail()
				_.assign @topContainer.input,
					color: '#73b042'
					border: '#73b042'
					message: ''
					
				@midContainer.cta.disabled = false
				return
			
			# content but no email
			_.assign @topContainer.input,
				color: '#e2ab5b'
				border: '#e2ab5b'
				message: 'Please enter a valid email address'
				
			@midContainer.cta.disabled = true
				
		@setWidths()
	
	setWidths: =>
		if app.breakpoint is 's'
		
			do _.bind( -> 
				_.assign @title,
					width: @width - 55
				
				_.assign @heading1,
					width: @width
					y: @title.maxY
				
				_.assign @caption,
					width: @width
					y: @heading1.maxY
				
				_.assign @input,
					width: @width
					y: @caption.maxY + 25
				
				@height = @input.maxY
				
			, @topContainer)
			
			@midContainer.y = @topContainer.maxY + 40
			
			do _.bind( -> 
				_.assign @cta,
					x: 0
					width: @width
				
				_.assign @security,
					x: Align.center
					y: @cta.maxY + 32
				
				_.assign @registrationLink,
					x: Align.center
					y: @security.maxY + 16
					textAlign: 'center'
					
				_.assign @southAfricaLink,
					x: 0
					y: @registrationLink.maxY + 8
					width: @width
					textAlign: 'center'
					text: 'Are you looking for\nClearScore South Africa 🇿🇦?'
			, @midContainer)
		
		else
		
			do _.bind( -> 
				_.assign @title,
					width: @width - 55
				
				_.assign @heading1,
					width: @width
					y: @title.maxY + 35
				
				_.assign @caption,
					width: @width
					y: @heading1.maxY
				
				_.assign @input,
					width: @width
					y: @caption.maxY + 25
				
				@height = @input.maxY
				
			, @topContainer)
			
			@midContainer.y = @topContainer.maxY + 40
			
			
			do _.bind( -> 
				_.assign @cta,
					x: 0
					width: 208
				
				_.assign @security,
					x: Align.right
					midY: @cta.midY
				
				_.assign @registrationLink,
					x: 0
					y: @cta.maxY + 32
					textAlign: 'left'
					
				_.assign @southAfricaLink,
					x: 0
					y: @registrationLink.maxY + 8
					width: @width
					textAlign: 'left'
					text: 'Are you looking for ClearScore South Africa 🇿🇦?'
					
				@height = @southAfricaLink.maxY + 70
				
			, @midContainer)			
			

landingView = new LandingView


