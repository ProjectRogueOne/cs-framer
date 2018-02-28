# Segment Control
# Authors: Steve Ruiz
# Last Edited: 30 Oct 17

{ Container } = require 'Container'
{ Colors } = require 'Colors'
{ Text } = require 'Text'

class exports.SegmentControl extends Container
	constructor: (options = {}) ->
		@__constructor = true

		_.assign @,
			_segmentLayers: []

		_.assign options,
			name: 'Segment'
			height: 48
			clip: true

		_.defaults options,
			name: 'Segment'
			segments: [
				{text: 'Map', action: -> null}
				{text: 'Transit', action: -> null}
				{text: 'Satellite', action: -> null}
			]
			size: 'medium'
			fill: 'none'
			border: 'grey'
			color: 'black'
			selected: 0

		super options

		@_makeSegments(options.segments)

		delete @__constructor

		_.assign @,
			segments: options.segments
			selected: options.selected

	_makeSegments: (segments) ->
		for seg, i in segments
			segment = new Layer
				name: seg.text
				parent: @
				x: (@width / segments.length) * i
				width: @width / segments.length
				height: @height
				backgroundColor: null
				shadowX: @borderWidth
				shadowColor: @borderColor

			segment.labelLayer = new Text
				parent: segment
				y: Align.center()
				width: segment.width
				textAlign: 'center'
				color: @color
				text: seg.text

			do (segment, seg, i) =>
				segment.onTap =>
					@selected = i
					seg.action()

			@_segmentLayers.push(segment)

	_updateSelected: (selectedIndex) ->
		selectedSegment = @_segmentLayers[selectedIndex]

		@showSelected(selectedSegment)

		for sib in _.without(@_segmentLayers, selectedSegment)
			@showDeselected(sib)

	showSelected: (seg) ->
		_.assign seg,
			backgroundColor: @border

		_.assign seg.labelLayer,
			invert: 100
			saturate: 0

	showDeselected: (seg) ->
		_.assign seg,
			backgroundColor: null

		_.assign seg.labelLayer,
			invert: 0
			saturate: 100

	@define "selected",
		get: -> return @_selected
		set: (index) ->
			return if @__constructor
			return if index is @selected

			@_selected = index

			@_updateSelected(index)
