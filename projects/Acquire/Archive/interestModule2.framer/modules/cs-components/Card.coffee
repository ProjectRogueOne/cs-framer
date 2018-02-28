class Card extends Layer
	constructor: (options = {}) ->

		_.assign options,
			name: 'Card ' + options.image
			width: 300
			height: 425
			backgroundColor: '#FFF'
			shadowY: 4
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.15)'

		_.defaults options,
			title: 'Title'
			icon: 'shapeup'
			inactive: false
			flag: malibu
			flagText: 'recommended'

		super options

		# flag

		@flagLayer = new Layer
			name: 'Flag'
			parent: @
			y: 2
			x: Align.right(-2)
			height: 90
			width: 90
			image: 'icons/coaching/flag.svg'
			visible: options.flag?

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

		@flagTextLayer = new Body4
			name: 'Flag Text'
			parent: @flagOverlay
			rotation: 45
			x: Align.center(8)
			y: Align.center(-8)
			color: '#FFF'
			text: ''
			fontWeight: 300
			visible: options.flag?

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

		# title

		@titleLayer = new H1
			parent: @
			width: @width
			text: 'Title'
			y: @iconLayer.maxY + 25
			textAlign: 'center'

		# Body

		@bodyLayer = new Body
			parent: @
			width: @width - 40
			x: 20
			y: @titleLayer.maxY + 10
			textAlign: 'center'
			text: 'Ahhhhh'

		@primaryCTA = new Button
			parent: @
			width: @width - 40
			x: 20
			y: Align.bottom(-25)
			text: 'Start plan'



		# definitions

		Utils.define @, 'flag', options.flag, @_setFlag
		Utils.define @, 'flagText', options.flagText, @_setFlag
		Utils.define @, 'icon', options.icon, @_setIcon
		Utils.define @, 'inactive', options.inactive, @_setIcon

	_setIcon: =>
		if @inactive
			inactive = '_inactive'

		string = @icon + (inactive ? '')

		@iconLayer.image = "icons/coaching/#{ string }.svg"

	_setFlag: =>
		for layer in [@flagLayer, @flagOverlay, @flagTextLayer]
			layer.visible = @flag?

		@flagOverlay.backgroundColor = @flag

		_.assign @flagTextLayer,
			text: _.startCase(@flagText)
			x: Align.center(8)
			y: Align.center(-8)


exports.Card = Card
