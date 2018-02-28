cs = require 'cs'
cs.Context.setStandard()

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
	
closeButton = new cs.Icon
	type: 'close'
	x: Align.right(-32)
	y: 32
	color: 'white'
	opacity: 0
	
closeButton.onTap ->
	popUp.hide()

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
			width: 332
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
			y: 46
		
		@headerLayer = new cs.MediumBold
			parent: @
			x: 16
			y: @icon.maxY + 8
			type: 'body'
			width: @width - 32
			textAlign: 'center'
			text: options.title
		
		@bodyLayer = new cs.Small
			parent: @
			x: 36
			y: @headerLayer.maxY + 16
			width: @width - 72
			textAlign: 'center'
			text: options.body
			
		@button = new cs.Button
			parent: @
			size: 'auto'
			text: 'See my offers'
			type: 'body1'
			color: 'white'
			fill: '#0592bc'
			y: @bodyLayer.maxY + 28
			action: @hide
		
		@button.x = Align.center
		
		@height = @button.maxY + 30
		
		# animate in
		@show()
	
	show: =>
		@props =
			y: @base.y - 32
			originY: 0
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
view.content.image = bg_image.image

app._navigation.backg = bg_image.image

new PopUp
	parent: view
	y: 136
	x: Align.center
	title: 'You’ve got new offers'
	body: 'We search the market to find the best offers for you - for credit cards, loans, car finance, mortgages and more. Your score has improved, which means your offers have, too!'
