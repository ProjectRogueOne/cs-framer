cs = require 'cs'
cs.Context.setMobile()

# ---------------------------------
# app

SHOW_PROGRESS = true

# - classes

# Tab Button
class TabButton extends Layer
	constructor: (options = {}) ->
		@__constructor = true 
		
		@_title
		options.title ?= 'Tab'
		
		@_isOn
		options.isOn ?= false
		
		_.assign options,
			y: 420
			width: (Screen.width - 48) / 2
			backgroundColor: null
		
		super options
		
		@titleLayer = new cs.MediumBold
			parent: @
			y: 16
			color: '#CCC'
			text: options.title
			width: @width
			textAlign: 'center'
			
		@indicator = new Layer
			parent: @
			height: 3
			backgroundColor: '#CCC'
			y: @titleLayer.maxY + 16
			width: @width
			
		@height = @indicator.maxY + 8
		
		delete @__constructor
		
		@on "change:isOn", ->
			if @isOn
				@titleLayer.color = "#FFF"
				@indicator.backgroundColor = "#FFF"
				return
			
			@titleLayer.color = "#CCC"
			@indicator.backgroundColor = "#CCC"
			
		@isOn = options.isOn
			
	@define "isOn",
		get: -> return @_isOn
		set: (bool) ->
			return if @__constructor
			
			@_isOn = bool
			
			@emit "change:isOn", bool, @

# Offers Scroll
class OffersPager extends ScrollComponent
	constructor: (options = {}) ->
		
		_.assign options,
			width: Screen.width
			height: 120
			propagateEvents: false

		super options
		
		@scrollVertical = false

# 		@on "change:currentPage", ->
# 			if @currentPage.name is "Offers"
# 				offersButton.isOn = true
# 				coachingButton.isOn = false
# 			else if @currentPage.name is "Coaching"
# 				coachingButton.isOn = true
# 				offersButton.isOn = false

# Offer Button
class OfferButton extends cs.Donut
	constructor: (options = {}) ->
		
		@icon = options.icon ? 'cards'
		@title = options.title ? 'Credit Cards'
		
		_.assign options,
			height: 84
			width: 84
			borderRadius: 100
		
		super options
		
		_.assign @,
			backgroundColor: 'rgba(255,255,255,.16)'
			borderWidth: 1
			borderColor: 'rgba(255,255,255,.36)'
			min: 0
			max: 100
			stroke: 'tertiary'
			value: options.value
		
		@numberLayer.opacity = 0
		@content.backgroundColor = 'rgba(0,0,0,0)'
		
		@iconLayer = new Layer
			name: 'Icon'
			parent: @
			width: 64
			height: 64
			point: Align.center
			image: "images/#{@icon}.png"
			
		@titleLayer = new cs.Small
			name: 'Title'
			parent: @
			color: '#FFF'
			text: @title
			width: @width
			textAlign: 'center'
			y: @maxY + 8


# - implementation

app = new cs.App
	type: 'safari'
		
view = new cs.View
	image: bg.image
	
view.content.backgroundColor = null
app.navigation.backgroundColor = null

# buttons

offersButton = new TabButton
	parent: view
	title: 'Offers'
	x: 24 + ((Screen.width - 48) / 2) * 0
	isOn: true

offersButton.onTap ->
	offersPager.snapToPage(offers)

coachingButton = new TabButton
	parent: view
	title: 'Coaching'
	x: 24 + ((Screen.width - 48) / 2) * 1

coachingButton.onTap ->
	offersPager.snapToPage(coaching)
	
#-  Pages

# offers

for button, i in [
	{title: 'Credit Cards', icon: 'cards', value: 42},
	{title: 'Loans', icon: 'bankloans', value: 15},
	{title: 'Car Finance', icon: 'autoloans', value: 42},
	{title: 'Mortages', icon: 'mortgages', value: 42},
	{title: 'Credit Cards', icon: 'cards', value: 42},
	{title: 'Loans', icon: 'bankloans', value: 42},
	{title: 'Car Finance', icon: 'autoloans', value: 42},
	{title: 'Mortages', icon: 'mortagges', value: 42},
]
	cardButton = new OfferButton
		parent: offers.content
		x: 104 * i
		icon: button.icon
		title: button.title
		value: if SHOW_PROGRESS then button.value else null

# coaching
	
coaching = new ScrollComponent
	name: 'Coaching'
	parent: view
	width: Screen.width
	height: 120
	contentInset: {left: 24, right: 24}

coaching.scrollVertical = false
coaching.propagateEvents = false

for button, i in [
	{title: 'Credit Cards', icon: 'cards', value: 12},
	{title: 'Loans', icon: 'bankloans', value: 2},
	{title: 'Car Finance', icon: 'autoloans', value: 85},
	{title: 'Mortages', icon: 'mortgages', value: 12},
	{title: 'Credit Cards', icon: 'cards', value: 65},
	{title: 'Loans', icon: 'bankloans', value: 72},
	{title: 'Car Finance', icon: 'autoloans', value: 42},
	{title: 'Mortages', icon: 'mortagges', value: 15},
]
	cardButton = new OfferButton
		parent: coaching.content
		x: 104 * i
		icon: button.icon
		title: button.title
		value: if SHOW_PROGRESS then button.value else null
	
# pager

offersScroll = new OffersPager
	parent: view
	y: 494
	icon: 'cards'