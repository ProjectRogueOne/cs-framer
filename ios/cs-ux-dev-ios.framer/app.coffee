Screen.backgroundColor = '#FFF'

USE_GROUPS = false

# To Do
# Row Options:
# 	Left Control (actions, remove, add, unchecked, checked)
# 	Two line rows
# 	Subtitles for two line rows
# 	Right Control, drag to view (action, delete)
#	Icon integration

# Helpers

{ Icon } = require 'Icon'

# Label
class Label extends TextLayer
	constructor: (options = {}) ->
		
		_.defaults options,
			fontFamily: "SF Pro Text"
			type: "body"
			color: "#000"
			
		@setType(options)
		
		super options
		
	setType: (options) ->
		
		assignProps = (fw, fs) ->
			_.assign options,
				fontWeight: fw
				fontSize: fs
		
		switch options.type
			when "body"
				assignProps(400, 17)
			when "footnote"
				assignProps(400, 13)

# Slide
class Slide extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.assign @,
			isOn: false
		
		_.assign options,
			height: 32
			width: 52
			borderRadius: 18
			
		_.defaults options,
			showLayers: false
			backgroundColor: '4cd964'
			borderWidth: 1
			borderColor: 'ddd' 
			animationOptions:
				time: .2
				colorModel: 'rgb'

		super options
		
		@knob = new Layer
			name: if options.showLayers then 'Slide Knob' else '.'
			parent: @
			x: 0
			y: 2
			height: 28
			width: 28
			borderRadius: 72
			shadowY: 3
			shadowBlur: 4
			shadowColor: 'rgba(0,0,0,.26)'
			backgroundColor: '#FFF' 
			animationOptions: @animationOptions
			
		@on "change:isOn", @_showIsOn
		@onTap => @isOn = !@isOn
		
		@_showIsOn()
	
	_showIsOn: (animate = true) =>
		if @animate
			if @isOn
				@animate { backgroundColor: '4cd964', borderWidth: 0 }
				@knob.animate { x: Align.right() }
			else 
				@animate { backgroundColor: 'FFF', borderWidth: 1 }
				@knob.animate { x: 1 }
			return
		
		if @isOn
			@backgroundColor = '4cd964'
			@borderWidth = 0
			@knob.x = Align.right()
		else 
			@backgroundColor = 'CCC'
			@borderWidth = 1
			@knob.x = 1
	
	@define 'isOn',
		get: -> return @_isOn
		set: (bool) ->
			return if bool is @_isOn
			if typeof bool isnt "boolean" then throw "Slide.isOn must be true or false."
			
			@_isOn = bool
			
			@emit "change:isOn", bool, @

# Stepper

class Stepper extends Layer
	constructor: (options = {}) ->
		
		_.assign options,
			showLayers: false
			height: 28
			width: 101
			borderWidth: 1
			borderColor: '#777'
			borderRadius: 4
			backgroundColor: '#FFF'
			animationOptions: {time: .15}
		
		_.defaults options,
			name: if options.showLayers then 'Accessory Stepper' else '.'
			value: 0
			min: 0
			max: 10
			visible: true
			color: 'rgba(1, 122, 255, 1.000)'
			
		super options
		
		@minus = new Layer
			name: 'Minus Tap Area'
			parent: @
			height: @height
			width: @width / 2
			animationOptions: @animationOptions
		
		@minusIcon = new Icon
			name: 'Minus Icon'
			parent: @minus
			point: Align.center()
			color: '#333'
			icon: 'minus'
			
		@plus = new Layer
			name: 'Plus Tap Area'
			parent: @
			x: @width / 2
			height: @height
			width: @width / 2
			animationOptions: @animationOptions
		
		@plusIcon = new Icon
			name: 'Plus Icon'
			parent: @plus
			point: Align.center
			color: '#333'
			icon: 'plus'
			
		@separator = new Layer
			name: '.'
			parent: @
			width: 1
			height: @height
			x: Align.center
			backgroundColor: @borderColor
			
		# events
			
		@minus.onTapStart =>
			return if @value is @min
			@minus.animate { backgroundColor: 'rgba(1, 122, 255, 0.300)' }
				
		@minus.onTapEnd =>
			@minus.animate { backgroundColor: 'rgba(1, 122, 255, 0.000)' }
			
			return if @value is @min
			@value--
			@emit "change:value", @value, @
		
		@plus.onTapStart =>
			return if @value is @max
			@plus.animate { backgroundColor: 'rgba(1, 122, 255, 0.300)' }
				
		@plus.onTapEnd =>
			@plus.animate { backgroundColor: 'rgba(1, 122, 255, 0.000)' }
			
			return if @value is @max
			@value++
			@emit "change:value", @value, @
		
		@on "change:value", @update
		
		@on "change:color", ->
			@activeColor = @color
			@inactiveColor = new Color(@color).alpha(.32)
			@nullColor = new Color(@color).alpha(0)
			
			@borderColor = @activeColor
			@separator.backgroundColor = @activeColor
			@minus.backgroundColor = @nullColor
			@plus.backgroundColor = @nullColor
			
			@update()
		
		_.assign @, _.pick(options, ['value', 'min', 'max', 'color'])
	
		@update()
	
	update: =>
		
		if @value is @min 
			@minusIcon.color = @inactiveColor
			@plusIcon.color = @activeColor
		
		else if @value is @max
			@minusIcon.color = @activeColor
			@plusIcon.color = @inactiveColor
		
		else
			@minusIcon.color = @activeColor
			@plusIcon.color = @activeColor

# Grabber

class Grabber extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.assign options,
			width: 53
			height: options.parent.height
			backgroundColor: null
			shadowX: -.5
			shadowColor: '#c8c8cd'
		
		super options
		
		@iconLayer = new Icon
			parent: @
			point: Align.center
			icon: 'menu'
			color: '#c8c8cd'
			
		delete @__constructor

# TableRow
class TableRow extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.defaults options,
			name: 'Table Row'
			showLayers: true
			width: Screen.width
			height: 48
			icon: Utils.randomImage()
			backgroundColor: '#FFF'
			shadowColor: '#bcbbc1'
			sortable: false
			peekable: true
			animationOptions:
				time: .3
			option:
				icon: Utils.randomImage()
				label: "Row.option.text"
				callback: -> null
			accessory:
				type: undefined
				label: undefined
				callback: -> null
		
		super options
			
		@states = 
			dragging:
				brightness: 85
				opacity: .9
				scale: 1
				
		delete @states.default.x
		delete @states.default.y
		
		# Delete
		@delete = new Layer
			name: 'Delete'
			parent: @
			maxX: @width
			width: 72
			height: @height
			backgroundColor: '#ff513f'
			visible: options.delete
		
		
		# Action
		@action = new Layer
			name: 'Delete'
			parent: @
			maxX: if options.delete then @delete.x else @width
			width: 72
			height: @height
			backgroundColor: '#8f8f94'
			visible: options.action
		
		
		# Background
		
		@backgroundLayer = new Layer
			name: 'Background'
			parent: @
			size: @size
			backgroundColor: @backgroundColor
		
		# Left Detail
		
		@leftDetail = new Layer
			parent: @backgroundLayer
			height: @height
			width: @width / 2
			backgroundColor: null
			
		do _.bind( ->
		
			@iconLayer = new Layer
				name: if options.showLayers then 'Icon Layer' else '.'
				parent: @
				height: 29
				width: 29
				x: 16
				y: Align.center()
				borderRadius: 6
				visible: options.option.icon?
				image: options.option.icon
				
			@labelLayer = new Label
				name: if options.showLayers then 'Options Label' else '.'
				parent: @
				x: 60
				y: Align.center
				visible: options.option.label?
				text: options.option.label
		
		, @leftDetail)
		
		
		# Right Detail
		
		@rightDetail = new Layer
			parent: @backgroundLayer
			height: @height
			x: @width / 2
			width: @width / 2
			backgroundColor: null
			
		do _.bind( ->
			
			@labelLayer = new Label
				name: if options.showLayers then 'Accessory Label' else '.'
				parent: @
				y: Align.center
				textAlign: 'right'
				color: '8f8e93'
				text: options.accessory.label ? ''
				visible: options.accessory.type is 'link'
			
			@iconLayer = new Icon
				name: if options.showLayers then 'Icon Layer' else '.'
				parent: @
				height: 22
				width: 22
				icon: if _.isString(options.accessory.icon) then options.accessory.icon else 'information-outline'
				color: '#007aff'
				x: if options.accessory.chevron then Align.right(-36) else Align.right(-16)
				y: Align.center()
				visible: options.accessory.icon?
			
			@chevron = new Layer
				name: if options.showLayers then 'Chevron' else '.'
				parent: @
				x: Align.right(-16)
				y: Align.center()
				backgroundColor: null
				width: 8
				height: 13
				html: "<svg width='8px' height='13px' viewBox='0 0 8 13' version='1.1'" + 
				"xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>" + 
				"<g fill='#d1d1d6'><polygon points='1.33333333 13 8 6.5 1.33333333 " + 
				"0 0 1.3 5.33333333 6.5 0 11.7'></polygon></g></svg>"
				style:
					lineHeight: '0'
				visible: options.accessory.chevron is true
			
			if options.accessory.chevron and options.accessory.icon 
				@labelLayer.maxX = @iconLayer.x - 11
			else if options.accessory.chevron
				@labelLayer.maxX = @chevron.x - 11
			else if options.accessory.icon 
				@labelLayer.maxX = @iconLayer.x - 11
			else
				@labelLayer.x = Align.right(-16)
			
			@stepper = new Stepper
				parent: @
				x: Align.right(-16)
				y: Align.center
				visible: options.accessory.type is 'stepper'
				min: options.accessory.min
				max: options.accessory.max
				value: options.accessory.value
			
			@slide = new Slide
				name: if options.showLayers then 'Slide Knob' else '.'
				parent: @
				x: Align.right(-16)
				y: Align.center
				visible: options.accessory.type is 'slide'
				isOn: options.accessory.isOn ? false
		
		, @rightDetail)
		
		
		# Grabber
		
		@grabber = new Grabber
			name: 'Grabber'
			parent: @
			x: @maxX
		
		
		delete @__constructor
		
		
		# events
		
		if options.option.callback
			@leftDetail.onTap options.option.callback
	
		if options.accessory.callback
			@rightDetail.onTap options.accessory.callback
		
		@onDragStart ->
			@bringToFront()
			@animate 'dragging'
		
		@onDrag @_resetTimer
		
		@onDrag @_getNewPosition
		
		@onDragEnd -> 
			@_takePosition( @position, true )
			@animate 'default'
			Utils.delay .2, => @emit "change:positions", @position, @
		
		@on "change:height", =>
			@position.height = @height
		
		_.assign @,
			sortable: options.sortable
			peekable: options.peekable
			actions: options.delete? or options.action?
	
	_showPeekable: =>
		if @actions
			@background.draggable.enabled = true
			@background.draggable.vertical = false
	
	# Sortable functions:
	
	# show sortable
	_showSortable: =>
		if @sortable
			@rightDetail.animate 
				maxX: @width - @grabber.width
				options:
					time: .25
					
			@grabber.animate 
				maxX: @width
				options:
					time: .25
		
			# draggable properties
			@draggable.enabled = true
			@draggable.horizontal = false
			@draggable.propagateEvents = false
	
		else
			@rightDetail.animate 
				maxX: @width
				options:
					time: .25
		
			@grabber.animate 
				x: @width
				options:
					time: .25
			
			# draggable properties
			@draggable.enabled = false
			@draggable.horizontal = false
			@draggable.propagateEvents = true
	
	# timer functions
	_setTimer: ->
		@_resetTimer()
		@_timer = Utils.interval(.1, @_tick)
		
	_resetTimer: => @_remaining = .5
	
	_clearTimer: => clearInterval(@_timer)
			
	_tick: =>
		@_remaining -= .1
		
		if @_remaining <= 0 then @_getNewPosition() 
	
	
	# get a new position based on drag location
	_getNewPosition: =>
		above = @positions[ @position.index + 1 ]
		below = @positions[ @position.index - 1 ]
		
		return if below?.midY < @midY < above?.midY

		if @midY > above?.midY
			above.layer._takePosition( @position, true )
			@_takePosition( above, false )
			
		else if @midY < below?.midY
			below.layer._takePosition( @position, true )
			@_takePosition( below, false )
	
	
	# move to new position
	_takePosition: ( position, animate = true ) ->
		@position = position
		position.layer = @
		if animate then @animate { midY: position.midY }
	
	@define "value",
		get: -> return @stepper.value
		
	@define "sortable",
		get: -> return @_sortable
		set: (bool) ->
			return if @__constructor
			
			@_sortable = bool
			@_showSortable()

	@define "peekable",
		get: -> return @_peekable
		set: (bool) ->
			return if @__constructor
			
			@_peekable = bool
			@_showPeekable()

# TableView

class TableView extends ScrollComponent
	constructor: (options = {}) ->
		
		_.assign @,
			_rows: []
			_id: _.uniqueId()
			_groups: []
			_positions: []
			_rowHeight: 0
			_sortable: undefined
		
		_.assign options,
			scrollHorizontal: false
			scrollVertical: true
			backgroundColor: '#efeff4'
		
		_.defaults options,
			width: Screen.width
			height: Screen.height
			grouped: false
			rowHeight: 48
			animationOptions:
				time: .25
		
		super options
		
		# blocker
		
		@_touchBlocker = new Layer
			parent: @
			name: 'Touch Blocker'
			width: @width - 53
			height: @height
			backgroundColor: null
			
		@_touchBlocker.onTap =>
			@sortable = false
		
		Utils.insertCSS(".divider#{@_id} {} .divider#{@_id}:after{content:'';" + 
			"right: 0; width:#{Framer.Device.context.scale * (@width * 0.84267)}px;" +
			"height:1px; background:#e7e6e9; position:absolute; bottom:0px;}" + 
			".last#{@_id} {width: 100%;" +
			"height:1px; background:#c8c7cc; position:absolute; bottom:0px;}"
			)
			
		# Events
		
		@on "change:sortable", @_setSortable
		
		_.assign @,
			grouped: options.grouped
			_rowHeight: options.rowHeight
			sortable: options.sortable
	
	# Turn on or off sortable properties
	# -
	_setSortable: ->
		if @grouped then throw "Sortable does not work with grouped TableViews."
		
		@_touchBlocker.x = if @sortable then 0 else -@width
		@_touchBlocker.draggable.enabled = @sortable
		@_touchBlocker.draggable.vertical = false
		@_touchBlocker.draggable.horizontal = false
		@_touchBlocker.draggable.propagateEvents = !@sortable
	
	# Insert Rows
	# -
	# @params
	# first (num) the index of the first row in the range
	# last (num) the index of the last row in the range
	# options (object) options for the row
	# update (bool) whether to update the table after inserting
	
	insertRows: (first, last, options = {}, update = false) ->
		
		for index in [first..last]
			_.assign options,
				parent: @content
				index: index
				name: "row #{index}"
				sortable: @sortable
				height: @rowHeight
				
			row = new TableRow options
			
			if @row(index)?.group?
				group = @row(index).group
				group.rows.push(row)
				row.group = group
				
			pos = 
				index: @positions.length, 
				layer: row, 
				midY: (@positions.length * @rowHeight) - (@rowHeight * .5)
				height: row.height
			
			_.assign row,
# 				y: @rowY(pos.index)
				position: pos
				positions: @positions
			
			@positions.push(pos)
			
			@rows.splice(index, 0, row)
			
			row.on "change:positions", =>
				@updatePositions(false)
			
			do (row) =>
				@on "change:sortable", =>
					row.sortable = @sortable
		
		if update then @updatePositions()
	
	
	# Remove Rows
	# -
	# @params
	# first (num) the index of the first row in the range
	# last (num) the index of the last row in the range
	# update (bool) whether to update the table after inserting
	removeRows: (first, last, update = false) ->
		
		for index in [first..last]
			row = @row(index)
			row.destroy()
			_.pull(@rows, row)
			
		if update then @updatePositions()
	
	
	# Move Row
	# -
	# @params
	# at (num) the index to move the row from
	# to (num) the index to move the row to
	# update (bool) whether to update the table after inserting
	moveRow: (at, to, update = false) ->
		if not at? and to?
			throw 'table.moveRow requires two index arguments - to and from.'
		
		row = @row(at)
		if not row? then throw "That row (#{at}) doesn't exist."
	
	
	# Update Positions
	# -
	# @params
	# animate (bool) whether to animate rows to their new positions
	updatePositions: (animate = true) =>
		
		above = undefined
		
		# update indexes in groups
		for group in @groups
			
			group.indexes = _.map(
				group.rows, 
				(g) -> group.rows[0].index + _.indexOf(group.rows, g)
				)
				
			@updateGroup(group)
		
		for position, i in @positions
			row = position.layer
			
			row.index = i
			
			start = if @grouped then 19 else 0
			
			# put row in its new y position
			if animate
				row.animate
					y: @rowY(i)
					options: @animationOptions
			else
				row.y = @rowY(i)
			
			# add dividers
			row.classList.remove("divider#{@_id}")
			
			unless i is @rows.length - 1
				row.classList.add("divider#{@_id}")
				row.shadowY = 0
			else
				row.shadowY = 1
			
			# make position for sortable
			pos = { index: row.index, layer: row, midY: row.midY, height: row.height }
			@positions[i] = pos
			
			row.position = pos
			row.positions = @positions
						
			# set up for next iteration
			above = row
		
		
		# update scroll
		Utils.delay 1, => @updateContent()
	
	# Add Group
	# -
	# @params
	# start (num) the index of the first row in the range
	# end (num) the index of the last row in the range
	# options (object) options for the group
	# update (bool) whether to update the table after inserting
	addGroup: (first, last, options = {}, update = false) ->
		if not @grouped then throw 'This table is not grouped.'
		
		group = {
			indexes: []
			rows: []
			header: options.header ? 'Section Heading'
			footer: options.footer ? 'This is a sample description that sits below a group.'
		}
		
		@groups.push(group)
		
		for index in [first..last]
			row = @row(index)
			if not row? then throw "That row (#{index}) doesn't exist."
			if row.group? then throw "That row (#{index}) already has a group."
			
			group.rows.push(row)
			row.group = group
			
# 		@updateGroup(group)
		
		return group
		
	# Update group
	# -
	# @params index (num) the index of the group to update
	updateGroup: (group) ->
		
		group.headerLayer?.destroy()
		group.footerLayer?.destroy()
				
		for row in group.rows
# 			print row
			row.height = @rowHeight
		
		# header
		firstRow = group.rows[0]
		firstRow.height = @rowHeight + 36
		for child in firstRow.children
			child.y = Align.center(18)
		
		group.headerLayer = new Layer
			parent: firstRow
			backgroundColor: '#efeff4'
			height: 36
			width: @width
			shadowY: 1
			shadowColor: 'c8c8cc'
		
		group.header.textLayer = new TextLayer
			parent: group.headerLayer
			fontSize: 13
			fontWeight: 400
			x: 16
			y: 14
			color: 'rgba(109, 109, 114, 1.000)'
			textTransform: 'uppercase'
			text: group.header
		
		# footer
			
		lastRow = _.last(group.rows)
		lastRow.height = @rowHeight + 36
		lastRow.shadowColor = null
		
		group.footerLayer = new Layer
			parent: lastRow
			backgroundColor: '#efeff4'
			y: Align.bottom
			height: 36
			width: @width
			shadowY: -1
			shadowColor: 'c8c8cc'
		
		group.footerLayer.textLayer = new TextLayer
			parent: group.footerLayer
			fontSize: 13
			fontWeight: 400
			x: 16
			y: 6
			color: 'rgba(109, 109, 114, 1.000)'
			text: group.footer
	
	# Load Data
	# -
	# @params data (object) the structure of data to use for the table
	loadData: (data = {}) ->
		return if not data?
		
		@name = data.name
		@grouped = data.grouped
		
		i = 0
		g = 0
		
		if @grouped
			for group in data.groups
				g = i
				for row in group.rows
					@insertRows(i, i, row)
					i++
					
				@addGroup g, i - 1,
					header: group.header
					footer: group.footer
		else
			for row, i in data.rows
				@insertRows(i, i, row)
		
		Utils.delay 0, => @updatePositions(false)

	# Group
	# -
	# @params index (num) the index of the group to return
	group: (index) ->
		return @groups[index]
	
	# Row
	# -
	# @params index (num) the index of the row to return
	row: (index) ->
		return @rows[index]
		
	# Row Y
	# -
	# @params index (num) the index of the row to return
	rowY: (index) ->
		return _.sumBy(@rows[0...index], 'height')

	# Position
	# -
	# @params index (num) the index of the position to return
	position: (index) ->
		return @positions[index]
	
	# Number of Rows
	# -
	# Returns the total number of current rows
	numberOfRows: -> return @rows.length
	
	# Scroll To Row
	# -
	# Animate (or blink) to a row at a given y offset
	scrollToRow: (animate = true, offset = .5) -> null
	
	# hiding and showing
	
	hideRows: -> null
	
	unhideRows: -> null
	
	hiddenRowIndexes: -> null
	
	# defines
	
	@define "sortable",
		get: -> return @_sortable
		set: (bool) ->
			@_sortable = bool
			@emit "change:sortable", bool, @
	
	@define "spacing",
		get: -> return null
	
	@define "rowHeight",
		get: -> return @_rowHeight
		
	@define "gridColor",
		get: -> return null
		
	@define "selectedRows",
		get: -> return null
	
	@define "rows",
		get: -> return @_rows
	
	@define "groups",
		get: -> return @_groups
		
	@define "positions",
		get: -> return @_positions



table = new TableView
	width: Screen.width

# manual adjustment

# table.insertRows(0, 4)
# # 	slide: false
# # 	)
# 
# # table.row(2).slide.isOn = true
# 
# table.addGroup(0, 2,
# 	header: 'first section'
# 	footer: 'This is the first group.'
# 	)
# 
# table.addGroup(3, 4,
# 	header: 'second section'
# 	footer: 'This is the second group.'
# 	)
# 
# table.insertRows(1, 1,
# 	slide: true
# 	)	
# 	
# table.updatePositions(false)

# Data (no groups)
tableData = {
	name: 'settings'
	grouped: false
	rows: [
		{
			option:
				icon: Utils.randomImage()
				label: 'Row label'
				callback: -> print 'left'
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
				callback: -> print 'left'
			accessory:
				type: 'link'
				label: 'See More'
				callback: -> print 'right'
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory:
				chevron: true
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory:
				type: 'link'
				chevron: true
				label: 'See more'
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory:
				icon: 'star'
		},  {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory:
				type: 'link'
				icon: true
				label: 'See more'
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory:
				chevron: true
				icon: true
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory:
				type: 'link'
				chevron: true
				icon: true
				label: 'See more'
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory: 
				type: 'slide'
				isOn: false
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory: 
				type: 'slide'
				isOn: true
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory: 
				type: 'stepper'
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory: 
				type: 'stepper'
				min: 0
				value: 1
				max: 2
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory: 
				type: 'link'
				label: 'See more'
		}, {
			option:
				icon: Utils.randomImage()
				label: 'Row label'
			accessory: 
				type: 'link'
				label: 'See more'
		}
	]
}

# Data (Groups)
tableGroupedData = {
	name: 'settings'
	grouped: true
	groups: [
		{
			header: 'First section'
			footer: 'First section footer'
			rows: [
				{
					option:
						icon: Utils.randomImage()
						label: 'Row label'
						callback: -> print 'left'
				}, {
					option:
						icon: Utils.randomImage()
						label: 'Row label'
						callback: -> print 'left'
					accessory:
						type: 'link'
						label: 'See More'
						callback: -> print 'right'
				}, {
					option:
						icon: Utils.randomImage()
						label: 'Row label'
					accessory:
						chevron: true
				}, {
					option:
						icon: Utils.randomImage()
						label: 'Row label'
					accessory:
						type: 'link'
						chevron: true
						label: 'See more'
				}
			]
		}, {
			header: 'Second section'
			footer: 'Second section footer'
			
			rows: [
				{
					option:
						icon: Utils.randomImage()
						label: 'Row label'
						callback: -> print 'left'
				}, {
					option:
						icon: Utils.randomImage()
						label: 'Row label'
						callback: -> print 'left'
					accessory:
						type: 'link'
						label: 'See More'
						callback: -> print 'right'
				}, {
					option:
						icon: Utils.randomImage()
						label: 'Row label'
					accessory:
						chevron: true
				}, {
					option:
						icon: Utils.randomImage()
						label: 'Row label'
					accessory:
						type: 'link'
						chevron: true
						label: 'See more'
				}
			]
		}
	]
}

if USE_GROUPS
	table.loadData(tableGroupedData)
else
	table.loadData(tableData)
	
test = new TextLayer
	padding: {top: 10, bottom: 10, left: 20, right: 20}
	backgroundColor: '#333'
	color: '#FFF'
	fontSize: 14
	text: 'Enable Sortable'
	y: Align.bottom()
# 
test.onTap ->
	table.sortable = true
