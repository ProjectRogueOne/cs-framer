# 	dP
# 	88
# 	88 .d8888b. .d8888b. 88d888b.
# 	88 88'  `"" 88'  `88 88'  `88
# 	88 88.  ... 88.  .88 88    88
# 	dP `88888P' `88888P' dP    dP

# @steveruizok
# github.com/steveruizok/framer-icon
# updated: 16 Dec 2017

define = (layer, property, value) ->
	Object.defineProperty layer,
		property,
		get: -> return layer["_#{property}"]
		set: (value) -> 
			return if value is layer["_#{property}"]

			layer["_#{property}"] = value
			layer.emit("change:#{property}", value, layer)
	
	if value?
		layer["_#{property}"] = value

icons = {
	"custom-menu":"M 26,4 L 2,4 C 0.9,4 0,3.1 0,2 0,0.9 0.9,-0 2,-0 L 26,-0 C 27.1,-0 28,0.9 28,2 28,3.1 27.1,4 26,4 L 26,4 Z M 2,8 L 26,8 C 27.1,8 28,8.9 28,10 28,11.1 27.1,12 26,12 L 2,12 C 0.9,12 0,11.1 0,10 0,8.9 0.9,8 2,8 L 2,8 Z M 20,16 C 21.1,16 22,16.9 22,18 22,19.1 21.1,20 20,20 L 2,20 C 0.9,20 0,19.1 0,18 0,16.9 0.9,16 2,16 L 20,16 Z M 20,16",
	# ios footer controls:
	"ios-back":"M213.089096,256.5 L357.982048,111.701564 C368.672651,101.017935 368.672651,83.6963505 357.982048,73.0127216 C347.291446,62.3290928 329.958554,62.3290928 319.267952,73.0127216 L155.017952,237.155579 C144.327349,247.839208 144.327349,265.160792 155.017952,275.844421 L319.267952,439.987278 C329.958554,450.670907 347.291446,450.670907 357.982048,439.987278 C368.672651,429.30365 368.672651,411.982065 357.982048,401.298436"
	# lots of material icons:
	}

# -- Enjoy! @steveruiok
class exports.Icon extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		_.defaults options,
			name: 'Icon'
			width: 24
			height: 24
			icon: 'star'
			backgroundColor: null
			clip: true
			lineHeight: 0
			animationOptions:
				time: .25

		super options

		svgNS = "http://www.w3.org/2000/svg"
		@ctx = document.createElementNS(svgNS, 'svg')
		@svgIcon = document.createElementNS(svgNS, 'path')
		
		@ctx.appendChild(@svgIcon)
		@_element.appendChild(@ctx)

		# when tap ends, turn on / off

		define(@, "icon")

		throttleSetSize = Utils.throttle .15, @_setSize

		@on "change:icon", @_refresh
		@on "change:color", @_refresh
		@on "change:size", throttleSetSize

		delete @__constructor
		_.assign @,
			icon: options.icon
			padding: options.padding
			color: options.color

		@_refresh()
		Utils.delay 0, @_setSize

	_setSize: =>
		return if @__constructor

		@setAttributes @ctx,
			width: '100%'
			height: '100%'
			viewBox: "0 0 512 512"

	addIcon: (iconObj) ->
		icons = _.merge(icons, iconObj)
		@icon = _.keys(iconObj)[0]

	setAttributes: (element, attributes = {}) ->
		for key, value of attributes
			element.setAttribute(key, value)

	showPressed: (isPressed) ->
		@animateStop()
		if isPressed
			@animate {brightness: 80}
		else 
			if @isOn then @animate {brightness: 85}
			else @animate {brightness: 100}

	_refresh: ->
		return if @__constructor
		
		return if not @color? or not @icon?

		@setAttributes @svgIcon,
			d: icons[@icon]
			fill: @color
			transform: "scale(1, -1), translate(0, -448)"