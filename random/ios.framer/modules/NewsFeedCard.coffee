# News Feed Card

{ database } = require 'Database'
{ colors } = require 'Colors'
{ Icon } = require 'Icon'
Helpers = require 'Helpers'
Type = require 'Type'

# Split into three options:
# New card on case
# New comment on card

class exports.NewsFeedCard extends Layer
	constructor: (options = {}) ->

		@view = options.view
		@content = options.content

		showLayers = options.showLayers ? true
		hasPhoto = @content.photo?
		hasBody = @content.body?

		database.user.view(@content?.uid)

		super _.defaults options,
			name: @content.heading ? 'News Feed Card'
			x: 16, width: Screen.width - 32
			borderRadius: 4
			backgroundColor: 'rgba(255,255,255,1)'
			shadowY: 1, shadowBlur: 3
			animationOptions: { time: .15 }
			clip: true

		content = @content

		# Header
		
		@header = new Layer
			name: if showLayers then 'Header' else '.'
			parent: @
			width: @width
			height: 32
			backgroundColor: null
			shadowY: 1
			shadowColor: colors.pale

		do _.bind( ->

			@title = new Type.Caption
				name: 'Title'
				parent: @
				y: 8
				text: content.case.name
				color: colors.med

		, @header)

		# Author
		
		@details = new Layer
			name: if showLayers then 'Details' else '.'
			parent: @
			y: @header.maxY
			width: @width
			height: 48
			backgroundColor: null

		do _.bind( ->

			@userPhoto = new Layer
				name: 'User Photo'
				parent: @
				x: 16, y: 8
				width: 32
				height: 32
				borderRadius: 16
				borderWidth: 1
				borderColor: colors.pale
				image: content.author.photo

			@author = new Type.Regular
				name: 'Author'
				parent: @
				x: 56, y: 8
				text: "#{content.author.getFullName()}
					#{content.userAction} on #{content.name}"
				color: colors.med

			@date = new Type.Caption
				name: 'Author'
				parent: @
				x: 56, y: @author.maxY + 4
				text: "#{Helpers.formatShortDate(content.date)}"
				color: colors.dim

			@height = @date.maxY + 8

		, @details)

		# Photo

		if @content.photo?
			@photo = new Layer
				name: if showLayers then 'Header' else '.'
				parent: @
				y: @details.maxY
				width: @width
				height: @width
				image: content.case.photo
				shadowY: 1
				shadowColor: colors.pale

		# comment

		if @content.comment?
			
			@comment = new Layer
				name: if showLayers then 'Body' else '.'
				parent: @
				y: @photo?.maxY ? @details.maxY
				width: @width
				height: 48
				backgroundColor: null
				shadowY: 1
				shadowColor: colors.pale

			do _.bind( ->

				@quote = new Icon
					name: 'Icon'
					parent: @
					x: 20, y: 0
					icon: 'format-quote'
					rotation: 180
					color: colors.pale

				@paragraph = new Type.Regular
					name: 'Paragraph'
					parent: @
					x: 56, y: 8, 
					width: @width - 64
					text: content.comment

				@height = @paragraph.maxY + 16

			, @comment)

		# new card

		if @content.newCard?
			
			@text = new Layer
				name: if showLayers then 'Body' else '.'
				parent: @
				y: @photo?.maxY ? @details.maxY
				width: @width
				height: 48
				backgroundColor: null
				shadowY: 1
				shadowColor: colors.pale

			do _.bind( ->

				@newHeading = new Type.H3
					name: 'New Heading'
					parent: @
					y: 16, 
					text: content.newCard.heading

				@newSubheading = new Type.H2
					name: 'New Subheading'
					parent: @
					y: @newHeading.maxY + 4, 
					text: content.newCard.subheading

				@newBody = new Type.Body
					name: 'Paragraph'
					parent: @
					y: @newSubheading.maxY + 16, 
					text: content.newCard.body

				@height = @newBody.maxY + 32

			, @text)

		# Footer

		@footer = new Layer
			name: if showLayers then 'Footer' else '.'
			parent: @
			y: @photo?.maxY ? @comment?.maxY ? @text?.maxY ? @details.maxY
			width: @width
			height: 48
			backgroundColor: null
			shadowY: 1
			shadowColor: colors.pale

		do _.bind( ->

			@commentsCount = new Type.Caption
				name: 'More Count'
				parent: @
				color: colors.bright
				x: 16
				y: Align.center
				text: "{commentCount} comment{plural}"

			@link = new Type.Link
				name: 'Title'
				parent: @
				x: Align.right(-38)
				y: Align.center
				text: 'View Case'

			@linkIcon = new Icon
				name: 'Link'
				parent: @
				x: Align.right(-8)
				y: Align.center()
				icon: 'chevron-double-right'
				color: colors.tint

		, @footer)

		@height = @footer.maxY

	refresh: ->
		@setCommentsTemplate()

	setCommentsTemplate: =>
		count = @content.card.comments.length
		
		@footer.commentsCount.template =
			commentCount: count
			plural: if count > 1 then 's' else ''

		@footer.commentsCount.visible = count > 0
