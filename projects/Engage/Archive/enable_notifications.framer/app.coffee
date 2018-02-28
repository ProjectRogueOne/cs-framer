cs = require "cs"

app = new cs.App
	type: 'ios'

view = new cs.View
	title: 'report'
	showLayers: true

THIRD_VIEW = true

view.build ->
	
	@containerBox = new Layer
		parent: @content
		width: @width
		backgroundColor: null
		y: 600
		height: view.height - app.navigation?.maxY

	@enableBox = new Layer
		parent: @containerBox
		width: @width
		height: 124
		y: 0
		backgroundColor: '#e9e9e9'
		shadowY: -1
	
	@distance = @containerBox.height - @enableBox.height
	
	do _.bind(-> # enablebox
	
	
		@label = new cs.Text
			parent: @
			text: 'We can let you know next time there is a change on your account.'
			x: 80
			y: Align.center(-16)
			width: 256
		
		@icon = new cs.Icon
			parent: @
			y: Align.center(-16)
			x: 32
			icon: 'cellphone-iphone'
			scale: 2
		
		@tips = []
		
		for i in _.range(3)
			@tips[i] = new cs.Text
				parent: @
				text: 'Extra copy!'
				type: 'body'
				textAlign: 'center'
				x: Align.center
				y: 200 + (48 * i)
				width: 180
				opacity: 1
			
		@button = new cs.Button
			parent: @
			size: 'large'
			y: Align.bottom
			x: Align.center
			height: 40
			width: @width
			borderRadius: 0
			borderWidth: 1
			fill: '#e9e9e9'
			border: 'grey'
			type: 'body1'
			text: 'Let me know!'
			
		@noThanks = new cs.Button
			parent: @
			size: 'large'
			y: Align.bottom
			x: Align.center
			height: 40
			width: @width
			borderRadius: 0
			borderWidth: 1
			fill: '#e9e9e9'
			border: 'grey'
			type: 'body1'
			text: 'No thanks.'
		
		
		@startY = @y
		@endY = view.distance
		
		@minHeight = @height
		@maxHeight = view.height - app.navigation?.maxY
		
		@label.startY = @label.y
		@label.endY = @label.y + 96
		@icon.startY = @icon.y
		@icon.endY = @icon.y + 96
		
	, @enableBox)
	
	@onMove =>
		return if not THIRD_VIEW
		
		startPosition = view.height - @containerBox.y + @enableBox.minHeight # good
		fullyOpenPosition = startPosition + @containerBox.height - @enableBox.minHeight# good
		endPosition = fullyOpenPosition + @distance # good?
		
		combinedPosition = Utils.modulate(
			@scrollY,
			[startPosition, endPosition],
			[0, 1],
			true
		)
		
		do _.bind(-> #
	
			# opening
			if combinedPosition <= .5
				@height = Utils.modulate(
					combinedPosition,
					[0, .5],
					[@minHeight, @maxHeight]
					true
				)
				
				@label.y = Utils.modulate(
					combinedPosition,
					[0, .5],
					[@label.startY, @label.endY]
					true
				)
				
				@icon.y = Utils.modulate(
					combinedPosition,
					[0, .5],
					[@icon.startY, @icon.endY]
					true
				)
				
				for tip, i in @tips
					tip.y = @label.maxY + 32 + (i * 48)
					tip.opacity = Utils.modulate(
						combinedPosition,
						[.1 + (i * .1), .4],
						[0, 1]
						true
					)
			
			# closing
			else
				@height = Utils.modulate(
					combinedPosition,
					[.5, 1],
					[@maxHeight, @minHeight]
					true
				)
				
				@y = Utils.modulate(
					combinedPosition,
					[.5, 1],
					[@startY, @endY]
					true
				)
				
				@label.y = Utils.modulate(
					combinedPosition,
					[.5, 1],
					[@label.endY, @label.startY]
					true
				)
				
				@icon.y = Utils.modulate(
					combinedPosition,
					[.5, 1],
					[@icon.endY, @icon.startY]
					true
				)
				
				for tip, i in @tips
					tip.y = @label.maxY + 32 + (i * 48)
					tip.opacity = Utils.modulate(
						combinedPosition,
						[.8 - (.1 * (i + 1)), 1 - (.1 * (i + 1))],
						[1, 0]
						true
					)
				
			@button.y = Align.bottom(1)
			@noThanks.y = @height
				
		, @enableBox)

	footer = new Layer
		parent: @content
		width: @width
		height: 64
		y: 2400
		
	
	
	