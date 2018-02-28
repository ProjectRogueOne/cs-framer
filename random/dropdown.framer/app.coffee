class Dropdown extends Layer
	constructor: (@options={}) ->
		@__constructor = true
		
		_.defaults @options,
			name: 'Dropdown'
			dropdownOffset: 3
			dropdownPadding: 5
			value: "Select..."
			width: 120
			items: []

		_.assign @options,
			height: 30
			backgroundColor: "#f5f5f5"
			borderRadius: 3
			
		super @options

		@selectContent = new TextLayer
			name: "selectContent"
			text: ''
			fontSize: 13
			color: "#333"
			parent: @
			padding:
				left: 10
				right: 10
			y: Align.center()
			x: 0

		# Dropdown
		@dropdownContainer = new Layer
			width: 220
			height: 30
			backgroundColor: "efefef"
			borderRadius: 3
			name: "dropdownContainer"
			x: 0
			y: 0
			visible: false

		# Options
		for option, i in @options.items

			height = @height

			optionBackground = new Layer
				parent: @dropdownContainer
				name: '> ' + option
				y: height * i
				width: @dropdownContainer.width
				height: height
				backgroundColor: null
				custom:
					selected: false

			optionLabel = new TextLayer
				parent: optionBackground
				name: "optionLabel"
				text: option
				color: "#555555"
				fontSize: 14
				y: Align.center()
				x: 0
				padding:
					left: 10
					right: 10

		# set our container to be as tall as the sum of the options' heights, 
		# and as wide as the widest option, but no less than the instance's width
		_.assign @dropdownContainer,
			height: _.sumBy(@dropdownContainer.children, 'height')
			width:  _.clamp(
				_.maxBy(@dropdownContainer.children, 'width')?.width,
				@width,
				Screen.width
				)
		
		for option in @dropdownContainer.children
			option.width = @dropdownContainer.width
			option.onClick (event, layer) =>
				event.stopPropagation()
				@value = layer.selectChild("optionLabel")?.text

		@onClick @toggleOpen

		@.on 'change:value', (value) =>
			@selectContent.text = value
			
		delete @__constructor
		
		# now that we have all our layers and listeners...
		
		_.assign @,
			_dropDownOpen: false
			value: @options.value
						
	toggleOpen: (event, layer) =>
		event?.stopPropagation()
		
		@_dropDownOpen = !@_dropDownOpen
		@emit 'change:dropdown', @_dropDownOpen
		
		_.assign @dropdownContainer,
			y: @screenFrame.y
			x: @screenFrame.x
			visible: @_dropDownOpen
		
		Utils.delay .05, =>	
			if @_dropDownOpen
				@dropdownContainer.bringToFront()
				
				document.body.addEventListener 'click', @toggleOpen
				return
			
			@dropdownContainer.sendToBack()
			document.body.removeEventListener 'click', @toggleOpen
		
	@define "value",
		get: -> return @_value
		set: (string) ->
			return if @__constructor
			
			@_value = string
			@emit "change:value", string

new Dropdown
	items: ['dog', 'cat', 'mouse']
	
new Dropdown
	x: 32
	y: 200
	items: ['red', 'blue', 'green']
	
new Dropdown
	x: 32
	y: 250
	items: ['red', 'blue', 'green']
	value: 'green'
	
new Dropdown
	x: 32
	y: 300
	width: 300
	items: ['red', 'blue', 'green']
	value: 'green'