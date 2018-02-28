class Link extends TextLayer
	constructor: (options = {}) ->

		_.defaults options,
			fontFamily: 'Aktiv Grotesk'
			lineHeight: 1.2
			name: 'Link'
			fontSize:  14
			fontWeight: 500
			color: bondi
			disabled: false
			select: => null

		super options

		# definitions

		Utils.define @, 'hovered', options.disabled, @_showHovered
		Utils.define @, 'disabled', options.disabled, @_showDisabled
		Utils.define @, 'select', options.select

		# events

		@on "mouseenter", => @hovered = true
		@on "mouseleave", => @hovered = false
		@onTap @_doSelect

	onSelect: (callback) => @select = callback

	_doSelect: =>
		return if @disabled

		@select()

	_showHovered: (bool) =>
		return if @disabled

		if bool
			# show hovered
			@color = glacier
			return

		# show not hovered
		@color = bondi


	_showDisabled: (bool) =>
		if bool
			# show disabled
			@color = alto
			@ignoreEvents = true
			return

		# show not disabled
		@color = bondi
		@ignoreEvents = false

exports.Link = Link