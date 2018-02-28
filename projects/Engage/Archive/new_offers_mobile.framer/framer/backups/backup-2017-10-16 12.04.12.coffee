cs = require 'cs'
cs.Context.setMobile()

# settings

# global speed factor for animations (used to tweak timings)
ANIMATION_SPEED_FACTOR = 1


# active backgrounds: 
# modal_blurry, 
# modal_bg, 
# blurry_bg
# blurry_bg_smaller


# how fast the popup should show
POPUP_SPEED = .25

# how fast the background should show
BACKGROUND_SPEED = .4

# delay between background and popup
BACKGROUND_DELAY = .15

# Furniture

offers_button.props = 
	x: 675
	y: 40
	width: 87
	height: 32
	opacity: 0
	


# PopUp

popUp = undefined

class PopUp extends Layer
	constructor: (options = {}) ->
		
		popUp?.hide()
		popUp = @
		
		options.title ?= 'Title'
		options.body ?= 'Body'
		
		super _.defaults options,
			name: 'Pop Up'
			width: 300
			height: 100
			backgroundColor: '#FFF'
			borderRadius: 5
		
		@base =
			y: @y
		
		@icon = new Layer
			parent: @
			height: 64
			width: 64
			image: cards.image
			x: Align.center
			y: 48
		
		@headerLayer = new cs.H4
			parent: @
			x: 16
			y: @icon.maxY + 48
			fontSize: 20
			fontWeight: 400
			width: @width - 32
			textAlign: 'center'
			text: options.title
		
		@bodyLayer = new cs.Small
			parent: @
			x: 24
			y: @headerLayer.maxY + 16
			width: @width - 48
			textAlign: 'center'
			text: options.body
			
		@button = new cs.Button
			parent: @
			text: 'See my offers'
			type: 'body'
			color: 'white'
			fill: '#0592bc'
			y: @bodyLayer.maxY + 34
			action: @hide
		
		@button.x = Align.center
		
		@height = @button.maxY + 30
		
		# animate in
		@show()
	
	show: =>
		@props =
			y: @base.y - 32
			scale: .7
			opacity: 0
		
		@animate
			y: @base.y
			scale: 1
			opacity: 1
			options:
				time: POPUP_SPEED
				delay: BACKGROUND_DELAY
				
	hide: =>
		@animate
			y: @base.y - 8
			scale: .7
			opacity: 0
			options:
				time: POPUP_SPEED

Framer.Loop.delta = 1 / (60 / ANIMATION_SPEED_FACTOR)

app = new cs.App
	type: 'safari'
	navigation: 'default'

view = new cs.View
view.image = bg_image.image
view.content.backgroundColor = null

app._navigation.backgroundColor = 'rgba(0,0,0,0)'

newPopup = ->
	new PopUp
		parent: view
		y: app.navigation.maxY + 32
		x: Align.center
		title: 'You’ve got new offers'
		body: 'We search the market to find the best offers for you - for credit cards, loans, car finance, mortgages and more. Your score has improved, which means your offers have, too!'

showButton = new Layer
	parent: view
	type: 'close'
	x: Align.center
	y: Align.center(32)
	height: 500
	width: 400
	opacity: 0
	
showButton.onTap ->
	popUp.show()