cs = require 'cs'
cs.Context.setMobile()

# ---------------------------------
# app


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

# Offers Pager
class OffersPager extends PageComponent
	constructor: (options = {}) ->
		
		_.assign options,
			width: Screen.width
			height: 120
			propagateEvents: false

		super options
		
		@scrollVertical = false

		@on "change:currentPage", ->
			if @currentPage.name is "Offers"
				offersButton.isOn = true
				coachingButton.isOn = false
			else if @currentPage.name is "Coaching"
				coachingButton.isOn = true
				offersButton.isOn = false

# Offer Button
class OfferButton extends Layer
	constructor: (options = {}) ->
		
		@icon = options.icon ? 'cards'
		@title = options.title ? 'Credit Cards'
		
		_.assign options,
			height: 84
			width: 84
			borderRadius: 100
			backgroundColor: 'rgba(255,255,255,.16)'
		
		super options
		
		
		
		

# - implementation

app = new cs.App
	type: 'safari'
		
view = new cs.View
	image: template.image
	
view.content.backgroundColor = null
app.navigation.backgroundColor = null

# buttons

offersButton = new TabButton
	parent: view
	title: 'Offers'
	x: 24 + ((Screen.width - 48) / 2) * 0
	isOn: true

coachingButton = new TabButton
	parent: view
	title: 'Coaching'
	x: 24 + ((Screen.width - 48) / 2) * 1

# pages

offers = new Layer
	name: 'Offers'
	parent: view
	width: Screen.width
	height: 120
	
cardButton = new OfferButton
	parent: offers
	x: 24
	
	
coaching = new Layer
	name: 'Coaching'
	parent: view
	width: Screen.width
	height: 120
	
# pager

offersPager = new OffersPager
	parent: view
	y: 494

offersPager.addPage(offers)

offersPager.addPage(coaching)