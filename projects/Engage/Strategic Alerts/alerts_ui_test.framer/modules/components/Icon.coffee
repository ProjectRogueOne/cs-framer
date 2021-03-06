{ theme } = require 'components/Theme'

class exports.Icon extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		# ---------------
		# Options

		_.defaults options,
			name: 'Icon'
			size: 24
			icon: 'star'
			backgroundColor: null
			clip: true
			lineHeight: 0
			animationOptions:
				time: .25
				colorModel: 'husl'

		super options

		# ---------------
		# Layers

		svgNS = "http://www.w3.org/2000/svg"
		@ctx = document.createElementNS(svgNS, 'svg')
		@svgIcon = document.createElementNS(svgNS, 'path')
		
		@ctx.appendChild(@svgIcon)
		@_element.appendChild(@ctx)

		# ---------------
		# Definitions
		
		Utils.defineValid @, "icon", options.icon, _.isString, 'Icon.icon must be a string.', @_refresh


		# ---------------
		# Events

		@on "change:color", @_refresh
		@on "change:size", @_setSize

		@color = options.color

		@_setSize()

	# ---------------
	# Private Methods


	_setSize: =>
		Utils.setAttributes @ctx,
			width: '100%'
			height: '100%'
			viewBox: "0 0 512 512"

	_refresh: ->
		return if not @color? or not @icon?

		@_setSize()

		icon = @icon
		if @icon is 'random' then @icon = _.sample(_.keys(theme.icons))

		Utils.setAttributes @svgIcon,
			d: theme.icons[icon]
			fill: @color
			transform: "scale(1, -1), translate(0, -448)"


	# ---------------
	# Public Methods

	addIcon: (name, svg) ->
		iconObj = {}
		iconObj[name] = svg
		theme.icons = _.merge(theme.icons, iconObj)
		@icon = name
