# Segment Control
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

{ Container } = require 'Container'
{ Colors } = require 'Colors'
{ Text } = require 'Text'

class exports.SegmentControl extends Container
	constructor: (options = {}) ->
		@__constructor = true

		_.assign @,
			selected: undefined
			segments: []
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
			x: Align.center()
			size: 'medium'
			fill: 'none'
			border: 'grey'
			color: 'black'

		super options

		@_makeSegments(options.segments)

		delete @__constructor

		@selected = options.selected ? options.segments[0]

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
					@selected = seg
					seg.action()

			@_segmentLayers.push(segment)
			@segments.push(seg)

	_updateSelected: (selectedSegment) ->
		index = @segments.indexOf(selectedSegment)
		segmentLayer = @_segmentLayers[index]

		@showSelected(segmentLayer)

		for sib in _.without(@_segmentLayers, segmentLayer)
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
		set: (segment) ->
			return if @__constructor
			return if segment is @selected

			@_selected = segment

			@_updateSelected(segment)

			@emit "change:selected", segment, @
