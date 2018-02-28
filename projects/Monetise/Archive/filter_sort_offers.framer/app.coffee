Type = require 'Mobile'
{ Page } = require 'Page'
{ Icon } = require 'Icon'
{ Checkbox } = require 'Checkbox'
{ Divider } = require 'Divider'
{ Switch } = require 'Switch'

# ----------------------------------------------
# Options

USE_DYNAMIC_APR_RANGE = true


# ----------------------------------------------
# Setup

# Colors

Colors = 
	main: '#404F5D'
	page: '#FFFFFF'
	lightText: '#FFFFFF'

# Page Setup
Screen.backgroundColor = Colors.page
Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()



# ----------------------------------------------
# Data 

# Database

database = 
	offers: []
	categories: [
		'rewards cards',
		'super cards',
		'travel abroad',
		'balance transfer',
		'make it rain',
		'credit balance'
		]
	brands: [
		'Barclays', 
		'AMEX', 
		'LUMA',
		'Vanquis',
		'Natwest',
		'Capital One',
		'Tesco Bank',
		'British Airways'
		]
	products: [
		'Credit Card'
		]
	rateTypes: [
		'Guaranteed', 
		'Select'
		]
	cardImages: [
		'images/card1.png', 
		'images/card2.png'
		]
	features: [
		'amazon cashback',
		'20 bottles of beer',
		'Free tickets to movies'
		]
	
	filter: (offer) -> return true
	
	setFilter: ->
		@filter = (offer) ->
			filter = filterPage.getFilter()
			
			onPreapproved = true
			if filter.preapprovedOnly
				onPreapproved = offer.preapproved is filter.preapprovedOnly
				
			onCategory = true 
			if filter.cardCategories.length > 0
				onCategory = _.includes(filter.cardCategories, offer.category)
			
			onAPR = 
				filter.apr.min <= offer.apr and
				offer.apr <= filter.apr.max
			
			onBrand = true 
			if filter.brands.length > 0
				onBrand = _.includes(filter.brands, offer.brand)
			
			onFeature = true 
			if filter.features.length > 0
				onBrand = _.includes(filter.features, offer.feature)
			
			return _.every([
				onBrand, 
				onAPR, 
				onCategory, 
				onFeature, 
				onPreapproved
				])
	
	getFiltered: (array) ->
		filter = filterPage.getFilter()
		return _.filter(array, @filter)
	
	getSorted: (array) ->
		sort = sortPage.getSort()
		direction = sortPage.getSortDirection()
		sorted = _.sortBy(array, sort)
		if direction is 'descending' then sorted = _.reverse(sorted)
		return sorted
		
	getOffers: ->
		@setFilter()
		filteredOffers = @getFiltered(@offers)
		sortedOffers = @getSorted(filteredOffers)
		return sortedOffers

# Offer (data)

class Offer
	constructor: (options = {}) ->
		@brand = options.brand ? _.sample(database.brands)
		@product = options.product ? _.sample(database.products)
		@category = options.category ? _.sample(database.categories)
		@apr = options.apr ? _.random(12.5, 25.5).toFixed(1)
		@aprType = options.aprType ? _.sample(database.aprTypes)
		@chance = options.chance ? _.random(50, 80)
		@preapproved = options.preapproved ? Math.random() > .9
		@exclusive = options.exclusive ? Math.random() > .9
		@specialOffer = options.specialOffer ? Math.random() > .9
		@image = options.image ? _.sample(database.cardImages)
		@features = options.features ? _.sampleSize(database.features, _.random(3))

		database.offers.push(@)

# make some offers
new Offer for i in _.range(30)


# ----------------------------------------------
# Components

# Header Button
class HeaderButton extends Layer
	constructor: (options = {}) ->
		
		@_isOn = false
		@_offImage = options.image
		@_onImage = options.onImage ? @_offImage
		@_toggle = options.toggle ? false
		@_offAction = options.offAction ? -> null
		@_onAction = options.action ? -> null

			
		super _.defaults options,
			name: 'Header Toggle Button'
			height: 35, width: 35
	
# 		@on "change:isOn", (isOn) ->
# 			return if not @_toggle
# 			@image = if isOn then @_onImage else @_offImage
# 		
# 		@onTap -> if @_toggle then @isOn = !@isOn
# 		
# 		@onTouchStart -> @image = @_onImage
# 		@onTouchEnd -> 
# 			@image = if @isOn then @_onImage else @_offImage
# 			if @_toggle
# 				if @isOn then @_onAction() else @_offAction()
# 			else
# 				@_onAction()
# 
# 	@define "isOn",
# 		get: -> return @_isOn
# 		set: (value) ->
# 			return if value is @_isOn
# 			if typeof value isnt 'boolean' then throw 'Must be bool value.'
# 			@_isOn = value
# 			
# 			@emit "change:isOn", @_isOn, @

# Offer Card
class OfferCard extends Layer

	#{brand:"HSBC", product:"Credit Card", rate:"19.5", rateType:"Select", chance:53, preapproved:false, exclusive:false, specialOffer:false}>

	constructor: (options = {}) ->
		
		@data = options.data ? database.offers[0]
		
		background = '#FFF'
		if @data.exclusive
			background = 'eef9fb' 
		else if @data.preapproved
			background = 'f6faf3'
		
		startY = 21
		
		super _.defaults options,
			name: 'Offer Card'
			width: Screen.width
			height: 137
			backgroundColor: background
			animationOptions: { time: .25 }
		
		@divider = new Divider
			parent: @
			x: 20
			width: Screen.width - 20
		
		# Special Flag
		
		if @data.exclusive or @data.specialOffer
			return if @data.preapproved
			@height = 160
			@flag = new Type.Small
				name: 'Flag'
				parent: @
				y: 10	
				height: 22
				fontWeight: 500
				borderRadius: 2
				fontSize: 11
				backgroundColor: if @data.exclusive then '59c9d5' else 'ff731b'
				color: Colors.lightText
				textTransform: 'uppercase'
				padding: {left: 16, right: 16, top: 5}
				text: if @data.exclusive then 'exclusive' else 'special offer'
			
			startY = 42
		
		# Credit Card Image
		
		@cardImage = new Layer
			name: 'Card Image'
			parent: @
			x: 20
			y: startY
			width: 127
			height: 81
			image: @data.image
		
		# Star Rating
		
		@rating = new Layer
			name: 'Rating'
			parent: @
			x: 20
			y: @cardImage.maxY + 10
			width: 113
			height: 16
			image: 'images/stars_score.png'
		
		if @data.preapproved
		
			# Pre-approved Flag
			
			@preapprovedFlag = new Type.Small
				name: 'Preapproved Flag'
				parent: @
				y: 10
				x: 144
				height: 22
				fontWeight: 500
				borderRadius: 2
				fontSize: 11
				backgroundColor: '71b341'
				color: Colors.lightText
				textTransform: 'uppercase'
				padding: {left: 32, right: 16, top: 5}
				text: 'pre-approved'
			
			
			@approvalChance = new Layer
				name: 'Approved Flag'
				parent: @
				x: 138, y: startY - 15
				width: 30
				height: 30
				borderRadius: 15
				fontWeight: 500
				backgroundColor: '#71b341'
				color: Colors.lightText
				textTransform: 'uppercase'
				textAlign: 'center'
				borderWidth: 1
				borderColor: '#FFF'
				
			@preapprovedCheck = new Icon
				name: 'Check Icon'
				parent: @approvalChance
				x: Align.center
				y: Align.center(-4)
				color: '#FFF'
				icon: 'check'
				height: 20
				width: 20
				

		
		else
		
			# Approval Percentage / Chance
			
			@approvalChance = new Type.Small
				name: 'Approval Chance'
				parent: @
				x: 138, y: startY - 15
				width: 30
				height: 30
				borderRadius: 15
				fontWeight: 500
				backgroundColor: 'a7d089'
				color: Colors.lightText
				textTransform: 'uppercase'
				textAlign: 'center'
				borderWidth: 1
				borderColor: '#FFF'
				padding: {top: 9}
				text: @data.chance
			
			@chanceLabel = new Type.Small
				name: 'Approval Label'
				parent: @
				x: @approvalChance.maxX + 4,
				y: @approvalChance.y + 10
				fontWeight: 500
				fontSize: 12
				color: Colors.lightText
				color: 'a7d089'
				text: "% chance of being approved"
			
		# Product Name
		
		@productName = new Type.H4
			name: 'product Name' 
			parent: @
			y: @approvalChance.maxY + 8
			x: @approvalChance.maxX + 4
			width: @width - (@approvalChance.maxX + 4 + 38)
			text: "#{@data.brand} #{@data.product}"
			
		# More Icon
		
		@moreIcon = new Icon
			name: 'More Icon'
			parent: @
			x: Align.right(-10)
			y: Align.center
			icon: 'chevron-right'
			color: '#CCC'
		
		# Product Detail
		
		@productDetail = new Type.SmallBold
			name: 'Product Detail'
			parent: @
			y: @productName.maxY + 18
			x: @approvalChance.maxX + 4
			fontSize: 12
			width: @width - (@approvalChance.maxX + 20)
			text: "#{@data.apr}% Representative APR"
			color: if @data.apr < 20 then '71b341' else Color.main
		
		# Checkbox
		
		@checkbox = new Checkbox
			parent: @
			y: @cardImage.midY - 12
			x: -14
			opacity: 0
			visible: false
		
		@onTap (event) ->
			event.stopPropagation()
			return if @checkbox.visible is false
			
			@checkbox.isOn = !@checkbox.isOn
		
	showCheckbox: ->
		@animate 
			x: 24
		@checkbox.visible = true
		@checkbox.animate
			opacity: 1
		
	hideCheckbox: ->
		@animate 
			x: 0
		@checkbox.animate
			opacity: 0
		Utils.delay .25, => 
			@checkbox.visible = false

# TableRow
class TableRow extends Layer
	constructor: (options = {}) ->
		
		@action = options.action ? -> null
		
		super _.defaults options,
			height: 60
			width: Screen.width
			backgroundColor: null
			
		@titleLabel = new Type.Large
			parent: @
			x: 20
			y: Align.center(4)
			text: options.text
		
		@checkmark = new Icon
			parent: @
			icon: 'check'
			x: Align.right(-20), y: Align.center
			color: '#979797'
			visible: false
			
		@onTap -> @action()

# Checkbox Item

class CheckboxItem extends Checkbox 
	constructor: (options = {}) ->
		
		@value = options.value ? ''
		
		super _.defaults options,
			toggle: true
			action: -> null
		
		@label = new Type.Large
			parent: @
			x: 32, y: -4
			text: options.text
			padding: {top: 8, right: 32, bottom: 6}
			
		@label.onTap => null


# ----------------------------------------------
# Implementation

# Pages: 

# Offers Page

offersPage = new Page
	padding: {
		top: 226, right: 0, 
		bottom: 0, left: 0
		stack: 1
		}

offersPage.build ->
	@header = new Layer
		name: 'header'
		parent: @
		width: Screen.width
		height: 166
		image: 'images/header.png'
		
	do _.bind( ->
		
		label = new Type.Large
			parent: @
			x: 20
			y: Align.bottom(-10)
			width: 202
			text: 'Improve your credit history with a credit card.'
			color: '#FFF'
			
		filterButton = new HeaderButton
			parent: @
			image: 'images/filter.png'
			onImage: 'images/filter.png'
			x: Align.right(-19)
			y: Align.bottom(-12)
		
		filterButton.onTap -> flow.showNext(filterPage)
		
		compareButton = new HeaderButton
			parent: @
			image: 'images/compare.png'
			onImage: 'images/compare_on.png'
			toggle: true
			x: filterButton.x - (35 + 10)
			y: Align.bottom(-12)
		compareButton.toggled = false
		
		compareButton.onTap -> 
			if @toggled
				offersPage.endCompareSelection(cancel = true)
			else
				offersPage.startCompareSelection()
				
			@toggled = !@toggled
		
	, @header)
	
	# footer

	@footer = new Layer
		name: 'Footer'
		parent: @
		y: Align.bottom()
		width: Screen.width 
		height: 70
		backgroundColor: '#FFF'
		shadowY: -1
		shadowColor: '#CCC'
		visible: false
	
	do _.bind( ->
		
		@onTap (event) ->
			event.stopPropagation()
	
		footerButton = new Layer
			name: 'Footer Button'
			parent: @
			point: Align.center
			height: 50
			width: 336
			backgroundColor: Colors.main
			color: Colors.lightText
	
		footerText = new Type.Button
			name: 'Footer Text'
			parent: @
			text: 'Submit'
			y: Align.center(5)
			textAlign: 'center'
			width: @width
			color: Colors.lightText
		
	, @footer)
		
	@filter = (offer) -> return true
	@sortBy = 'chance'
	@sortDirection = 'descending'
	
	@sortCardsLabel = new Type.Button
		parent: @content
		x: 20, y: 190
		textTransform: 'capitalize'
		text: 'Sort credit cards by:'
	
	@sortCardsLink = new Type.Button
		parent: @content
		x: @sortCardsLabel.maxX + 4, y: 190
		textTransform: 'capitalize'
		color: '#ff731c'
		text: '{sort}'
		
	@sortCardsLink.onTap =>
		flow.showNext(sortPage)
		@endCompareSelection()
	
	# rebuild offers page layers / cards
	@showOffers = ->
		@stack = []
		
		# get filtered / sorted offers
		offers = database.getOffers()
		
		for offer in offers
			@addToStack(new OfferCard
				data: offer
			)
		
		@sortCardsLink.template = sortPage.getSort()
		@updateContent()
		
	@startCompareSelection = ->
		for card in @stack
			card.showCheckbox()
		@footer.visible = true

	@endCompareSelection = (cancel = true) ->
		for card in @stack
			card.hideCheckbox()
			card.checkbox.isOn = false
		@footer.visible = false
	
	@refresh = -> @showOffers()	
	

# Sort Page

sortPage = new Page
	padding: {
		top: 64, right: 0, 
		bottom: 0, left: 0
		stack: 1
		}
		
sortPage.build ->
	
	@sort = 'chance'
	@sortDirection = 'descending'
	
	@header = new Layer
		name: 'Safari Nav'
		parent: @
		width: Screen.width
		height: 64
		image: 'images/safari_nav.png'
	
	titleRow = new Layer
		height: 60
		width: @width
		backgroundColor: null
	
	titleLabel = new Type.LargeBold
		parent: titleRow
		x: 20
		y: Align.center(4)
		text: 'Sort Cards By'
	
	backButton = new Icon
		parent: titleRow
		icon: 'close'
		x: Align.right(-20), y: Align.center
		color: '#979797'
	
	backButton.onTap -> flow.showPrevious()
		
	@addToStack(titleRow)
	
	@addToStack(new Divider
		width: @width
	)
	
	# Eligability
	
	eligabilityDesc = new TableRow
		text: 'Eligibility (highest eligibility at top)'
		action: => 
			@sort = 'chance'
			@sortDirection = 'descending'
	
	eligabilityAsc = new TableRow
		text: 'Eligibility (lowest eligibility at top)'
		action: => 
			@sort = 'chance'
			@csortDirection = 'ascending' 
	
	aprAsc = new TableRow
		text: 'APR (lowest at top)'
		action: => 
			@sort = 'apr'
			@sortDirection = 'ascending' 
	
	aToZ = new TableRow
		text: 'A to Z'
		action: => 
			@sort = 'brand'
			@sortDirection = 'ascending' 
				
	rows = [eligabilityDesc, eligabilityAsc, aprAsc, aToZ]
	
	for row in rows
		row.onTap -> 
			@checkmark.visible = true
			for sib in _.without(rows, @)
				sib.checkmark.visible = false
			
			flow.showPrevious()
			
		@addToStack row
		
		@addToStack new Divider
			width: @width

	@getSort = -> return @sort
	@getSortDirection = -> return @sortDirection
	
	@refresh = -> null

# Filter Page

filterPage = new Page
	padding: {
		top: 64, right: 0, 
		bottom: 0, left: 0
		stack: 1
		}
	contentInset: {bottom: 70}
	
filterPage.build ->
	@header = new Layer
		name: 'Safari Nav'
		parent: @
		width: Screen.width
		height: 64
		image: 'images/safari_nav.png'
	
	@filter =
		preapprovedOnly: false
		cardCategories: []
		apr: {min: 0, max: 50}
		brands: []
		features: []
	
	# Title Row / Close Button
	
	titleRow = new Layer
		height: 60
		width: @width
		backgroundColor: null
	
	do _.bind( ->
		
		@labelLayer = new Type.Small
			parent: @
			y: Align.center(4)
			padding: {top: 20, right: 20, left: 20, bottom: 20}
			text: 'Clear Filters'
			color: 'f8a55a'
			textDecoration: 'underline'
		
		@labelLayer.onTap -> filterPage.clearFilters()
	
		@backButton = new Icon
			parent: @
			icon: 'close'
			x: Align.right(-20), y: Align.center
			color: '#979797'
	
		@backButton.onTap -> 
			flow.showPrevious()

	, titleRow)
	
	@addToStack titleRow
	@addToStack new Divider
		width: @width
	
	# Pre Approved Filter
	
	@preApprovedFilter = new Layer
		name: 'Pre Approved Filters'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new Type.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'Pre approved filters only'
			
		@uiSwitch = new Switch
			parent: @
			x: Align.right(-20)
			y: Align.center
			
		@divider = new Divider
			parent: @
			width: @width - 40
			x: 20
			y: Align.bottom
			
		@report = -> return @uiSwitch.isOn
		
		@clear = -> @uiSwitch.isOn = false
			
	, @preApprovedFilter)
	
	@addToStack @preApprovedFilter
	
	# Card Category
		
	@cardCategories = new Layer
		name: 'Card Categories'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new Type.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'Card Cartegories'
		
		@items = []
		
		for category, i in database.categories
			checkbox = new CheckboxItem
				name: '.'
				parent: @
				text: category
				textTransform: 'capitalize'
				x: if i % 2 then (@width / 2) + 8 else 17 
				y: @labelLayer.maxY + 20 + ( 48 * _.floor(i/2))
				value: category
			
			@items.push(checkbox)
				
		@divider = new Divider
			parent: @
			width: @width - 40
			x: 20
			y: checkbox.maxY + 20
			
		@height = @divider.maxY
		
		@report = -> 
			return _.map(
				_.filter(@items, 'isOn'),
				(item) -> return item.value
				)
		
		@clear = -> item.isOn = false for item in @items
			
	, @cardCategories)
	
	@addToStack @cardCategories
	
	# APR
		
	@apr = new Layer
		name: 'Brands'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new Type.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'APR'
		
		if USE_DYNAMIC_APR_RANGE
			currentMin = parseInt(_.minBy(database.offers, 'apr').apr)
			currentMax = parseInt(_.maxBy(database.offers, 'apr').apr)
		
		@slider = new RangeSliderComponent
			name: 'Slider'
			parent: @
			width: @width - 80
			x: Align.center
			y: @labelLayer.maxY + 40
			backgroundColor: '#f2f2f2'
			min: currentMin ? 0
			minValue:currentMin ? 0
			max: currentMax ? 50
			maxValue: currentMax ? 50
		
		@slider.minKnob.draggable.propagateEvents = false
		@slider.minKnob.draggable.momentum = false
		@slider.maxKnob.draggable.propagateEvents = false
		@slider.maxKnob.draggable.momentum = false
		
		@slider.fill.backgroundColor = Colors.main
		
		@minKnobIcon = new Icon
			parent: @slider.minKnob
			height: 18, width: 18
			x: Align.center
			y: Align.center(-6)
			icon: 'code-tags'
			color: Colors.main
			
		@maxKnobIcon = new Icon
			parent: @slider.maxKnob
			height: 18, width: 18
			x: Align.center
			y: Align.center(-6)
			icon: 'code-tags'
			color: Colors.main
			
		minLabel = new Type.Large
			parent: @
			color: '8d9499'
			x: @slider.x + 10
			y: @slider.maxY + 20
			text: @slider.valueForPoint(10).toFixed() + '%'
			
		minMarker = new Layer
			parent: @
			color: '8d9499'
			x: minLabel.midX
			y: @slider.y - 5
			width: 1
			height: 10 + @slider.height
		
		midLabel = new Type.Large
			parent: @
			color: '8d9499'
			x: Align.center
			y: @slider.maxY + 20
			text: @slider.valueForPoint(@slider.width/2).toFixed() + '%'
		
		midMarker = new Layer
			parent: @
			color: '8d9499'
			x: midLabel.midX
			y: @slider.y - 5
			width: 1
			height: 10 + @slider.height
			
		maxLabel = new Type.Large
			parent: @
			color: '8d9499'
			y: @slider.maxY + 20
			text: @slider.valueForPoint(@slider.width - 10).toFixed() + '%'
		maxLabel.maxX = @slider.maxX - 10
		
		maxMarker = new Layer
			parent: @
			color: '8d9499'
			x: maxLabel.midX
			y: @slider.y - 5
			width: 1
			height: 10 + @slider.height
		
		@slider.bringToFront()
			
		@divider = new Divider
			parent: @
			width: @width - 40
			x: 20
			y: maxLabel.maxY + 35
		
		@report = -> 
			return {
				min: @slider.minValue.toFixed(),
				max: @slider.maxValue.toFixed()
			}
					
		@clear = -> 
			@slider.minValue = @slider.min
			@slider.maxValue = @slider.max
		
		@height = @divider.maxY
			
	, @apr)
	
	@addToStack @apr
	
	# Brands
	
	@brands = new Layer
		name: 'Brands'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new Type.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'Brands'
			
		@items = []
		
		for brand, i in database.brands
			checkbox = new CheckboxItem
				name: '.'
				parent: @
				text: brand
				textTransform: 'capitalize'
				x: if i % 2 then (@width / 2) + 8 else 17 
				y: @labelLayer.maxY + 20 + ( 48 * _.floor(i/2))
				value: brand
				
			@items.push(checkbox)
			
		@divider = new Divider
			parent: @
			width: @width - 40
			x: 20
			y: checkbox.maxY + 20
		
		@report = -> 
			return _.map(
				_.filter(@items, 'isOn'),
				(item) -> return item.value
				)
		
		@clear = -> item.isOn = false for item in @items
		
		@height = @divider.maxY
			
	, @brands)
	
	@addToStack @brands
	
	# Features
		
	@features = new Layer
		name: 'Features'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new Type.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'Features'
		
		@items = []
		
		for feature, i in database.features
			checkbox = new CheckboxItem
				name: '.'
				parent: @
				text: feature
				textTransform: 'capitalize'
				x: 17
				y: @labelLayer.maxY + 20 + (40 * i)
				value: feature
				
			@items.push(checkbox)
		
		@report = -> 
			return _.map(
				_.filter(@items, 'isOn'),
				(item) -> return item.value
				)
		
		@clear = -> item.isOn = false for item in @items
		
		@height = checkbox.maxY + 20
			
	, @features)
	
	@addToStack @features
	
	# Footer

	@footer = new Layer
		name: 'Footer'
		parent: @
		y: Align.bottom
		width: Screen.width 
		height: 70
		backgroundColor: '#FFF'
		shadowY: -1
		shadowColor: '#CCC'
		
	do _.bind( ->
	
		@button = new Layer
			name: 'Footer Button'
			parent: @
			point: Align.center
			height: 50
			width: 336
			backgroundColor: Colors.main
			color: Colors.lightText
		
		@text = new Type.Button
			name: 'Footer Text'
			parent: @button
			text: 'Apply Filters '
			y: Align.center(5)
			textAlign: 'center'
			width: @button.width
			color: Colors.lightText
	
	, @footer)

	@footer.button.onTap (event) =>
		event.stopPropagation()
		flow.showPrevious()
		
	@getFilter = ->
		return {
			preapprovedOnly: @preApprovedFilter.report()
			cardCategories: @cardCategories.report()
			apr: @apr.report()
			brands: @brands.report()
			features: @features.report()
		}
	
	@clearFilters = ->
		@preApprovedFilter.clear()
		@cardCategories.clear()
		@apr.clear()
		@brands.clear()
		@features.clear()
		@setFilter()
		
	@refresh = -> null	

# Flow:

# Flow
flow = new FlowComponent

flow.onTransitionStart (current, next, direction) ->
	next?.refresh()
	
flow.bringToFront()
flow.showNext(offersPage)
