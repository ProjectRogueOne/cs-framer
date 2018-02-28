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
		options.isOn = false
		
		_.assign options,
			y: 285
			width: (Screen.width - 48) / 2
			backgroundColor: null
		
		super options
		
		@titleLayer = new cs.MediumBold
			parent: @
			y: 16
			color: '#FFF'
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
			
	@define "isOn",
		get: -> return @_isOn
		set: (bool) ->
			@_isOn = bool
			
			@emit "change:isOn", bool, @

# Offers Pager
class OffersPager extends PageComponent
	constructor: (options = {}) ->
		
		super options

# - implementation

app = new cs.App
	type: 'safari'
		
view = new cs.View
	image: template.image
	
view.content.backgroundColor = null
app.navigation.backgroundColor = null

view.build ->
	
	# buttons
	
	offersButton = new TabButton
		parent: @content
		title: 'Offers'
		isOn: true
		x: 24 + ((Screen.width - 48) / 2) * 0
	
	coachingButton = new TabButton
		parent: @content
		title: 'Coaching'
		x: 24 + ((Screen.width - 48) / 2) * 1
	
	# pages
	
	offers = new Layer
		name: 'Offers'
		parent: @content
		width: Screen.width
		height: 120
		
	coaching = new Layer
		name: 'Coaching'
		parent: @content
		width: Screen.width
		height: 120
		
	# pager
	
	offersPager = new OffersPager
		parent: @content
		y: 359
		width: Screen.width
		height: 120
	
	offersPager.on "change:currentPage", ->
		if @currentPage.name is "Offers"
			offersButton.isOn = true
			coachingButton.isOn = false
		else if @currentPage.name is "Coaching"
			coachingButton.isOn = true
			offersButton.isOn = false
		
	offersPager.addPage(offers)

	offersPager.addPage(coaching)