cs = require 'cs'
cs.Context.setMobile()

Framer.Extras.Hints.disable()
Framer.Extras.Preloader.enable()

# ------------------
# To Do:

# Add footer to single offer page
# Add comparison (when ready)

# ------------------
# App

cs.Colors.navigation = '#FFF'
cs.Colors.navigationButtons = "rgba(0, 146, 188, 1.000)"

app = new cs.App
	type: 'safari'
	navigation: 'default'
	collapse: true

app.navigation.titleLayer.fontWeight = 300

# ------------------
# Components

# Carousel

class Carousel extends PageComponent
	constructor: (options = {}) ->
		@__constructor = true
		
		@indicators = []
		
		# assigned options
		_.assign options,
			scrollVertical: false
			scrollHorizontal: false
		
		# default options
		_.defaults options,
			name: 'Carousel'
			width: Screen.width
			height: 233
		
		# defined properties
		
		super options

		@directionLock = true
		@directionLockThreshold =
			x: 16
			y: 999
		
		# layers
		
		# events
		
		@onDirectionLockStart ->
			app.current.scrollVertical = false
		@onSwipeEnd ->
			app.current.scrollVertical = true
			
		@onSwipeRightEnd @_moveLeft
		@onSwipeLeftEnd @_moveRight
		
		@on "change:currentPage", @_setIndicators
		@content.on "change:children", @_makeIndicators
		
		# kickoff

		delete @__constructor

	# private methods

	_moveRight: ->
		@snapToNextPage("right", true)
	
	_moveLeft: ->
		@snapToNextPage("left", true)
	
	_setIndicators: =>
		for indicator in @indicators
			indicator.opacity = .26
		
		activeNum = _.indexOf(@content.children, @currentPage)
		@indicators[activeNum].opacity = 1
			
	_makeIndicators: =>
		
		for indicator in @indicators
			indicator.destroy()
		
		@indicators = []
		
		pages = @content.children
		
		for page in pages
			indicator = new Layer
				parent: @
				name: 'indicator'
				width: 24
				height: 8
				y: Align.bottom(-16)
				x: 0
				borderRadius: 8
				backgroundColor: 'white'
				borderWidth: 1
				borderColor: 'white'
				opacity: .26
			
			@indicators.push(indicator)
		
		Utils.distribute.horizontal(@, @indicators)
		
		@_setIndicators()
	
	# public methods


	# definitions



# CarouselPage

class CarouselPage extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		# assigned options
		_.assign options,
			width: Screen.width
		
		# default options
		_.defaults options,
			name: 'Carousel Page'
			height: 233
			title: "carouselPage.title"
			subtitle: ".subtitle"
			ctaText: ".ctaText"
			image: Utils.randomImage()
			data: database.creditCards
			callback: -> null
		
		super options
		
		@image = null
		
		# layers
		
		@imageLayer = new Layer
			name: 'Image'
			parent: @
			size: @size
			image: options.image
			brightness: 75
			saturate: 62
		
		@titleLayer = new cs.H2
			name: 'Title'
			parent: @
			y: 32
			x: 16
			width: @width - 32
			color: 'white'
			text: options.title
		
		@subtitleLayer = new cs.H3
			name: 'Subtitle'
			parent: @
			y: @titleLayer.maxY + 16
			x: 16
			width: @width - 32
			color: 'white'
			text: options.subtitle
			
		@ctaButton = new cs.Button
			name: 'CTA'
			parent: @
			y: @subtitleLayer.maxY + 16
			x: 16
			color: 'white'
			type: 'body'
			size: 'auto'
			fill: '#0492bd'
			text: options.ctaText
			action: options.callback
			

		# events


		# kickoff

		delete @__constructor

		# kickoff


	# private methods


	# public methods


	# definitions

# Category Scroll

class CategoryScroll extends ScrollComponent
	constructor: (options = {}) ->
		@__constructor = true
		
		# assigned options
		
		
		# default options
		_.defaults options,
			name: 'Categroy Scroll'
			width: Screen.width
			height: 96
			backgroundColor: null
			scrollVertical: false
		
		# defined properties
		
		@links = []
		
		super options

		@directionLock = true
		@directionLockThreshold =
			x: 16
			y: 999
		
		# layers
			
		# events
		
		@onDirectionLockStart ->
			app.current.scrollVertical = false
		@onSwipeEnd ->
			app.current.scrollVertical = true
		
		# kickoff

		delete @__constructor

		# kickoff


	# private methods


	# public methods

	addLink: (link) =>
		
		ypos = _.last(@links)?.maxX ? 0
		
		_.assign link,
			parent: @content
			x: 16 + ypos
			
		@links.push(link)
		@updateContent()

	# definitions



# Category Link

class CategoryLink extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		# assigned options
		_.assign options,
			width: 88
			height: 96
			backgroundColor: null
		
		# default options
		_.defaults options,
			name: 'Categroy Link'
			icon: 'images/creditcards.png'
			text: '.title'
			callback: -> null
		
		# defined properties
				
		super options
		
		# layers

		@iconLayer = new Layer
			name: "Icon Layer"
			parent: @
			image: options.icon
			width: 64
			height: 64
			x: Align.center
			backgroundColor: null
		
		@titleLayer = new cs.Text
			name: "Title Layer"
			parent: @
			width: @width + 32
			x: Align.center
			y: @iconLayer.maxY + 4
			type: 'body1'
			textAlign: 'center'
			color: 'black'
			text: options.text
		
		# events
		
		@onTap options.callback
		
		# kickoff

		delete @__constructor


	# private methods


	# public methods


	# definitions



# Offer Card

class OfferCard extends Layer

	#{brand:"HSBC", product:"Credit Card", rate:"19.5", rateType:"Select", chance:53, preapproved:false, exclusive:false, specialOffer:false}>

	constructor: (options = {}) ->
		
		@data = options.data ? throw 'No data!'
		
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
		
		@divider = new cs.Divider
			parent: @
			x: 20
			width: Screen.width - 20
		
		# Special Flag
		
		if @data.exclusive or @data.specialOffer and not @data.preapproved
			@height = 160
			@flag = new cs.Small
				name: 'Flag'
				parent: @
				y: 10	
				height: 22
				fontWeight: 500
				borderRadius: 2
				fontSize: 11
				backgroundColor: if @data.exclusive then '59c9d5' else 'ff731b'
				color: cs.Colors.lightText
				textTransform: 'uppercase'
				padding: {left: 16, right: 16, top: 3}
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
			
			@preapprovedFlag = new cs.Small
				name: 'Preapproved Flag'
				parent: @
				y: 10
				x: 144
				height: 22
				fontWeight: 500
				borderRadius: 2
				fontSize: 11
				backgroundColor: '71b341'
				color: cs.Colors.lightText
				textTransform: 'uppercase'
				padding: {left: 32, right: 16, top: 3}
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
				color: cs.Colors.lightText
				textTransform: 'uppercase'
				textAlign: 'center'
				borderWidth: 1
				borderColor: '#FFF'
			
			offset = if Framer.Device.context.scale is 1 then 3 else 3
			
			@preapprovedCheck = new cs.Icon
				name: 'Check Icon'
				parent: @approvalChance
				x: Align.center
				y: offset
				color: '#FFF'
				icon: 'check'
				height: 20
				width: 20
				

		
		else
		
			# Approval Percentage / Chance
			
			@approvalChance = new cs.Small
				name: 'Approval Chance'
				parent: @
				x: 138, y: startY - 15
				width: 30
				height: 30
				borderRadius: 15
				fontWeight: 500
				backgroundColor: 'a7d089'
				color: cs.Colors.lightText
				textTransform: 'uppercase'
				textAlign: 'center'
				borderWidth: 1
				borderColor: '#FFF'
				padding: {top: 6}
				text: @data.chance
			
			@chanceLabel = new cs.Small
				name: 'Approval Label'
				parent: @
				x: @approvalChance.maxX + 4,
				y: @approvalChance.y + 8
				fontWeight: 500
				fontSize: 12
				color: cs.Colors.lightText
				color: 'a7d089'
				text: "% chance of being approved"
			
		# Product Name
		
		@productName = new cs.H4
			name: 'product Name' 
			parent: @
			y: @approvalChance.maxY + 8
			x: @approvalChance.maxX + 4
			width: @width - (@approvalChance.maxX + 4 + 38)
			text: "#{@data.brand} #{@data.category}"
			
		# More Icon
		
		@moreIcon = new cs.Icon
			name: 'More Icon'
			parent: @
			x: Align.right(-10)
			y: Align.center
			icon: 'chevron-right'
			color: '#CCC'
		
		# Product Detail
		
		@productDetail = new cs.SmallBold
			name: 'Product Detail'
			parent: @
			y: @productName.maxY + 18
			x: @approvalChance.maxX + 4
			fontSize: 12
			width: @width - (@approvalChance.maxX + 20)
			text: "#{@data.apr}% Representative APR"
			color: if @data.apr < 20 then '71b341' else Color.main
		
		# Checkbox
		
		@checkbox = new cs.Checkbox
			parent: @
			y: @cardImage.midY - 12
			x: -14
			opacity: 0
			visible: false
		
		@onTap (event) ->
			event.stopPropagation()
			return if @checkbox?.visible is false
			
			@checkbox?.isOn = !@checkbox?.isOn
		
	showCheckbox: ->
		@animate 
			x: 24
		@checkbox?.visible = true
		@checkbox?.animate
			opacity: 1
		
	hideCheckbox: ->
		@animate 
			x: 0
		@checkbox?.animate
			opacity: 0
		Utils.delay .25, => 
			@checkbox?.visible = false

# Checkbox Item

class CheckboxItem extends Layer
	constructor: (options = {}) ->
		
		_.assign options,
			backgroundColor: null
		
		_.defaults options,
			name: 'Checkbox Item'
			width: (Screen.width - 32) / 2
			value: ''
		
		@value = options.value
		
		super options
		
		@checkbox = new cs.Checkbox 
			parent: @
			x: 0, y: 12
		
		@labelLayer = new cs.Large
			parent: @
			x: 32, y: 12
			width: @width
			text: options.text
			
		@height = @labelLayer.maxY + 16
		
		@onTap -> 
			@checkbox.isOn = !@checkbox.isOn
			
	@define "isOn",
		get: -> return @checkbox.isOn

# ------------------
# Data

# Database

database = 
	
	creditCardOffers: []
	personalLoanOffers: []
	
	preapproved: [
		true, 
		false
		]
	categories: [
		'Rewards Cards',
		'Low APR',
		'Travel Abroad',
		'Balance Transfer',
		'Purchase Cards',
		'Credit Builder'
		]
	brands: [
		'Barclays', 
		'American Express', 
		'LUMA',
		'Vanquis',
		'Natwest',
		'Capital One',
		'TescoBank',
		'MBNA'
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
		'Amazon Cashback',
		'20 bottles of beer',
		'Free tickets to movies'
		]

_.assign database.creditCardOffers,
	filterLinkText: "All cards"
	title: 'Credit Cards'
	
_.assign database.personalLoanOffers, 
	filterLinkText: "All loans"
	title: 'Personal Loans'

# Credit Card Offer

class CreditCardOffer
	constructor: (options = {}) ->
		
		_.defaults options,
			
			#strings
			
			brand: _.sample(database.brands)
			category: _.sample(database.categories)
			features: _.sampleSize(database.features, _.random(3))
			aprType: _.sample(database.rateTypes)
			image: _.sample(database.cardImages)
			
			# numbers
			
			chance: _.random(50, 80)
			apr: _.random(12.5, 25.5).toFixed(1)
			
			# booleans
			
			exclusive: Math.random() > .9
			specialOffer: Math.random() > .9
			preapproved: Math.random() > .9

		_.assign @, options

		database.creditCardOffers.push(@)

# Personal Loan Offer

class PersonalLoanOffer
	constructor: (options = {}) ->
		
		_.defaults options,
			
			#strings
			
			brand: _.sample(database.brands)
			category: _.sample(database.categories)
			features: _.sampleSize(database.features, _.random(3))
			aprType: _.sample(database.rateTypes)
			image: _.sample(database.cardImages)
			
			# numbers
			
			chance: _.random(50, 80)
			apr: _.random(12.5, 25.5).toFixed(1)
			
			# booleans
			
			exclusive: Math.random() > .9
			specialOffer: Math.random() > .9
			preapproved: Math.random() > .9

		_.assign @, options

		database.personalLoanOffers.push(@)

# Filter

filter =
	brands: []
	categories: []
	features: []
	filters: []
	minAPR: null
	maxAPR: null
	preapproved: null
	sort: undefined
	
	clearFilters: ->		
		_.assign filter, 
			brands: []
			categories: []
			features: []
			minAPR: null
			maxAPR: null
			preapproved: null
	
	addFilter: (type, value) ->
		filter[type].push(value)
		
	removeFilter: (type, value) ->
		_.pull(filter[type], value)
	
	brand: (offer) ->
		if filter.brands.length is 0
			return true
		
		return _.includes(filter.brands, offer.brand)
	
	category: (offer) ->
		if filter.categories.length is 0
			return true
		
		return _.includes(filter.categories, offer.category)
	
	feature: (offer) ->
		if filter.features.length is 0
			return true
		
		return _.intersection(filter.features, offer.features)?
		
	apr: (offer) ->
		return true if not filter.minAPR? and not filter.maxAPR?
		
		if filter.minAPR < offer.apr < filter.maxAPR
			return true
		
		return false
		
	preapproved: (offer) ->
		return true if not filter.preapproved?
		
		return offer.preapproved ? false
		
filter.filters = [filter.category, filter.feature, filter.brand, filter.apr, filter.preapproved]


# Sort
sort =
	key: undefined
	direction: 'descending'
	clearSort: ->
		sort.key = undefined
		sort.direction = 'descending'

# ------------------
# Views  

# Products View

productsView = new cs.View
	name: 'Products View'
	title: 'Products'
	showLayers: false

productsView.build ->
	
	# top carousel
	
	@carousel = new Carousel
		parent: @content
	
	pages = [
		{
			title: "Christmas holidays?",
			subtitle: 'New AMEX to use abroad',
			ctaText: 'Find out more'
			callback: ->
				filter.clearFilters()
				filter.addFilter('brands', 'American Express')
				categoryView.loadCategory(
					database.creditCardOffers,
					"American Express"
					)
		}, {
			title: "Christmas shopping",
			subtitle: 'Try a new Purchase card',
			ctaText: 'Search purchase cards'
			callback: -> 
				filter.clearFilters()
				filter.addFilter('categories', 'Purchase Cards')
				categoryView.loadCategory(
					database.creditCardOffers,
					"Purchase Cards"
					)
		}, {
			title: "Going far?",
			subtitle: 'Get a Card with Airmiles',
			ctaText: 'Start saving'
			callback: -> 
				filter.clearFilters()
				filter.addFilter('features', 'Armiles')
				categoryView.loadCategory(
					database.creditCardOffers,
					"Armiles"
					)
		}, {
			title: "Elves on strike?",
			subtitle: 'Get a low-rate personal loan',
			ctaText: 'Sleigh this Way'
			callback: -> 
				filter.clearFilters()
				filter.addFilter('categories', 'Low APR')
				categoryView.loadCategory(
					database.personalLoanOffers,
					"Low APR"
					)
		}
	]
	
	for page, i in pages
		@carousel.addPage new CarouselPage page
		
	# recommended buttons
	
	@recommendedContainer = new Layer
		name: 'Categroy Container'
		parent: @content
		y: @carousel.maxY
		width: @width
		backgroundColor: '#FFF'
	
	do _.bind( ->
		
		@recommended = new cs.Text
			name: 'Recommended'
			parent: @
			y: 16
			x: 16
			type: 'body'
			text: 'Recommended'
		
		@recommendedLink = new cs.Text
			name: 'Recommended Link'
			parent: @
			y: 16
			x: Align.right(-16)
			type: 'body'
			color: 'primary'
			text: 'See all'
			
		@recommendedLink.onTap ->
			app.showOverlayBottom(categoriesOverlay)
			
		divider = new cs.Divider
			name: 'Divider'
			parent: @
			x: 16
			y: @recommendedLink.maxY + 16
			width: @width - 32
		
		@categoryScroll = new CategoryScroll
			parent: @
			y: divider.maxY + 24
			
		@height = @categoryScroll.maxY
		
		links = [
			{
				icon: "images/creditcards.png",
				text: 'Credit cards'
				callback: ->
					filter.clearFilters()
					categoryView.loadCategory(database.creditCardOffers)
			}, {
				icon: "images/bankloans.png",
				text: 'Personal loans'
				callback: ->
					filter.clearFilters()
					categoryView.loadCategory(database.personalLoanOffers)
			}, {
				icon: "images/carloans.png",
				text: 'Car finance'
				callback: -> null
			}, {
				icon: "images/mortgages.png",
				text: 'Mortgages'
				callback: -> null
			}
		]
		
		for link, i in links
			@categoryScroll.addLink new CategoryLink link
		
	, @recommendedContainer)
	
	_.assign productsView_static,
		parent: @content
		x: 0
		y: @recommendedContainer.maxY

# Category View

categoryView = new cs.View
	name: 'Category View'
	title: ''
	showLayers: false
	padding:
		top: 60, right: 0, 
		bottom: 0, left: 0
		stack: 0
	
categoryView.build ->
	
	@cards = []
	@currentOffers = undefined
	
	@content.backgroundColor = "#FFF"
	
	# navigation bar
	
	@subnav = new Layer
		name: 'Subnav'
		parent: @
		y: app.navigation.maxY
		height: 60
		width: Screen.width
		backgroundColor: '#2c3756'
		
	app.navigation.on "change:y", =>
		@subnav.y = app.navigation.maxY
	
	do _.bind(->
		
		@backButton = new Layer
			name: 'Back Button'
			parent: @
			x: 0
			height: @height
			width: @height + 32
			backgroundColor: null
			
		@backbuttonIcon = new cs.Icon
			name: 'Back Icon'
			parent: @backButton
			x: 8
			y: Align.center
			icon: 'chevron-left'
			color: 'white'
		
		@backButtonLabel = new cs.SmallBold 
			name: 'Back Label'
			parent: @backButton
			x: @backbuttonIcon.maxX
			y: Align.center
			text: "Back"
			color: 'white'
			width: 128
		
		#-
		
		@compareButton = new Layer
			name: 'Compare Button'
			parent: @
			x: Align.right(-16 + -(@height + 16) * 2)
			height: @height
			width: @height
			backgroundColor: null
		
		@compareButtonIcon = new cs.Icon
			name: 'Compare Icon'
			parent: @compareButton
			x: Align.center
			y: Align.center(-8)
			icon: 'repeat'
			color: 'white'
		
		@compareButtonLabel = new cs.Small
			name: 'Compare Label'
			parent: @compareButton
			x: Align.center
			y: Align.bottom(-6)
			width: 128
			text: "Compare"
			textAlign: 'center'
			color: 'white'
		
		#-
		
		@filtersButton = new Layer
			name: 'Filters Button'
			parent: @
			x: @compareButton.maxX + 16
			height: @height
			width: @height
			backgroundColor: null
		
		@filtersButtonIcon = new cs.Icon
			name: 'Filters Icon'
			parent: @filtersButton
			x: Align.center
			y: Align.center(-8)
			icon: 'tune'
			color: 'white'
			
		@filtersButtonLabel = new cs.Small
			name: 'Filters Label'
			parent: @filtersButton
			x: Align.center
			y: Align.bottom(-6)
			width: 128
			text: "Filters"
			textAlign: 'center'
			color: 'white'
		
		#-
		
		@categoriesButton = new Layer
			name: 'Categories Button'
			parent: @
			x: @filtersButton.maxX + 16
			height: @height
			width: @height
			backgroundColor: null
		
		@categoriesButtonIcon = new cs.Icon
			name: 'Categories Icon'
			parent: @categoriesButton
			x: Align.center
			y: Align.center(-8)
			icon: 'grid'
			color: 'white'
		
		@categoriesButtonLabel = new cs.Small
			name: 'Categories Label'
			parent: @categoriesButton
			x: Align.center
			y: Align.bottom(-6)
			width: 128
			text: "Categories"
			textAlign: 'center'
			color: 'white'
		
	, @subnav)
	
	
	# filters bar 
	
	@addToStack @filtersBar = new Layer
		name: 'Purchase Cards Bar'
		height: 48
		width: Screen.width
		backgroundColor: '#FFF'
		shadowY: 1
		shadowColor: 'rgba(0,0,0,.26)'
		
	do _.bind(->
	
		@labelLayer = new cs.Text
			name: 'Purchase Cards'
			parent: @
			type: 'body'
			y: Align.center
			x: 16
			text: "Purchase Cards"
			
		@tapArea = new Layer
			name: 'Tap Area'
			parent: @
			height: @height
			x: Align.right
			width: 128
			backgroundColor: null
		
		@labelLink = new cs.Text
			name: 'All Cards'
			parent: @tapArea
			type: 'link'
			y: Align.center
			x: Align.right(-16)
			textAlign: 'right'
			text: "All Cards"
			color: 'primary'
			
	, @filtersBar)
	
	# events
	
	@filtersBar.tapArea.onTap -> categoryView.clearFilters()
	@subnav.backButton.onTap -> app.showNext(productsView)
	@subnav.compareButton.onTap -> null #print 'show compare'
	@subnav.filtersButton.onTap -> filtersOverlay.show()
	@subnav.categoriesButton.onTap -> app.showOverlayBottom(categoriesOverlay)
		
categoryView.noResults = new cs.LargeBold
	name: 'No Results'
	parent: categoryView
	x: Align.center
	y: 300
	text: 'No Results'

# clear all filters and reset

categoryView.clearFilters = ->
	filter.clearFilters()
	sort.clearSort()
	
	Utils.delay .25, ->
		categoryView.loadCategory(
			categoryView.currentOffers,
			null,
			false
			)

# load cards for an array of offers

categoryView.loadCategory = (offers, filterLabel, changeView = true) ->
	return if not offers
	
	@title = offers.title
	@currentOffers = offers
	
	if changeView then app.showNext(@)
	
	# clear cards
	
	for card in @cards
		@removeFromStack(card)
		card.destroy()
	
	@cards = []
	
	@filtersBar.labelLayer.text = filterLabel
	@filtersBar.labelLink.text = offers.filterLinkText
	@filtersBar.height = if filterLabel? then 48 else 1
	
	# filter offers to only offers that passed all filter tests
	
	filteredOffers = _.filter(
		offers, 
		(offer) ->
			results = []
			
			testFilter = (f) -> return f(offer)
			results = _.map(filter.filters, testFilter)
			
			return not _.includes(results, false)
		)
	
	sortedOffers = _.sortBy(filteredOffers, sort.key)
	if sort.direction is "descending" then _.reverse(sortedOffers)
	
	categoryView.noResults.visible = sortedOffers.length <= 0
	
	for offer in _.take(sortedOffers, 24)

		# make new cards
		
		newCard = new OfferCard
			name: '.'
			data: offer
		
		do (newCard, offer) ->
			newCard.onTap ->
				singleView.showOffer(offer)
		
		@addToStack newCard
		
		@cards.push(newCard)
    
# Single View

singleView = new cs.View
	name: 'Single Offer View'
	title: 'Offer'
	showLayers: false
	padding:
		top: 60, right: 0, 
		bottom: 0, left: 0
		stack: 0

singleView.onMove -> 
	print singleView.scrollY
	if singleView.scrollY > 688
		singleView.footer.parent = singleView.content
		singleView.footer.y = static_view_single.maxY
	
	else
		singleView.footer.parent = singleView
		singleView.footer.y = app.footer.y
		
		

singleView.build ->
	
	@content.backgroundColor = "#FFF"
	
	static_view_single.parent = @content
	static_view_single.x = 0	
	static_view_single.y = -134
	
	static_view_single_bottom.parent = @content
	static_view_single_bottom.x = 0	
	static_view_single_bottom.y = static_view_single.maxY + 72
	
	# navigation bar
	
	@subnav = new Layer
		name: 'Subnav'
		parent: @
		y: app.navigation.maxY
		height: 60
		width: Screen.width
		backgroundColor: '#2c3756'
		backgroundBlur: 10
		
	app.navigation.on "change:y", =>
		@subnav.y = app.navigation.maxY
	
	do _.bind(->
		
		@backButton = new Layer
			name: 'Back Button'
			parent: @
			x: 0
			height: @height
			width: @height + 32
			backgroundColor: null
			
		@backbuttonIcon = new cs.Icon
			parent: @backButton
			x: 8
			y: Align.center
			icon: 'chevron-left'
			color: 'white'
		
		@backButtonLabel = new cs.SmallBold 
			parent: @backButton
			x: @backbuttonIcon.maxX
			y: Align.center
			text: "Back"
			color: 'white'
		
		#-
		
		@shareButton = new Layer
			name: 'Share Button'
			parent: @
			x: Align.right(-16)
			height: @height
			width: @height
			backgroundColor: null
		
		@shareButtonIcon = new cs.Icon
			parent: @shareButton
			x: Align.center
			y: Align.center(-8)
			icon: 'email-outline'
			color: 'white'
		
		@shareButtonLabel = new cs.Small
			parent: @shareButton
			x: Align.center
			y: Align.bottom(-6)
			width: 128
			text: "Share"
			textAlign: 'center'
			color: 'white'
			
	, @subnav)
	
	# footer
	
	@footer = new Layer
		name: 'Subnav'
		parent: @
		maxY: (app.footer?.y ? Screen.height)
		height: 72
		width: Screen.width
		backgroundColor: '#FFF'
		backgroundBlur: 10
		shadowY: -1
		
	app.footer?.on "change:y", =>
		return if @footer.parent isnt @
		@footer.maxY = app.footer.y
	
	do _.bind(->
		
		@icon = new cs.Icon
			parent: @
			y: Align.center
			x: 32
			color: '#87cb55'
			icon: 'checkbox-marked-circle'
			
		@icon.size = 32
		@icon.y = Align.center
		
		@label = new cs.SmallBold
			parent: @
			y: Align.center
			x: @icon.maxX + 4
			text: 'PRE APPROVED'
			color: '#87cb55'
		
		@cta = new cs.Button
			parent: @
			type: 'body'
			fill: '#0492bd'
			color: '#FFF'
			text: 'Apply now'
			size: 'auto'
			y: Align.center
		
		@cta.x = Align.right(-16)
			
	, @footer)
	
	# image
	
	@imageLayerContainer = new Layer
		name: 'Background Image Container'
		parent: @content
		width: @width
		height: 212
		backgroundColor: '#bfcddf'
		clip: true
	
	@imageLayer = new Layer
		name: 'Background Image'
		parent: @imageLayerContainer
		size: @imageLayerContainer.size
		point: Align.center
		scale: 1.5
		blur: 10
	
	# card image
	
	@cardImageLayer = new Layer
		name: 'Card Image'
		parent: @content
		width: 213
		height: 136
		x: Align.center
		y: 96
		backgroundColor: '#0069b5'
		borderRadius: 4
		shadowY: 1
		shadowBlur: 3
		
	# star rating
	
	@rating = new Layer
		name: 'Rating'
		parent: @content
		x: Align.center
		y: @cardImageLayer.maxY + 24
		width: 153
		height: 21
		image: 'images/stars_score.png'
		
	# Card Title
	
	@cardBrand = new cs.H1
		name: 'Title'
		parent: @content
		x: Align.center
		y: @rating.maxY + 8
		width: @width
		textAlign: 'center'
		fontSize: 28
		fontWeight: 300
		color: '#404F5D'
	
	# Card Category
	@cardCategory = new cs.H1
		name: 'Category'
		parent: @content
		x: Align.center
		y: @cardBrand.maxY
		width: @width
		textAlign: 'center'
		fontSize: 28
		fontWeight: 300
		color: '#404F5D'
	
	# APR
	@cardAPR = new cs.H1
		name: 'Category'
		parent: @content
		x: Align.center
		y: @cardCategory.maxY
		width: @width
		textAlign: 'center'
		fontSize: 28
		fontWeight: 300
		color: '#0492BD'
		
	# Events
	
	@subnav.backButton.onTap -> app.showPrevious()
	@subnav.shareButton.onTap -> null # print 'show share'

singleView.showOffer = (offer = _.sample(database.creditCardOffers)) ->
	app.showNext(@)
	
	@imageLayer.image = offer.image
	@imageLayer.blur = 32
	
	@cardImageLayer.image = offer.image
	
	@cardBrand.text = offer.brand
	@cardCategory.text = offer.category
	@cardAPR.text = offer.apr + '% ' + offer.aprType + ' APR'

# ------------------
# Overlays

# Filters Overlay

filtersOverlay = new cs.View
	name: 'Filters Overlay'
	title: 'Filters'
	padding: {top: 8, stack: 0, bottom: 6}
	showLayers: false
	
filtersOverlay.build ->
	@backgroundColor = '#FFF'
	@content.backgroundColor = '#FFF'
	
	# ----------------------------------
	# Clear Filterse / Close Button
	
	titleRow = new Layer
		height: 60
		width: @width
		backgroundColor: null
	
	do _.bind( ->
		
		@labelLayer = new cs.SmallBold
			parent: @
			y: Align.center()
			padding: {top: 20, right: 20, left: 20, bottom: 20}
			text: 'Clear Filters'
			textDecoration: 'underline'
			color: '#008bb2'
			width: 300
	
		@backButton = new cs.Icon
			parent: @
			icon: 'close'
			x: Align.right(-20)
			y: Align.center
			color: '#979797'

	, titleRow)
	
	@addToStack titleRow
	@addToStack new cs.Divider
		width: @width
	
	# ----------------------------------
	# Sort Cards Buttons
	
	@sortCards = new Layer
		name: 'Pre Approved Filters'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new cs.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'Sort cards by'
		
		sortButtons = []
		
		buttons = [
			{text: 'Eligability', 	key: 'chance',	direction: 'descending'}
			{text: 'APR', 			key: 'apr',		direction: 'ascending'}
			{text: 'A to Z', 		key: 'brand',	direction: 'ascending'}
			]
		
		@buttonLayers = []
		
		for button, i in buttons
			newButton = new cs.Button 
				parent: @
				x: 16 + (((@width - 48) + 16) / 3 * i)
				y: @labelLayer.maxY + 16
				text: button.text
				size: 'auto'
				border: 'main'
				fill: "white"
				type: 'body1'
				toggle: true
				group: sortButtons
			
# 			newButton.textLayer.textAlign = 'center'
				
			newButton.key = button.key
			
			do (newButton, button) ->
				newButton.action = ->
					sort.key = button.key
					sort.direction = button.direction
				
			newButton.showPressed = -> null
			
			newButton.on "change:isOn", ->
				if @isOn  
					@animate {backgroundColor: '#253454'}
					@textLayer.animate {color: '#FFF'}
				else 
					@animate {backgroundColor: '#FFF'}
					@textLayer.animate {color: '#253454'}
		
			newButton.width = (@width - 48) / 3
			newButton.textLayer.padding = {}
			
			@buttonLayers.push(newButton)
			
		@height = newButton.maxY + 16
		
		@clear = ->
			for button in @buttonLayers
				button.isOn = false
		
		@update = -> 
			for button in @buttonLayers
				button.isOn = button.key is sort.key
	
	, @sortCards)
	
	@addToStack @sortCards
	
	# ----------------------------------
	# Pre Approved Switch
	
	@preApprovedFilter = new Layer
		name: 'Pre Approved Filters'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new cs.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'Pre approved filters only'
			
		@uiSwitch = new cs.Switch
			parent: @
			x: Align.right(-20)
			y: Align.center
			
		@divider = new cs.Divider
			parent: @
			width: @width - 40
			x: 20
			y: Align.bottom
			
		@report = -> return @uiSwitch.isOn
		
		@clear = -> @uiSwitch.isOn = false
		
		@update = -> @uiSwitch.isOn = filter.preapproved
			
	, @preApprovedFilter)
	
	@addToStack @preApprovedFilter
	
	# -------------------------------------
	# Card Categories
		
	@cardCategories = new Layer
		name: 'Card Categories'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new cs.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'Card Categories'
		
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
				
		@divider = new cs.Divider
			parent: @
			width: @width - 40
			x: 20
			y: checkbox.maxY + 20
			
		@height = @divider.maxY
		
		@report = => 
			onItems = _.filter(@items, 'isOn')
			onValues = _.map(onItems, 'value')
			return onValues
		
		@clear = -> 
			for item in @items
				item.checkbox.isOn = false
		
		@update = =>
			for item in @items
				item.checkbox.isOn = _.includes(filter.categories, item.value)
			
	, @cardCategories)
	
	@addToStack @cardCategories
	
	# -------------------------------------
	# APR Slider
		
	@apr = new Layer
		name: 'Brands'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new cs.LargeBold
			parent: @
			x: 20, y: Align.center(4)
			text: 'APR'
				
		@slider = new RangeSliderComponent
			name: 'Slider'
			parent: @
			width: @width - 80
			x: Align.center
			y: @labelLayer.maxY + 40
			backgroundColor: '#f2f2f2'
			min: 0
			minValue: 0
			max: 50
			maxValue: 50
		
		@slider.minKnob.draggable.propagateEvents = false
		@slider.minKnob.draggable.momentum = false
		@slider.maxKnob.draggable.propagateEvents = false
		@slider.maxKnob.draggable.momentum = false
		
		@slider.fill.backgroundColor = cs.Colors.main
		
		offset = if Framer.Device.context.scale is 1 then 3 else 3
		
		@minKnobIcon = new cs.Icon
			parent: @slider.minKnob
			height: 18, width: 18
			x: Align.center
			y: offset
			icon: 'code-tags'
			color: cs.Colors.main
			
		@maxKnobIcon = new cs.Icon
			parent: @slider.maxKnob
			height: 18, width: 18
			x: Align.center
			y: offset
			icon: 'code-tags'
			color: cs.Colors.main
			
		@minLabel = new cs.Large
			parent: @
			color: '8d9499'
			y: @slider.maxY + 20
			textAlign: 'center'
			text: '{value}%'
			
		minMarker = new Layer
			parent: @
			color: '8d9499'
			x: @slider.screenFrame.x + 10
			y: @slider.y - 5
			width: 1
			height: 10 + @slider.height
		
		@midLabel = new cs.Large
			parent: @
			color: '8d9499'
			y: @slider.maxY + 20
			textAlign: 'center'
			text: '{value}%'
		
		midMarker = new Layer
			parent: @
			color: '8d9499'
			x: @width / 2
			y: @slider.y - 5
			width: 1
			height: 10 + @slider.height
			
		@maxLabel = new cs.Large
			parent: @
			color: '8d9499'
			y: @slider.maxY + 20
			textAlign: 'right'
			text: '{value}%'
		
		maxMarker = new Layer
			parent: @
			color: '8d9499'
			x: @slider.screenFrame.x + @slider.width - 10
			y: @slider.y - 5
			width: 1
			height: 10 + @slider.height
		
		@slider.bringToFront()
			
		@divider = new cs.Divider
			parent: @
			width: @width - 40
			x: 20
			y: @maxLabel.maxY + 35
		
		@report = -> 
			return {
				min: @slider.minValue
				max: @slider.maxValue
			}
					
		@clear = -> 
			@slider.minValue = @slider.min
			@slider.maxValue = @slider.max
		
		@update = =>
			
			min = _.minBy(database.creditCardOffers, 'apr')?.apr ? 0
			max = _.maxBy(database.creditCardOffers, 'apr')?.apr ? 50
			
			@currentMin = parseInt(min)
			@currentMax = parseInt(max)
			
			@slider.min = @currentMin
			@slider.max = @currentMax
			
			@slider.minValue = filter.minAPR ? @currentMin
			@slider.maxValue = filter.maxAPR ? @currentMax

			@minLabel.template = @slider.valueForPoint(10).toFixed()
			@midLabel.template = @slider.valueForPoint(@slider.width /  2).toFixed()
			@maxLabel.template = @slider.valueForPoint(@slider.width - 10).toFixed()
		
			@minLabel.midX = @slider.x + 10
			@midLabel.midX = @slider.midX
			@maxLabel.midX = @slider.maxX - 10
			
		@height = @divider.maxY
			
	, @apr)
	
	@addToStack @apr
	
	# ------------------------------------
	# Brands
	
	@brands = new Layer
		name: 'Brands'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new cs.LargeBold
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
			
		@divider = new cs.Divider
			parent: @
			width: @width - 40
			x: 20
			y: checkbox.maxY + 20
		
		@report = => 
			onItems = _.filter(@items, 'isOn')
			onValues = _.map(onItems, 'value')
			return onValues
		
		@clear = -> 
			for item in @items
				item.checkbox.isOn = false
		
		@update = =>
			for item in @items
				item.checkbox.isOn = _.includes(filter.categories, item.value)
		
		@height = @divider.maxY
			
	, @brands)
	
	@addToStack @brands
	
	# --------------------------------
	# Features
		
	@features = new Layer
		name: 'Features'
		width: @width
		height: 60
		backgroundColor: null
		
	do _.bind( ->
		
		@labelLayer = new cs.LargeBold
			name: 'Features Label'
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
		
		@report = => 
			onItems = _.filter(@items, 'isOn')
			onValues = _.map(onItems, 'value')
			return onValues
		
		@clear = -> 
			for item in @items
				item.checkbox.isOn = false
		
		@update = =>
			for item in @items
				item.checkbox.isOn = _.includes(filter.categories, item.value)
		
		@height = checkbox.maxY + 20
			
	, @features)
	
	@addToStack @features
	
	# -------------------------------
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
	
		@button = new cs.Button
			name: 'Footer Text'
			parent: @
			point: Align.center()
			size: 'large'
			color: 'white'
			fill: 'rgba(0, 139, 178, 1.000)'
			type: 'body1'
			text: 'Apply Filters'
	
	, @footer)
	
	# -------------------------------
	# Events
	
	titleRow.backButton.onTap -> 
		filtersOverlay.hide()
		
	titleRow.labelLayer.onTap ->
		categoryView.clearFilters()
		Utils.delay .35, -> filtersOverlay.hide()
		
	@footer.button.action = ->
		filtersOverlay.setFilters()
		filtersOverlay.hide()
	
	# -------------------------------
	# functions
	
	@show = =>
		@resetItems()
		
		app.showOverlayBottom(@)
		
		@footer.maxY = app.footer.y
		
		app.footer.on "change:y", =>
			@footer.maxY = app.footer.y
	
	@hide = =>
		app.showPrevious()
		
	@resetItems = =>
		for section in [@cardCategories, @brands, @features]
			section.update()
		
		@preApprovedFilter.update()
		@apr.update()
		@sortCards.update()
	
	@setFilters = =>
		filter.clearFilters()
		
		filter.preapproved = @preApprovedFilter.report()
		filter.categories = @cardCategories.report()
		filter.brands = @brands.report()
		filter.features = @features.report()
		filter.minAPR = @apr.report().min
		filter.maxAPR = @apr.report().max
		
		hasAPR = if filter.minAPR > @apr.slider.min or filter.maxAPR < @apr.slider.max then 1 else 0
		hasPreapproved = if filter.preapproved then 1 else 0
		
		filtersCount = _.sum(
			[
				filter.categories.length,
				filter.brands.length,
				filter.features.length,
				hasAPR,
				hasPreapproved
			]
		)
		
		# set filter text for category view if that's the previous page
		
		filterText = if filtersCount > 0 then "#{filtersCount} Filters" else null
		
		if app.previous is categoryView
		
			categoryView.loadCategory(
				categoryView.currentOffers,
				filterText,
				false
				)
		
	@refresh = -> null	

# Categories Overlay

categoriesOverlay = new cs.View
	name: 'Categories Overlay'
	title: 'Categories'
	padding: {top: 8, stack: 0, bottom: 6}
	showLayers: false
	
categoriesOverlay.build ->
	@backgroundColor = '#FFF'
	@content.backgroundColor = '#FFF'
	
	# ----------------------------------
	# Title Row / Close Button
	
	images = [
		"images/energyImg.png",
		"images/savingsImg.png",
		"images/telcosImg.png",
		"images/insuranceImg.png",
		"images/carfinanceImg.png",
		"images/personalloansImg.png",
		"images/creditcardsImg.png",
		"images/mortgagesImg.png",
	]
	
	for category, i in database.categories
		button = new Layer
			parent: @content
			x: 11 + (i % 2) * ((@width - 11) / 2)
			y: 11 + Math.floor(i / 2) * (140 + 11)
			width: (@width - 33) / 2
			height: 140
			image: images[i]
		
		dimMask = new Layer
			parent: button
			size: button.size
			backgroundColor: 'rgba(0,0,0,.35)'
		
		labelLayer = new cs.MediumBold
			parent: button
			y: Align.center
			width: button.width
			text: category
			color: 'white'
			textAlign: 'center'
		
		do (button, category) ->
			
			button.onTap ->
				
				app.showPrevious()
				
				filter.clearFilters()
				filter.addFilter('categories', category)
				
				categoryView.loadCategory(
					database.creditCardOffers,
					category,
					true
					)

# ------------------
# Start

for i in _.range(100)
	new CreditCardOffer
	
for i in _.range(100)
	new PersonalLoanOffer

app.showNext(productsView)