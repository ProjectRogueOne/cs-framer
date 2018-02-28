class exports.Card extends Layer
	constructor: (options = {}) ->

		_.assign options,
			width: 300
			height: 425
			backgroundColor: 'null'
			shadowY: 4
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.15)'

		_.defaults options,
			name: 'Card'
			title: 'Title'
			body: 'Lorem ipsum dolor sit amet. Description goes here. Can go up to three lines of text.'
			icon: 'mortgages'
			inactive: false
			flag: 'recommended'
			side: 'front'
			progress: 1
			animationOptions:
				time: .7

		super options

		card = @

		# front side

		@frontSide = new Layer
			parent: @
			size: @size
			backgroundColor: white
			rotationY: 0
			backfaceVisible: false

		Utils.build @frontSide, ->

			# flag

			@flagLayer = new Layer
				name: 'Flag'
				parent: @
				y: 2
				x: Align.right(-2)
				height: 90
				width: 90
				image: 'modules/cs-components/icons/coaching/flag.svg'
				visible: options.flag?
				index: 0

			@flagOverlay = new Layer
				name: 'Flag Overlay'
				parent: @
				y: 2
				x: Align.right(-2)
				height: 90
				width: 90
				backgroundColor: null
				blending: Blending.overlay
				visible: options.flag?
				index: 1

			@flagTextLayer = new Micro
				name: 'Flag Text'
				parent: @flagOverlay
				rotation: 45
				x: Align.center(8)
				y: Align.center(-8)
				color: '#FFF'
				text: ''
				fontWeight: 300
				visible: options.flag?
				index: 2

			# icon

			@iconLayer = new Layer
				name: '.'
				parent: @
				y: 25
				x: Align.center()
				size: 150
				borderRadius: 75
				borderWidth: 1
				borderColor: '#CCC'
				backgroundColor: 'null'
				style: { lineHeight: 0 }
				index: 3

			# title

			@titleLayer = new H4
				parent: @
				width: @width
				text: 'Title'
				fontSize: 30
				fontWeight: 300
				y: @iconLayer.maxY + 25
				textAlign: 'center'
				index: 4

			# Body

			@bodyLayer = new Body
				parent: @
				width: @width - 40
				x: 20
				y: @titleLayer.maxY + 10
				textAlign: 'center'
				fontWeight: 300
				text: 'Body lorem ipsum dolor sit amet. Description goes here. Can go up to three lines of text.'

			card.frontCTA = new Button
				parent: @
				width: @width - 40
				x: 20
				y: Align.bottom(-25)
				text: 'Start plan'
				select: => card.side = 'back'


		# ------
		# reverse

		@reverseSide = new Layer
			parent: @
			size: @size
			backgroundColor: white
			backfaceVisible: false
			rotationY: 180
			visible: false

		Utils.build @reverseSide, ->

			# flag
			@flagLayer = new Layer
				name: 'Flag'
				parent: @
				y: 2
				x: Align.right(-2)
				height: 90
				width: 90
				image: 'modules/cs-components/icons/coaching/flag.svg'
				index: 0

			# flag Overlay

			@flagOverlay = new Layer
				name: 'Flag Overlay'
				parent: @
				y: 2
				x: Align.right(-2)
				height: 90
				width: 90
				backgroundColor: yellow80
				blending: Blending.overlay
				index: 1

			# flag text

			@flagTextLayer = new Body1
				name: 'Flag Text'
				parent: @flagOverlay
				rotation: 45
				x: Align.center(8)
				y: Align.center(-8)
				color: white
				text: 'Active'
				fontWeight: 300
				index: 2

			# icon

			@iconLayer = new Layer
				name: '.'
				parent: @
				y: 25
				x: 25
				size: 50
				borderRadius: 25
				borderWidth: 1
				borderColor: grey30
				backgroundColor: 'null'
				style: { lineHeight: 0 }
				index: 3

			# title

			@titleLayer = new H4
				parent: @
				width: @width
				text: 'Title'
				x: @iconLayer.maxX + 20
				y: 38
				fontWeight: 300
				fontSize: 30
				textAlign: 'left'
				index: 4

			# progress links

			card.progressLinks = _.range(3).map (i) =>
				return new ProgressLink
					parent: @
					name: 'Progress Link'
					y: 112 + ((36 + 29) * i)
					x: 36
					width: @width - (36 * 2)
					index: 999
					text: 'Progress link #' + (i + 1)

			# cta

			card.backCTA = new Button
				parent: @
				width: @width - 40
				x: 20
				y: Align.bottom(-62)
				text: 'Continue plan'

			# links

			card.stopPlanLink = new LabelLink
				parent: @
				x: 20
				y: Align.bottom(-15)
				text: 'Stop Plan'
				select: => card.side = 'front'
				color: grey80

			card.restartPlanLink = new LabelLink
				parent: @
				x: Align.right(-20)
				y: Align.bottom(-15)
				text: 'Restart Plan'
				select: => card.progress = 0
				color: grey80

		for child in @children
			if !options.showNames
				child.name = '.'


		# definitions

		Utils.define @, 'title', options.title, @_setTitle
		Utils.define @, 'body', options.body, @_setBody
		Utils.define @, 'icon', options.icon, @_setIcon
		Utils.define @, 'inactive', options.inactive, @_setIcon
		Utils.define @, 'progress', options.progress, @_setProgress
		Utils.define @, 'flagColor', options.flagColor, @_setFlagColor
		Utils.define @, 'flagText', options.flagText, @_setFlagText
		Utils.define @, 'flag', options.flag, @_setFlag
		Utils.define @, 'side', options.side, @_setSide

		# events

		@on "change:rotationY", (rotation) ->
			@frontSide.visible = rotation < 90
			@reverseSide.visible = rotation > 90

	_setTitle: (text) =>
		@frontSide.titleLayer.text = text
		@reverseSide.titleLayer.text = text

	_setBody: (text) =>
		@frontSide.bodyLayer.text = text

	_setIcon: =>
		if @inactive
			inactive = '_inactive'

		string = @icon + (inactive ? '')

		if @side is 'offers'
			@frontSide.iconLayer.borderWidth = 0
			@frontSide.iconLayer.image = "modules/cs-components/icons/offers/#{ string }.svg"
			@reverseSide.iconLayer.image = "modules/cs-components/icons/offers/#{ string }.svg"
			@frontCTA.textLayer.text = "Find offers"
			@frontCTA.select = => null
			return

		@frontSide.iconLayer.borderWidth = 1
		@frontSide.iconLayer.image = "modules/cs-components/icons/coaching/#{ string }.svg"
		@reverseSide.iconLayer.image = "modules/cs-components/icons/coaching/#{ string }.svg"
		@frontCTA.textLayer.text = "Start plan"
		@frontCTA.select = => @side = 'back'

	_setFlag: (flagName) =>
		switch @flag
			when "recommended"
				@flagText = "Recommended"
				@flagColor = blue
			when "active"
				@flagText = "Active"
				@flagColor = green
			when "comingsoon"
				@flagText = "Coming Soon"
				@flagColor = yellow60
			else
				@flagText = null
				@flagColor = null

		for layer in [@frontSide.flagLayer, @frontSide.flagOverlay, @frontSide.flagTextLayer]
			layer.visible = flagName?

	_setFlagColor: (color) =>
		@frontSide.flagOverlay.backgroundColor = color

	_setFlagText: (text) =>
		_.assign @frontSide.flagTextLayer,
			text: _.startCase(text)
			x: Align.center(8)
			y: Align.center(-8)


	_setSide: (sideName) =>
		switch sideName

			when "front"
				@_imageFolder = "coaching"
				@animate
					rotationY: 0

			when "back"
				@_imageFolder = "coaching"
				@animate
					rotationY: 180

			when "offers"
				@flag = null
				@animate
					rotationY: 0

		@_setIcon()

	_setProgress: (step) =>
		if 0 > step > @progressLinks.length
			throw 'Card: That step is too high or too low!'

		for link, i in @progressLinks
			link.side = 
				if i < step then 'done'
				else if i is step then 'todo'
				else 'unavailable'

	flip: =>
		@side = if @side is "front" then "back" else "front"



# Only used in the Card class

class ProgressLink extends Layer
	constructor: (options = {}) ->
		
		_.assign options,
			height: 38
			backgroundColor: null

		_.defaults options,
			side: 'unavailable'
			text: 'Progress link #1'

		super options

		@iconLayer = new Layer
			parent: @
			height: @height
			width: @height
			borderRadius: @height / 2
			backgroundColor: white

		@linkLayer = new Body1Link
			parent: @
			y: Align.center()
			x: @iconLayer.maxX + 15
			text: options.text

		@indicator = new Layer
			parent: @
			name: 'Progress Indicator'
			y: @height
			x: 18
			height: 0
			width: 2
			backgroundColor: grey


		Utils.define @, 'side', options.side, @_setSide

	_setSide: (side) =>
		@iconLayer.image = "modules/cs-components/icons/coaching/#{ side }.svg"

		if side is 'done'
			@indicator.height = 28
		else
			@indicator.height = 0

		if side is 'unavailable'
			@linkLayer.disabled = true
			@iconLayer.opacity = .5
			return


		@linkLayer.disabled = false
		@iconLayer.opacity = 1
