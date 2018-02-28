# View

Type = require 'Type'
{ colors } = require 'Colors'
{ Icon } = require 'Icon'
{ flow } = require 'Flow'

class exports.View extends ScrollComponent
	constructor: (options = {}) ->

		@cards = []
		
		@_startScroll = undefined
		
		# header
		@left = options.left
		@right = options.right
		@title = options.title
		
		@onLoad = options.onLoad ? -> null
		
		super _.defaults options,
			name: options.title ? 'View'
			size: Screen.size
			scrollHorizontal: false
			backgroundColor: 'rgba(247, 247, 247, 1)'
			shadowSpread: 1
			shadowColor: colors.pale 
			shadowBlur: 3
			contentInset: {top: flow.header.height + 16, bottom: 241}

		@overScroll = new Layer
			parent: @
			name: 'Overscroll Content'
			y: Align.bottom(-96)
			height: 64, width: @width
			backgroundColor: null
			opacity: 0
		
		@overscrollIcon = new Icon
			name: '.'
			parent: @overScroll
			x: Align.center
			icon: Utils.randomChoice([
				'gavel', 
				'binoculars', 
				'account-multiple', 
				'flashlight'
			])
		
		@overscrollText = new Type.Caption
			name: '.'
			parent: @overScroll
			x: Align.center
			y: @overscrollIcon.maxY + 4
			color: colors.med
			text: Utils.randomChoice([
				'Take it Slow', 
				'Stay Safe', 
				'Be Fair', 
				'The Truth is Out There'
			])
		
		@content.clip = false
		
		@content.on "change:children", (change) =>			
			for layer in change.added
				layer.on "change:height", =>
					@stackView()

			@overScroll.sendToBack()
				
		@onScrollStart => @_startScroll = @scrollPoint
		@onScroll @adjustHeader		
		@onMove _.debounce(@showOverscroll, 10)
		@onScrollEnd => flow.header.setStatus(@scrollPoint.y)
	
	adjustHeader: =>
		currentY = @scrollPoint.y
		startY = @_startScroll?.y ? @scrollPoint.y
		distance = currentY - startY
		
		switch flow.header.status
			when 'open'
				closeFactor = Utils.modulate(
					distance, 
					[96, 160], 
					[1, 0], 
					true
				)
				flow.header.setHeightByFactor(closeFactor)
			when 'closed'
				openFactor = Utils.modulate(
					distance, 
					[-96, -160], 
					[0, 1], 
					true
				)
				flow.header.setHeightByFactor(openFactor)
	
	showOverscroll: =>
		currentY = @scrollY
		max = (@content.height - @height) + 
			@contentInset.top + @contentInset.bottom
		
		if currentY > max - 160

			@overScroll.opacity = Utils.modulate(
				currentY,
				[max - 160, max - 96],
				[0, 1],
				true
				)
		else
			@overScroll.opacity = 0

	addCard: (card) ->
		card.parent = @content
		@cards.push(card)
		@stackView()
		
	stackView: =>
		for card in @cards
			index = _.indexOf(@cards, card)
			if index > 0
				card.y = @cards[index - 1].maxY + 16
		@updateContent()
		
	build: (func) -> do _.bind(func, @)

	refresh: ->
		for card in @cards
			card.refresh()
		@stackView()