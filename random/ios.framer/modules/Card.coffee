# Card

Type = require 'Type'
{ colors } = require 'Colors'
{ database } = require 'Database'
{ HeaderContent } = require 'HeaderContent'
{ PhotoContent } = require 'PhotoContent'
{ BodyContent }	= require 'BodyContent'
{ CommentsBox }	= require 'CommentsBox'

class exports.Card extends Layer
	constructor: (options = {}) ->
		
		@view = options.view
		@content = options.content

		showLayers = options.showLayers ? false
		hasPhoto = @content.photo?
		hasBody = @content.body?

		database.user.view(@content?.uid)
		
		super _.defaults options,
			name: @content.heading ? 'Untitled Card'
			x: 16, width: Screen.width - 32
			borderRadius: 4
			backgroundColor: 'rgba(255,255,255,1)'
			shadowY: 1, shadowBlur: 3
			animationOptions: { time: .15 }
			clip: true

		# header
		
		@headerContent = new HeaderContent
			name: if showLayers then 'Header Content' else '.'
			parent: @
		
		# photo
		
		if hasPhoto
			@photoContent = new PhotoContent
				name: if showLayers then 'Photo Content' else '.'
				parent: @
				y: @headerContent.maxY
				content: @content
		
		# body
		
		if hasBody
			@bodyContent = new BodyContent
				name: if showLayers then 'Body Content' else '.'
				parent: @
				y: @photoContent?.maxY ? @headerContent.maxY
				content: @content
		
		# comments
		
		@commentsBox = new CommentsBox
			name: if @showLayers then 'Comments Box' else '.'
			parent: @
			y: @bodyContent.maxY
		
		@height = @commentsBox.maxY
		
		@commentsBox.on "change:height", @setHeightToComments
		@commentsBox.input.on "change:focused", (isFocused) =>
			if isFocused
				if Utils.isMobile()

					@view.scrollToPoint(
						x: 0, y: @maxY - Screen.height + 112
						true
					)

				else
					@view.scrollToPoint(
						x: 0, y: @maxY - Screen.height + 96
						true
					)


		@on "change:height", @updateParentContent

	setHeightToComments: (height) =>
		@height = @bodyContent.maxY + height

		@view.scrollY = @maxY - Screen.height + 144
	
	updateParentContent: ->
		if @parent.name is 'content' then @parent.parent.updateContent()
		
	refresh: ->
		@headerContent?.refresh()
		@photoContent?.refresh()
		@bodyContent?.refresh()
		@commentsBox?.refresh()
