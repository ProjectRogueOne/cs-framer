# Action Sheet
# Authors: Steve Ruiz
# Last Edited: 25 Sep 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ Divider } = require 'Divider'

class exports.ActionSheet extends Layer
	constructor: (options = {}) ->
		
		@_actions = options.actions ? []
				
		super _.defaults options,
			width: Screen.width
			height: Screen.height + 320
			backgroundColor: 'rgba(0,0,0,.65)'
			opacity: 0
			animationOptions: { time: .45 }
		
		@onTap (event) -> event.stopPropagation()
		
		# Cancel
		
		@cancel = new Layer
			parent: @
			x: 8, y: Align.bottom(-8)
			width: Screen.width - 16
			height: 48
			borderRadius: 8
			backgroundColor: 'rgba(244, 244, 244, 1)'
		
		@cancelLabel = new TextLayer
			parent: @cancel
			y: Align.center
			width: @cancel.width
			fontSize: 16
			fontWeight: 600
			color: Colors.tint
			textAlign: 'center'
			text: 'Cancel'
			
		@cancel.onTap (event) =>
			event.stopPropagation
			@close()
			
		# Actions
		
		@actionContainer = new Layer
			name: 'Action Container'
			x: 8, y: Align.bottom(-64)
			width: Screen.width - 16
			borderRadius: 8
			parent: @
			backgroundColor: 'rgba(244, 244, 244, 1)'
			height: 48 * @_actions.length
			clip: true
			
		for action, i in @_actions
			
			actionBox = new Layer
				parent: @actionContainer
				y: 48 * i
				width: @actionContainer.width
				height: 48
				backgroundColor: null
			
			actionLabel = new TextLayer
				parent: actionBox
				y: Align.center
				width: @cancel.width
				fontSize: 16
				fontWeight: 600
				color: Colors.tint
				textAlign: 'center'
				text: action.text
		
			actionBox.onTap action.action
			actionBox.onTap @close
		
			if i > 0
				divider = new Divider
					parent: actionBox
					y: 0
					opacity: .4
					width: @actionContainer.width
					
			# on load
			
			@animate { y: -320 }
			@animate { opacity: 1, options: { time: .35 } }

	close: =>
		actionSheet = @
		@animate { y: 0 }
		@animate { opacity: 0, options: { time: .35 } }
		
		Utils.delay .25, -> actionSheet.destroy()