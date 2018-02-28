# Photo Content

Type = require 'Type'
Helpers = require 'Helpers'
{ Icon } = require 'Icon'
{ colors } = require 'Colors'

class exports.PhotoContent extends Layer
	constructor: (options = {}) ->
		
		@content = options.content
		
		super _.defaults options,
			name: 'Photo Content'
			backgroundColor: null
			width: options.parent?.width
			height: options.parent?.width
			shadowY: -1
			shadowColor: colors.pale
		
		@photo = new Layer
			name: 'Photo'
			parent: @
			width: @width
			height: @width
			image: @content.photo.image
			shadowY: 1
			shadowColor: colors.pale
	
		@photo.onTap @zoomImage
		
		@caption = new Type.Caption
			name: 'Caption'
			parent: @
			x: 0, y: @photo.maxY + 16
			width: @width
			color: colors.bright
			textAlign: 'center'
			text: "{caption}"
		
		@captionDetail = new Type.Caption
			name: 'Caption Detail'
			parent: @
			x: 0, y: @caption.maxY + 4
			width: @width
			color: colors.med
			textAlign: 'center'
			text: "{captionDetail}"
		
		@height = @captionDetail.maxY + 4
		@refresh()
		
	zoomImage: =>
		@fullScreen = new Layer
			name: 'Fullscreen View'
			frame: @photo.screenFrame
			image: @photo.image
			opacity: 0
			
		@closeButton = new Icon
			name: 'Close'
			icon: 'close'
			x: Align.right(-8)
			y: 8
			invert: 100
			color: colors.bright
		
		@fullScreenText = new Layer
			opacity: 0
			width: Screen.width
			height: 64
			backgroundColor: 'rgba(0, 0, 0, .2)'
			y: Screen.height - 72
			animationOptions: { time: .15 }
		
		content = @content
		
		do _.bind( ->
			
			@caption = new Type.H3
				name: 'Caption'
				parent: @
				y: 8
				width: Screen.width
				color: colors.bright
				textAlign: 'center'
				invert: 100
				text: content.photo.caption
			
			@detail = new Type.Caption
				name: 'Detail'
				parent: @
				x: 0, y: @caption.maxY
				width: Screen.width
				color: colors.bright
				invert: 100
				textAlign: 'center'
				text: "#{content.photo.author.getFullName()} on " +
					"#{Helpers.formatShortDate(content.photo.date)}"
		
		, @fullScreenText )
		
		@fullScreen.onTap @close
		
		@open()
		
		
	
	open: =>
		@fullScreen.animate
			frame: Screen.frame
			opacity: 1
			options: { time: .25 }
		
		@fullScreenText.animate
			opacity: 1
			y: Screen.height - 72
			options: { time: .1, delay: .15 }
		
		@closeButton.animate
			opacity: 1
			options: { time: .1, delay: .15 }
	
	close: =>
		photo = @fullScreen
		text = @fullScreenText
		closeButton = @closeButton
		
		Utils.delay .2, => 
			photo.destroy()
			text.destroy()
			closeButton.destroy()
			
		text.animate { opacity: 0 }
		closeButton.animate { opacity: 0 } 
		photo.animate
			frame: @photo.screenFrame
			opacity: 0
			options: { time: .15 }
	
	refresh: ->
		@photo.image = @content.photo.image
		@caption.template = "#{@content.photo.caption}"
		@captionDetail.template = "#{@content.photo.author.getFullName()} on " +
			"#{Helpers.formatShortDate(@content.photo.date)}"