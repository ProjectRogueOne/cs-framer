# App
# Authors: Steve Ruiz
# Last Edited: 9 Oct 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ SafariBar } = require 'SafariBar'
{ IOSBar } = require 'IOSBar'
{ MobileHeader } = require 'MobileHeader'
{ AndroidBar } = require 'AndroidBar'
{ Navigation } = require 'Navigation'
{ Toolbar } = require 'Toolbar'

exports.app = {}

class exports.App extends FlowComponent
	constructor: (options = {}) ->
		@__constructor = true

		exports.app = @

		@activeInput 
		@subnav
		@views = []

		@_type
		options.type ?= 'mobile'

		@_navigation
		options.navigation ?= 'default'

		@collapse = options.collapse
		@onChange = options.onChange ? (view) -> null
		
		@contentInset = options.contentInset ? {
			top: 16, bottom: 16, right: 0, left: 0
		}

		super _.defaults options,
			name: 'app'
			backgroundColor: Colors.background
			animationOptions: { time: .15 }
		

		@keyboard = new Layer
			name: 'Keyboard'
			y: @height
			width: @width
			height: @width * 450/750
			image: "modules/cs-ux-images/ios_keyboard.png"
			animationOptions: @animationOptions
				
		@keyboard.onTap @closeKeyboard

		@onTransitionStart @changeViews

		delete @__constructor

		@type = options.type
		@navigation = options.navigation
		@navigation.links = options.links
		@navigation.menuLinks = options.menuLinks

		Utils.delay 1, => @bringToFront()

	changeViews: (prev, next, direction) =>
		return if not next?

		# set content inset of app 

		topInset = if @navigation?
				@navigation.height + @header._fullHeight
			else if @header?
				@header._fullHeight ? @header.height
			else
				16

		@contentInset =
			top: topInset
			bottom: 16 + ( @footer?.height ? 0 )

		# set new view's content inset to match app's

		next.contentInset = @contentInset

		# set ios / android header buttons

		@header.setHeader
			side: 'left'
			icon: next.left?.icon
			text: next.left?.text
			action: next.left?.action
				
		@header.setHeader
			side: 'right'
			icon: next.right?.icon
			text: next.right?.text
			action: next.right?.action
		
		@header.setHeader
			title: next?.title

		# open the header

		@header.open()

		# run the new view's refresh function
		
		if next.refresh? then next.refresh()

		# run own onChange function

		@onChange(next)

		# ensure that correct subnav button is active
		if @subnav?
			navButton = _.find(@subnav.linkButtons, ['view', next])

			if navButton?.isOn is false
				navButton.isOn = true
				navButton.action()

		next.on "change:distance", (distance) =>
			if @collapse and next is @current
				@header.setFactorByDistance(distance)

		next.onScrollEnd => 
			if @collapse and next is @current
				@header.setStatus(next.scrollPoint.y)


	showNext: (next) ->
		return if @current is next

		type = next.constructor.name

		if not _.includes(['View', 'Page'], type)
			throw "App's showNext method only works with View or Page classes."

		if type is "View"
			currentIndex = _.indexOf(@views, @current)
			nextIndex = _.indexOf(@views, next)

			if nextIndex > currentIndex
				@transition(next, @showNextRight)
			else
				@transition(next, @showNextLeft)
				
		else
			@transition(next, @showNextRight)



	_buildTransition: (template, layerA, layerB, overlay) ->

		# # Buld a new transtition object with empty states
		transition = {}

		# Add the forward function for this state to transition forward
		transition.forward = (animate=true, callback) =>

			forwardEvents = (group, direction) =>
				group.once Events.AnimationHalt, => 
					@emit(Events.TransitionHalt, layerA, layerB, direction)
				group.once Events.AnimationStop, => 
					@emit(Events.TransitionStop, layerA, layerB, direction)
				group.once Events.AnimationEnd, => 
					@emit(Events.TransitionEnd, layerA, layerB, direction)

			animations = []
			options = {instant: not animate}

			if layerA and template.layerA
				layerA.visible = true
				animations.push(new Animation(layerA, template.layerA.hide, options))

			if layerB and template.layerB
				layerB.props = template.layerB.hide
				# layerB.props = template.layerB.hide if animate # This breaks events now
				layerB.bringToFront()
				layerB.visible = true
				animations.push(new Animation(layerB, template.layerB.show, options))

			if overlay and template.overlay
				overlay.visible = true
				overlay.ignoreEvents = false
				overlay.placeBehind(layerB)
				overlay.props = template.overlay.hide
				animations.push(new Animation(overlay, template.overlay.show, options))

			# Set the right layer indexes for the header and footer if they are there.
			if overlay and template.overlay
				@navigation.placeBehind(overlay) if @navigation
				@header.placeBehind(overlay) if @header
				@footer.placeBehind(overlay) if @footer
			else
				@navigation.bringToFront() if @navigation
				@header.bringToFront() if @header
				@footer.bringToFront() if @footer

			group = new AnimationGroup(animations)
			forwardEvents(group, "forward")

			group.once Events.AnimationEnd, ->
				if layerA and template.layerA and not (overlay and template.overlay)
					layerA.visible = false

			group.start()

		transition.back = (animate=true, callback) =>

			forwardEvents = (group, direction) =>
				group.once Events.AnimationHalt, => 
					@emit(Events.TransitionHalt, layerB, layerA, direction)
				group.once Events.AnimationStop, => 
					@emit(Events.TransitionStop, layerB, layerA, direction)
				group.once Events.AnimationEnd, => 
					@emit(Events.TransitionEnd, layerB, layerA, direction)

			animations = []
			options = {instant: not animate}

			if overlay and template.overlay
				overlay.visible = true
				overlay.ignoreEvents = true
				animations.push(new Animation(overlay, template.overlay.hide, options))

			if layerA and template.layerA
				layerA.visible = true
				animations.push(new Animation(layerA, template.layerA.show, options))

			if layerB and template.layerB
				layerB.visible = true
				animations.push(new Animation(layerB, template.layerB.hide, options))

			group = new AnimationGroup(animations)
			group.stopAnimations = false
			forwardEvents(group, "back")

			group.once Events.AnimationEnd, ->
				if layerB and template.layerB
					layerB.visible = false

			group.start()

		return transition


	showNextRight: (nav, layerA, layerB, overlay) ->
		options = {curve: "spring(300, 35, 0)"}

		transition =
			layerA:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: 0 - layerA?.width / 2, y: 0}
			layerB:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: layerB.width, y: 0}

	showNextLeft: (nav, layerA, layerB, overlay) ->
		options = {curve: "spring(300, 35, 0)"}

		transition =
			layerA:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: 0 + layerA?.width / 2, y: 0}
			layerB:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: -layerB.width, y: 0}

	browserBottomOverlay: (nav, layerA, layerB, overlay) =>
		layerB.height = Screen.height - @header.height
		layerB.footer?.y = Align.bottom

		options = {curve: "spring(300, 35, 0)"}

		transition =
			layerB:
				show: {
					options: {curve: "spring(300, 35, 0)"}, 
					x: Align.center, y: nav?.height - layerB?.height
				}
				hide: {
					options: {curve: "spring(300, 35, 0)"}, 
					x: Align.center, y: nav?.height
				}

	openKeyboard: () => 
		@footer.visible = false
		return if Utils.isMobile()

		@keyboard.bringToFront()
		@animate { y: -@keyboard.height }
		@keyboard.animate { y: Screen.height - @keyboard.height }
			
	closeKeyboard: => 
		@footer.visible = true
		@animate { y: 0 }
		@keyboard.animate { y: Screen.height }

	@define "type",
		get: -> return @_type
		set: (string) ->
			return if @__constructor

			if not _.includes(['mobile', 'safari', 'ios', 'android'], string) 
				throw 'Type must be either "mobile", "safari", "android" or "ios".'
			
			@footer?.destroy()
			@header?.destroy()

			switch string
				when 'mobile'  then @header = new MobileHeader
				when 'safari'  then @header = new SafariBar
				when 'ios'     then @header = new IOSBar
				when 'android' then @header = new AndroidBar

			@navigation?.y = @header.maxY

			@header.shadowY = if @navigation? then 0 else 2
			@header.shadowBlur = if @navigation? then 0 else 3

			@header.on "change:height", =>
				@_navigation?.y = @header.maxY

			Utils.delay .15, => @changeViews(null, @current)

			@emit "change:type", string

	@define "navigation",
		get: -> return @_navigation
		set: (string) ->
			return if @__constructor

			# remove current navigation

			@_navigation?.destroy()

			@header?.shadowY = 2
			@header?.shadowBlur = 3

			# bail if navigation is undefiend

			if not string?
				Utils.delay .15, => @changeViews(null, @current)
				@_navigation = undefined
				return

			# validate the the input as a navigation type

			validTypes = ['default', 'login', 'registration', 'toggle']
			if not _.includes(validTypes, string)
				throw "App's navigation can be either 'default', 'login', 'registration', undefined or 'toggle'."
				return

			# create navigation class using type

			@_navigation = new Navigation
				type: string
			
			@_navigation.props = 
				parent: @
				y: @header?.maxY ? 0
				shadowY: @header?.shadowY
				shadowColor: @header?.shadowColor
				shadowBlur: @header?.shadowBlur

			@_navigation.bringToFront()

			@header?.shadowY = 0
			@header?.shadowBlur = 0

			@subnav.on "change:selection", (view) =>
				@showNext(view)

			Utils.delay .15, => @changeViews(null, @current)

