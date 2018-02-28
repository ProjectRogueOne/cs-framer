cs = require 'cs'
cs.Context.setMobile()

# ---------------------------------
# app

app = new cs.App
	backgroundColor: '#efefef'
	collapse: true
	type: 'safari'
	navigation: 'default'

# Setup

Screen.backgroundColor = cs.Colors.background
Framer.Extras.Hints.disable()
# Framer.Extras.Preloader.enable()

# ---------------------------------
# pages

# Text

textPage = new cs.View
	title: 'Text'

textPage.build ->
	
	@addToStack new cs.Text
		type: 'subheader'
		text: 'Subheader'
	
	@addToStack new cs.Text
		type: 'body'
		text: 'Body'
	
	@addToStack new cs.Text
		type: 'body1'
		text: 'Body1'
	
	@addToStack new cs.Text
		type: 'button'
		text: 'Button'
	
	@addToStack new cs.Text
		type: 'link'
		text: 'link'
		
	@addToStack new cs.Text
		type: 'caption'
		text: 'Caption'
	

	# Text Color

	@addToStack new cs.Divider
	@addToStack results = new cs.Text
		text: "Text Color"
	
	@addToStack new cs.Text
		color: 'primary'
		text: 'Primary'
	
	@addToStack new cs.Text
		color: 'secondary'
		text: 'Secondary'
	
	@addToStack new cs.Text
		color: 'tertiary'
		text: 'Tertiary'
	
	@addToStack new cs.Text
		color: 'accent'
		text: 'Accent'
	
	@addToStack new cs.Text
		color: 'grey'
		text: 'Grey'
	
	@addToStack new cs.Text
		color: 'white'
		text: 'White'
	
	@addToStack new cs.Text
		color: 'black'
		text: 'Black'
		
	@addToStack new cs.Text
		color: 'disabled'
		text: 'Disabled'
	
	
	# Text Actions

	@addToStack new cs.Divider
	@addToStack results = new cs.Text
		text: "Text actions"
	
	@addToStack new cs.Text
		type: 'link'
		text: 'Click Here!'
		action: -> @text = 'Clicked!'

# Icon

iconPage = new cs.View
	title: 'Icon'

iconPage.build ->
	
	@addToStack new cs.Icon
	
	# basic types

	@addToStack new cs.Divider
	@addToStack results = new cs.Text
		text: "Icon.type"
	
	@addToStack types = new Layer
		width: @width - 32
		height: 64
		backgroundColor: null
	
	for type, i in ['info', 'menu', 'required', 'arrow', 'check']
		new cs.Icon
			parent: types
			x: (48 * i), y: Align.center
			type: type
	
	# types with default colors
	
	@addToStack colorTypes = new Layer
		width: @width - 32
		height: 64
		backgroundColor: null
	
	for type, i in ['cross', 'star-outline', 'star', 'notification']
		new cs.Icon
			parent: colorTypes
			x: (48 * i), y: Align.center
			type: type
	
	# types with outlines
			
	@addToStack new cs.Divider
	
	@addToStack outlines = new Layer
		width: @width - 32
		height: 64
		backgroundColor: null
	
	for type, i in ['accordian', 'account', 'question', 'alert', 'score', 'empty']
		new cs.Icon
			parent: outlines
			x: (48 * i), y: Align.center
			type: type
	
	# directions
			
	@addToStack new cs.Divider
	@addToStack results = new cs.Text
		text: "Icon.direction"
			
	@addToStack arrows = new Layer
		width: @width - 32
		height: 64
		backgroundColor: null
	
	for direction, i in ['right', 'down', 'left', 'up']
		new cs.Icon
			parent: arrows
			x: (48 * i), y: Align.center
			type: 'accordian'
			direction: direction
	
	# colors
			
	@addToStack new cs.Divider
	@addToStack results = new cs.Text
		text: "Icon.color"
	
	@addToStack colors = new Layer
		width: @width - 32
		height: 64
		backgroundColor: null
	
	for color, i in ['black', 'grey', 'white', 'primary', 'secondary']
		new cs.Icon
			parent: colors
			x: (48 * i), y: Align.center
			type: 'account'
			color: color
	
	# raw icons - 100 of a total of 1600 icons
			
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: "About 1600 in total!"
	
	@addToStack iconContainer = new cs.Container
		fill: 'none'
		border: 'grey'
		height: @width - 32
		width: @width - 32
		
	for i in _.range(100)
		new cs.Icon
			parent: iconContainer
			x: 14 + (32 * (i % 10))
			y: 14 + (32 * Math.floor(i / 10))
			type: 'random'
			
	@addToStack new cs.Text
		type: 'body1'
		text: 'See https://materialdesignicons.com/ for complete set.'

# Logo

logoPage = new cs.View
	title: 'Logo'

logoPage.padding.stack = 32

logoPage.build ->
	
	# Logo
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Logo.type'
		
	@addToStack new cs.Logo
		type: 'logo'
	
	# Logotype ( default )
	
	@addToStack new cs.Logo
		type: 'logotype'
	
	# Logomark
	
	@addToStack new cs.Logo
		type: 'logomark'
	
	# Logo Color
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Logo.color'
	
	@addToStack new cs.Logo
	
	@addToStack new cs.Logo
		color: 'white'
	
	@addToStack new cs.Logo
		color: 'grey'
	
	@addToStack new cs.Logo
		color: 'primary'

# Container

containerPage = new cs.View
	title: 'Container'

containerPage.build ->
	
	@addToStack new cs.Container
	
	#----------
	# sizes
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Container.size'
	
	@addToStack new cs.Container
		size: 'icon'
	
	@addToStack new cs.Container
		size: 'small'
	
	@addToStack new cs.Container
		size: 'medium'
	
	@addToStack new cs.Container
		size: 'large'
	
	#----------
	# fills
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Container.fill'
	
	@addToStack new cs.Container
		fill: 'white'
	
	@addToStack new cs.Container
		fill: 'primary'
	
	@addToStack new cs.Container
		fill: 'secondary'
	
	@addToStack new cs.Container
		fill: 'transparent'
	
	#----------
	# borders
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Container.border'
	
	@addToStack new cs.Container
		border: 'white'
		fill: 'transparent'
	
	@addToStack new cs.Container
		border: 'primary'
		fill: 'transparent'
	
	@addToStack new cs.Container
		border: 'secondary'
		fill: 'transparent'
	
	@addToStack new cs.Container
		border: 'transparent'
		fill: 'transparent'
		

# Button

buttonPage = new cs.View
	title: 'Button'

buttonPage.build ->
	
	# Button Actions
	
	@addToStack new cs.Button
		action: -> @text = 'Tapped!'
		
	@addToStack new cs.Button
		text: 'toggle button'
		toggle: true
		action: -> 
			if @isOn then @text = 'Toggled!'
			else @text = 'toggle button'
	
	#-------------
	# Button Sizes
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Button.size'
	
	@addToStack new cs.Button
		size: 'small'
		text: 'Small'
	
	@addToStack new cs.Button
		size: 'medium'
		text: 'Medium'
	
	@addToStack new cs.Button
		size: 'large'
		text: 'Large'
	
	@addToStack new cs.Button
		size: 'auto'
		text: 'Auto'
	
	#-------------
	# Button Fill
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Button.fill'
	
	@addToStack new cs.Button
		fill: 'todo'
	
	#-------------
	# Button Border
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Button.border'
	
	@addToStack new cs.Button
		fill: 'todo'
		border: 'secondary'
		
	
	#-------------
	# Button Text
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Button.text'
	
	@addToStack new cs.Button
		text: 'Click Here!'
		action: -> @text = 'Clicked!'
	
	#-------------
	# Button Type
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Button.type'
	
	@addToStack new cs.Button
		text: 'Click Here!'
		type: 'body'
		action: -> @text = 'Clicked!'
	
	#-------------
	# Button Color
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Button.color'
	
	@addToStack new cs.Button
		text: 'Click Here!'
		type: 'body'
		color: 'white'
		action: -> @text = 'Clicked!'
	
	#-------------
	# Button Disabled
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Button.disabled'
	
	@addToStack new cs.Button
		text: 'Click Here!'
		type: 'body'
		color: 'white'
		disabled: true
		action: -> @text = 'Clicked!'
		

# - Creating a custom button

ghostButton = (options) ->
	
	_.assign options,
		type: "body"
		size: 'auto'
		border: 'primary'
		color: 'primary'
		fill: 'transparent'
	
	return new cs.Button options

# -

buttonPage.addToStack new cs.Divider

buttonPage.addToStack new ghostButton
	text: 'Ghost button'

# Sortable

sortableView = new cs.View
	title: 'Sortable'

sortableView.build ->
	
	positions = []
	
	for i in _.range(5)
		new cs.Sortable
			y: 16
			parent: @content
			positions: positions
	
	new cs.Sortable
		parent: @content
		positions: positions
		fill: 'secondary'

# SegmentControl

segmentPage = new cs.View
	title: 'Segment Control'

segmentPage.build ->
	@addToStack new cs.SegmentControl
	
	#-------------
	# Segments
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'SegmentControl.segments'
	
	left = {text: 'Left', action: -> results.template = 'Left'}
	right = {text: 'Right', action: -> results.template = 'Right'}
	
	@addToStack segmentControl = new cs.SegmentControl
		segments: [left, right]
		selected: right
	
	@addToStack results = new cs.Text
		text: "Segments: {value} is selected."
		
	results.template = segmentControl.selected.text
	
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'SegmentControl.border'
	
	left = {text: 'Left', action: -> results.template = 'Left'}
	right = {text: 'Right', action: -> results.template = 'Right'}
	
	@addToStack segmentControl1 = new cs.SegmentControl
		segments: [left, right]
		selected: right
		border: 'primary'
	
	@addToStack results1 = new cs.Text
		text: "Segments: {value} is selected."
		
	results1.template = segmentControl1.selected.text

# Field

fieldPage = new cs.View
	title: 'Field'

fieldPage.build ->
	
	# plain Field
	@addToStack new cs.Field
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.placeholder'
	
	# text field with placeholder text
	@addToStack new cs.Field
		placeholder: 'Placeholder'
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.password'
		
	# password field
	@addToStack new cs.Field
		placeholder: 'Password'
		password: true
		
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.border'
	
	# container border
	@addToStack new cs.Field
		placeholder: 'Border'
		border: 'black'
		
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.fill'
		
	# container fill
	@addToStack new cs.Field
		placeholder: 'Fill'
		fill: 'field'
	
	@addToStack new cs.Divider
	
	# container border and fill
	@addToStack new cs.Field
		placeholder: 'Border and Fill'
		fill: 'field'
		border: 'black'	
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.color'
	
	@addToStack new cs.Field
		placeholder: 'Colored Text'
		color: 'accent'
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.disabled'
		
	@addToStack new cs.Field
		placeholder: 'Disabled'
		disabled: true
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.leftIcon'
		
	# left icon
	@addToStack new cs.Field
		placeholder: 'Field with a left icon'
		leftIcon: 'information-outline'
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.rightIcon'
	
	# right icon
	@addToStack new cs.Field
		placeholder: 'Field with a right icon'
		rightIcon: 'eye'
		
	@addToStack new cs.Divider
	
	# right and left icons
	@addToStack new cs.Field
		placeholder: 'Field with both icons'
		leftIcon: 'information-outline'
		rightIcon: 'eye'
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.pattern'
	
	# patterns / validation
	@addToStack sWords = new cs.Field
		y: 100
		placeholder: 'Patterns (s words only)'
		pattern: (value) -> 
			value[0] is "s" or 
			value[0] is "S" or
			value is ''
	
	sWords.on "change:matches", (matches, hasTextContent) ->
		if matches
			@color = 'black'
			@border = 'grey'
		else
			@color = 'accent'
			@border = 'accent'
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.title'
			
	@addToStack new cs.Field
		placeholder: 'Field with Title'
		title: 'Title'
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text 
		text: 'Field.message'
	
	@addToStack new cs.Field
		placeholder: 'Field with Message'
		message: 'Message'
		
	@addToStack new cs.Divider
		
	@addToStack test = new cs.Field
		placeholder: 'Field with Label and Message'
		title: 'Label' 
		message: 'Message'
		color: 'accent'

# Donuts

donutsPage = new cs.View
	title: 'Donuts'

donutsPage.build ->
	
	@addToStack donut = new cs.Donut
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Donut.value'
		
	@addToStack donut = new cs.Donut
		value: 62
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Donut.showNumber'
		
	@addToStack donut = new cs.Donut
		showNumber: false
		value: 62
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Donut.showCircle'
	
	@addToStack donut = new cs.Donut
		showCircle: false
		value: 62
	
	@addToStack new cs.Divider
	
	@addToStack donut = new cs.Donut
		showCircle: false
		showNumber: false
		value: 62
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Donut.min, Donut.max'
		
	@addToStack donut = new cs.Donut
		min: 0
		value: 3
		max: 10
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Animating values'
		
	@addToStack animDonut = new cs.Donut
	
	animDonut.onTap ->
		animDonut.animate
			value: _.random(700)
			
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Donut.addPages()'
		
	@addToStack pageDonut = new cs.Donut
		showNumber: false
		min: 0
		max: 3
		value: 1
	
	for i in _.range(3)
		page = pageDonut.newPage()
		
		labelLayer = new cs.Text
			parent: page
			point: Align.center
			text: 'Page ' + (i + 1)
			
	pageDonut.on "change:currentPage", (currentPage) ->
		@animate 
			value: @pages.indexOf(currentPage) + 1
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Donut.type'
	
	@addToStack new cs.Donut
		type: 'dashboard'
		value: 420
	
	# -------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Donut.size'
		
	@addToStack new cs.Donut
		size: 'icon'
		value: 62

	@addToStack new cs.Donut
		size: 'small'
		value: 62

	@addToStack new cs.Donut
		size: 'medium'
		value: 62

	@addToStack new cs.Donut
		size: 'large'
		value: 62


# Toggle

togglePage = new cs.View
	title: 'Toggle'

togglePage.build ->
	
	@addToStack toggle = new cs.Toggle
	
	# a label that will change when the toggle is on or off
	
	@addToStack report = new cs.Text
		type: 'subheader'
		text: '{string}'
	
	# a function to make the change to the label
	makeReport = (isOn) ->
		if isOn
			report.template = 'Toggle is on / open.'
		else
			report.template = 'Toggle is off / closed.'
	
	# an event listener for when the toggle changes
	toggle.on "change:isOn", (isOn) ->
		makeReport(isOn)
	
	# run the makeReport function when loaded
	makeReport(toggle.isOn)
	
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Toggle.isOn'
		
	@addToStack new cs.Toggle
		isOn: true

# Switch

switchPage = new cs.View
	title: 'Switch'

switchPage.build ->
	
	@addToStack uiSwitch = new cs.Switch
	
	# a label that will change when the toggle is on or off
	
	@addToStack report = new cs.Text
		type: 'subheader'
		text: '{string}'
	
	# a function to make the change to the label
	makeReport = (isOn) ->
		if isOn
			report.template = 'Switch is on / open.'
		else
			report.template = 'Switch is off / closed.'
	
	# an event listener for when the toggle changes
	uiSwitch.on "change:isOn", (isOn) ->
		makeReport(isOn)
	
	# run the makeReport function when loaded
	makeReport(uiSwitch.isOn)
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Switch.isOn'
		
	@addToStack new cs.Switch
		isOn: true

# Checkbox

checkboxPage = new cs.View
	title: 'Checkbox'

checkboxPage.build ->
	
	@addToStack new cs.Checkbox
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Checkbox.group '
	
	# container for checkboxes
	@addToStack checkboxContainer = new cs.Container
		size: 'medium'
		border: 'grey'
		fill: 'transparent'
	
	# array for checkboxes
	checkboxes = []
	
	# make checkboxes
	boxesWidth = 0
	
	for i in _.range(6)
		box = new cs.Checkbox
			parent: checkboxContainer
			group: checkboxes
			y: Align.center
			value: i
		
		box.on "change:isOn", (isOn) ->
			showChecked()
		
		boxesWidth += box.width
			
	gap = (checkboxContainer.width - boxesWidth) / 6
	startX = gap / 2
	
	for box in checkboxes
		box.x = startX
		startX += box.width + gap
		
	# a label that will show which checkboxes are checked
	@addToStack checkboxReport = new cs.Text
		type: 'subheader'
		text: 'Checked: {string}'
	
	# function to get a string of all checked boxes
	showChecked = ->
		string = ''
		for box in checkboxes
			if box.isOn is true
				string += box.value + ', '
		string = _.trimEnd(string, ', ')
		checkboxReport.template = string
	
	# run the showChecked function when loaded
	showChecked()
	
	
			

# Radiobox

radioboxPage = new cs.View
	title: 'Radiobox'

radioboxPage.build ->
	
	@addToStack new cs.Radiobox
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Radiobox.group '
	
	# container for radioboxes
	@addToStack radioboxContainer = new cs.Container
		size: 'medium'
		border: 'grey'
		fill: 'transparent'
	
	# array to keep track of our radioboxes
	radioboxes = []
	
	# a label that will show which radiobox is selected
	@addToStack radioboxReport = new cs.Text
		type: 'subheader'
		text: 'Selected: {string}'
	
	# function to show the selected radiobox's value in label
	showSelected = (value) ->
		radioboxReport.template = value
	
	# make radioboxes
	boxesWidth = 0
	
	for i in _.range(6)
		box = new cs.Radiobox
			parent: radioboxContainer
			group: radioboxes
			y: Align.center
			value: i
		
		boxesWidth += box.width
		
		box.on "change:isOn", (isOn) ->
			if isOn is true
				showSelected(@value)
			
	gap = (radioboxContainer.width - boxesWidth) / 6
	startX = gap / 2
	
	for box in radioboxes
		box.x = startX
		startX += box.width + gap
	
	# turn on one of the radioboxes
	radioboxes[1].isOn = true
	
	


# Overlay

# overlayPage = new cs.View
# 	title: 'Overlay'
# 
# overlayPage.build ->
# 	
# 	@addToStack new ghostButton
# 		text: "Show overlay"
# 		action: -> new cs.Overlay

# Accordian

accordianPage = new cs.View
	title: 'Accordian'

accordianPage.build ->
	
	@addToStack accordian = new cs.Accordian
	
	body = new cs.Text 
		parent: accordian
		y: 72
		x: 16
		width: accordian.width - 32
		text: 'This is an example of an accordian, a container that may be opened or closed to reveal additional content.'
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Accordian.title '
	
	@addToStack accordian = new cs.Accordian
		title: 'Accordian Title'
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Accordian.subtitle '
	
	@addToStack accordianSubtitle = new cs.Accordian
		title: 'Accordian with Subtitle'
		subtitle: 'Subtitle'
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Accordian.icon '
	
	@addToStack accordianIcon = new cs.Accordian
		title: 'Accordian with Icon'
		icon: 'alert'
		
	# ----------------
	@addToStack new cs.Divider
	
	@addToStack accordianBoth = new cs.Accordian
		title: 'Accordian with Both'
		subtitle: 'Subtitle and Icon'
		icon: 'alert'
	
	# add content to other accordians
	for acco in [accordian, accordianSubtitle, accordianIcon, accordianBoth]
		body = new cs.Text 
			parent: acco
			y: 72
			x: 16
			width: acco.width - 32
			text: 'This is an example of an accordian, a container that may be opened or closed to reveal additional content.'

# Carousel

carouselPage = new cs.View
	title: 'Carousel'

carouselPage.build ->
	@addToStack carousel = new cs.Carousel
	
	for i in _.range(7)
		carousel.addPage()
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Carousel.shape'
		
	@addToStack lineCarousel = new cs.Carousel
		shape: 'line'
	
	for i in _.range(7)
		lineCarousel.addPage()
		
	@addToStack circleCarousel = new cs.Carousel
		shape: 'circle'
	
	for i in _.range(7)
		circleCarousel.addPage()
		
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Carousel.opacityScale '
	
	@addToStack opacityCarousel = new cs.Carousel
		shape: 'circle'
		opacityScale: 1
	
	for i in _.range(7)
		opacityCarousel.addPage()
	
	@addToStack opacity1Carousel = new cs.Carousel
		shape: 'circle'
		opacityScale: .5
	
	for i in _.range(7)
		opacity1Carousel.addPage()
	
	@addToStack opacity2Carousel = new cs.Carousel
		shape: 'circle'
		opacityScale: 0
	
	for i in _.range(7)
		opacity2Carousel.addPage()
		
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Carousel.scaleScale'
	
	@addToStack scaleCarousel = new cs.Carousel
		scaleScale: 1
	
	for i in _.range(7)
		scaleCarousel.addPage()
		
	@addToStack scale1Carousel = new cs.Carousel
		scaleScale: .5
	
	for i in _.range(7)
		scale1Carousel.addPage()
		
	@addToStack scale2Carousel = new cs.Carousel
		scaleScale: 0
	
	for i in _.range(7)
		scale2Carousel.addPage()

	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Carousel.padding'
	
	@addToStack paddingCarousel = new cs.Carousel
		padding: 0
	
	for i in _.range(7)
		paddingCarousel.addPage()
		
	@addToStack padding1Carousel = new cs.Carousel
		padding: 32
	
	for i in _.range(7)
		padding1Carousel.addPage()
		
	@addToStack padding2Carousel = new cs.Carousel
		padding: -32
	
	for i in _.range(7)
		padding2Carousel.addPage()
		
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Carousel.originY'
		
	@addToStack originYCarousel = new cs.Carousel
		originY: 0
	
	for i in _.range(7)
		originYCarousel.addPage()
	
	@addToStack originY1Carousel = new cs.Carousel
		originY: .5
	
	for i in _.range(7)
		originY1Carousel.addPage()
	
	@addToStack originY2Carousel = new cs.Carousel
		originY: 1
	
	for i in _.range(7)
		originY2Carousel.addPage()

# Puller

pullerPage = new cs.View
	title: 'Puller'

pullerPage.build ->

	puller = new cs.Puller
		parent: @content

# Progress

progressPage = new cs.View
	title: 'Progress'
	padding: {left: 16, top: 102, stack: 32, right: 16}

progressPage.build ->
	
	progress = new cs.Progress
		parent: @content
		y: 16
		step: 1
	
	prev = new ghostButton
		parent: @content
		x: 16
		y: progress.maxY + 16
		text: "Prev step"
		action: -> progress.step--
	
	next = new ghostButton
		parent: @content
		x: prev.maxX + 16
		y: progress.maxY + 16
		text: "Next step"
		action: -> progress.step++

# Progress Bar

progressBarPage = new cs.View
	title: 'Progress Bar'
progressBarPage.build ->
	
	@addToStack new cs.ProgressBar
	
	#-
	
	@addToStack new cs.Divider
	
	@addToStack bar = new cs.ProgressBar
		value: 70

	@addToStack label = new cs.Text
		type: "body1"
		text: "Value: {value}"
	
	label.template = bar.value.toFixed()
		
	@addToStack new ghostButton
		text: "Set new value"
		action: ->
			bar.animate
				value: _.random(bar.min, bar.max)
	
	bar.on "change:value", (value) ->
		label.template = value.toFixed()
		


# Navigation

navigationPage = new cs.View
	title: 'Navigation'

navigationPage.build ->
	
	# Navigation Types
	
	# ----------------
	@addToStack new cs.Divider
	@addToStack new cs.Text
		text: 'Navigation.type '
	
	@addToStack new ghostButton
		text: 'Default'
		action: ->
			app.navigation?.type = 'default'
	
	@addToStack new ghostButton
		text: 'Page'
		action: ->
			app.navigation?.type = 'page'
	
	@addToStack new ghostButton
		text: 'Login'
		action: ->
			app.navigation?.type = 'login'
		
	@addToStack new ghostButton
		text: 'Registration'
		action: ->
			app.navigation?.type = 'registration'

# Headers

headerPage = new cs.View
	title: 'Headers'
	right: 
		icon: 'settings'

headerPage.build ->
	
	# Safari Bar
	@addToStack swap = new ghostButton
		text: 'Safari Bar'
		action: -> 
			app.type = "safari"
	
	# iOS App Bar
	@addToStack swap = new ghostButton
		text: 'iOS Bar'
		action: -> 
			app.type = "ios"
				
	# iOS App Bar ( collapsing on scroll )
	@addToStack swap = new ghostButton
		text: 'iOS Bar (collapse)'
		size: 'auto'
		action: -> 
			app.type = "ios"
			app.header.collapse = true
				
	# Android App Bar
	@addToStack swap = new ghostButton
		text: 'Android Bar'
		action: -> 
			app.type = "android"
	
	# blank mobile header
	@addToStack swap = new ghostButton
		text: 'Blank Bar'
		action: -> 
			app.type = "mobile"
				
	# blank mobile header ( collapsing on scroll )
	@addToStack swap = new ghostButton
		text: 'Blank Bar (collapse)'
		action: -> 
			app.type = "mobile"
			app.header.collapse = true
	
	# blank mobile header ( with fill )
	@addToStack swap = new ghostButton
		text: 'Blank Bar (fill color)'
		action: -> 
			app.type = "mobile"
			app.header.collapse = true
			app.header.fill = 'secondary'
			app.header.closedFill = 'secondary'
	
	# blank mobile header ( with open / closed fills )
	@addToStack swap = new ghostButton
		text: 'Blank Bar (closedFill)'
		action: -> 
			app.type = "mobile"
			app.header.collapse = true
			app.header.fill = 'secondary'
			app.header.closedFill = 'tertiary'

# ---------------------------------
# start

links = []

for view in app.views
	
	link =
		text: view.title
		view: view
	
	links.push link 

app.navigation.links = links

app.showNext(headerPage)
app.showNext(textPage)
