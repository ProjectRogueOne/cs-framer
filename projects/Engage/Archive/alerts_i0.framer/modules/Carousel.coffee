# Carousel
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

{ Colors } = require 'Colors'
{ Text } = require 'Text'
{ app } = require 'App'

class exports.Carousel extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		{ app } = require 'App'

		_.assign @,
			_pages: []
			_startPage: undefined
			_currentPage: undefined
			_prevPage: undefined
			_shape: undefined
			_pageProps: undefined
			_opacityScale: undefined
			_padding: undefined
			_scaleScale: undefined
			_traveling: undefined

		# _.assign options,

		_.defaults options,
			name: 'Carousel'
			x: Align.center()
			pages: []
			startPage: 2
			shape: 'line'
			animationOptions: {time: .5}
			backgroundColor: null
			opacityScale: .25
			scaleScale: .25
			padding: 0

		super options

		delete @__constructor

		@on "change:shape", @_setShape

		@on "change:currentPage", (page) -> 
			@snapToPage(page)

		@onSwipeLeftEnd -> @rotatePages('right')

		@onSwipeRightEnd -> @rotatePages('left')

		@onPan (event) ->
			if Math.abs(event.offset.x) > 32
				app?.current.disableScroll()
			else
				app?.current.enableScroll()

		@onPanEnd -> app?.current.enableScroll()

		# start

		@shape = options.shape
		@_startPage = options.startPage

		for page in options.pages
			@addPage(page)

		Utils.delay .1, =>
			if not @currentPage? and @pages[0]?
				@snapToPage(@pages[0], false)

	_rotatePageIndices: (steps = 0, animate = true) ->
		if steps > 0
			@pages.push(@pages.shift())
			@_rotatePageIndices(steps - 1, animate)
			return
		
		if steps < 0
			@pages.unshift(@pages.pop())
			@_rotatePageIndices(steps + 1, animate)
			return

		@_updateLayerPositions(animate)

	_updateLayerPositions: (animate = true) ->
		page = undefined
		carousel = @
		index = undefined
		distance = undefined
		previous = undefined
		width = _.sumBy(@pages, 'width')
		length = @pages.length
		p = Math.PI * 2

		aLength = if length % 2 is 1 then length - 1 else length

		for page, index in @pages
			page.animateStop()

			difference = index - Math.floor(length / 2)

			distance = Utils.modulate(Math.abs(difference), [0, Math.floor(length / 2)], [0, 1], true)

			angle = Utils.modulate(index, [0, aLength], [p * .75, p * -.25])

			opacity = 1 - (Math.abs(difference) * @opacityScale)

			scale = _.clamp(1 - (Math.abs(difference) * @scaleScale), 0, Infinity)

			@displayPage(page, carousel, index, difference, distance, angle, opacity, scale, animate)

			page.index = (1 - distance) * 100 + ((index % 2) * .5)

			if difference is 0 then @currentPage = page

	_setShape: ->
		switch @shape
			when 'line'
				@displayPage = (
					page, 
					carousel = @, 
					index, 
					difference,
					distance, 
					angle, 
					opacity,
					scale,
					animate = true) ->

					props = 
						opacity: opacity
						scale: scale
						midX: @width / 2 + (difference * (page.width + @padding))
						originY: @originY
						options: @animationOptions

					if animate
						page.animate props
						return

					page.props = props

			when 'circle'
				@displayPage = (
					page, 
					carousel = @, 
					index, 
					difference,
					distance, 
					angle, 
					opacity,
					scale,
					animate = true) ->

					props =
						opacity: opacity
						scale: scale
						midX: (@width / 2) + ((@width + (@padding * @pages.length) * 1.25)) * Math.cos(angle)
						originY: @originY
						options: @animationOptions

					if animate
						page.animate props
						return

					page.props = props	

	displayPage: (
		page, 
		carousel = @, 
		index, 
		difference,
		distance, 
		angle, 
		opacity,
		scale,
		previous, 
		width = _.sumBy(@pages, 'width'), 
		length = @pages.length, 
		animate = true) ->

			page.opacity = opacity
			page.scale = scale

	snapToPage: (layer, animate = true) ->
		steps = @currentIndex - @pages.indexOf(layer)
		return if steps is 0

		@_rotatePageIndices(steps, animate)

	addPage: (layer) ->
		if not layer?
			layer = 
				new Layer
					size: @size
					backgroundColor: '#AAA'

		return if _.includes(@pages, layer)

		_.assign layer,
			parent: @

		@pages.push(layer)

		@height = _.maxBy(@pages, 'height')?.height

		return layer

	removePage: (layer) ->
		return if not _.includes(@pages, layer)
		
		_.pull(@pages, layer)

	rotatePages: (direction = 'right', animate = true) ->
		switch direction
			when 'left'
				mod = -1
			when 'right'
				mod = 1
			else
				throw 'Direction must be either left or right.'

		@_rotatePageIndices(mod, animate)

	@define 'pages',
		get: -> return @_pages

	@define 'shape',
		get: -> return @_shape
		set: (string) ->
			return if @__constructor

			throw 'Shape must be either line or circle.' if not _.isString(string)
			return if string is @_shape

			@_shape = string

			@_setShape()

	@define 'opacityScale',
		get: -> return @_opacityScale
		set: (num) ->
			return if num is @_opacityScale

			@_opacityScale = num

	@define 'scaleScale',
		get: -> return @_scaleScale
		set: (num) ->
			return if num is @_scaleScale

			@_scaleScale = num

	@define 'padding',
		get: -> return @_padding
		set: (num) ->
			return if num is @_padding

			@_padding = num

	@define 'currentPage',
		get: -> return @_currentPage
		set: (page) ->
			return if @__constructor
			return if page is @_currentPage
			return if not _.includes(@pages, page)

			@_prevPage = @_currentPage
			@_currentPage = page

			@emit "change:currentPage", page, @

	@define 'currentIndex',
		get: -> return @pages.indexOf(@currentPage)