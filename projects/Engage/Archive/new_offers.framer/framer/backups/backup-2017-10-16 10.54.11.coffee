cs = require 'cs'
cs.Context.setStandard()

# Screen Setup

Framer.Device.customize
	deviceType: Framer.Device.Type.Tablet
	screenWidth: 1440
	screenHeight: 1024
	deviceImage: 'modules/cs-ux-images/safari_device.png'
	deviceImageWidth: 1442	
	deviceImageHeight: 1087
	devicePixelRatio: 1

Framer.Device.screen.y = 62

MODAL_BACKGROUND = true
BLURRY_BACKGROUND = true
MODAL_BLURRY = true

ACTIVE_BACKGROUND = modal_blurry

popUp = undefined

# Backgrounds

default_bg.props =
	frame: Screen.frame

modal_bg.props =
	frame: Screen.frame
	opacity: 0

blurry_bg.props =
	frame: Screen.frame
	opacity: 0

modal_blurry.props =
	frame: Screen.frame
	opacity: 0

default_bg.sendToBack()

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

class PopUp extends Layer
	constructor: (options = {}) ->
		
		options.title ?= 'Title'
		options.body ?= 'Body'
		
		super _.defaults options,
			name: 'Pop Up'
			width: 332
			height: 100
			backgroundColor: '#FFF'
			borderRadius: 5
		
		@arrow = new Layer
			parent: @
			height: 16
			width: 16
			rotation: 45
			x: Align.center
			y: -8
			backgroundColor: '#FFF'
		
		@headerLayer = new cs.MediumBold
			parent: @
			x: 16
			y: 28
			type: 'body'
			width: @width - 32
			textAlign: 'center'
			text: options.title
		
		@bodyLayer = new cs.Small
			parent: @
			x: 36
			y: 64
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
		
		@button.x = Align.center
		
		@height = @button.maxY + 30
		
		# animate in
		@show()
	
	show: ->
		@props =
			originY: 0
			scale: .7
			opacity: 0
			animationOptions:
				time: .25
				delay: .15
		
		@animate
			scale: 1
			opacity: 1
		
		
		
		ACTIVE_BACKGROUND.placeBehind(@)
		ACTIVE_BACKGROUND.animate
			opacity: 1
			options: 
				time: .4
		
		offers_button.placeBehind(@)
		offers_button.animate
			opacity: 1
			options: 
				time: .4
		
		closeButton.bringToFront()
		closeButton.animate
			opacity: 1
			options: 
				time: .4

		

Utils.delay 2, =>
	new PopUp
		title: 'You’ve got new offers'
		body: 'We search the market to find the best offers for you - for credit cards, loans, car finance, mortgages and more. Your score has improved, which means your offers have, too!'
		y: 95
		x: 529
		

