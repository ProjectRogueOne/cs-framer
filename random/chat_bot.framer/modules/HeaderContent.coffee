# HeaderContent

Type = require 'Type'
Helpers = require 'Helpers'
{ database } = require 'Database'
{ colors } = require 'Colors'
{ Icon } = require 'Icon'
{ ActionSheet } = require 'ActionSheet'

class exports.HeaderContent extends Layer
	constructor: (options = {}) ->
		
		@content = options.parent.content
		
		super _.defaults options,
			name: 'Header'
			width: options.parent.width
			backgroundColor: null
			shadowY: 1
			shadowColor: colors.pale
		
		@title = new Type.H1
			name: 'Heading'
			parent: @
			y: 16
			width: @width - 16
			text: "{heading}"
	
		@subheading = new Type.H2
			name: 'Subheading'
			parent: @
			y: @title.maxY
			width: @width - 16
			text: "{subheading}"
			
		@caption = new Type.Caption
			name: 'Caption'
			parent: @, 
			y: @subheading.maxY + 8
			text: "{caption}"
		
		@menuButton = new Icon
			name: 'Menu Button'
			icon: 'dots-vertical'
			color: '#000'
			parent: @
			x: Align.right(-8), y: 16
		
		@menuButton.onTap => new ActionSheet
			actions: [
				{ 
					text: 'Flag as Inappropriate', 
					action: => @content.flagged = true 
				}, { 
					text: 'Save to My Pinned', 
					action: -> database.user.pinned.push(@content) 
				}, { 
					text: 'Turn on Notifications', 
					action: -> database.user.subscribed.push(@content) 
				}
			]

		@refresh()
		
	refresh: ->
		@title.template = @content.heading
		@subheading.template = @content.subheading
		@caption.template = "Last Updated:" + 
			"#{Helpers.formatDateTime(@content.lastEdited)} by " +
			"#{@content.author.getFullName()}"
		@title.template = @content.heading
		@height = @caption.maxY + 16