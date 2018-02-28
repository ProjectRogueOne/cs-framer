# App
# Authors: Steve Ruiz
# Last Edited: 1 Nov 17

Type = require 'Mobile'
{ Colors } = require 'Colors'
{ SafariBar } = require 'SafariBar'
{ IOSBar } = require 'IOSBar'
{ MobileHeader } = require 'MobileHeader'
{ AndroidBar } = require 'AndroidBar'
{ Navigation } = require 'Navigation'
{ Toolbar } = require 'Toolbar'
{ View } = require 'View'

exports.app = {empty: true}

class exports.App extends FlowComponent
	constructor: (options = {}) ->
		@__constructor = true

		exports.app = @

		@_type
		@_navigation
		@_subnav

		@views = []

		_.defaults options,
			name: 'app'
			type: 'mobile'
			backgroundColor: Colors.background
			animationOptions: { time: .15 }
			onChange: (view) -> null
			collapse: false
			navigation: undefined
			contentInset: {top: 16, bottom: 16, right: 0, left: 0}

		super options

		@keyboard = new Layer
			name: 'Keyboard'
			y: @height
			width: @width
			height: @width * 450/750
			image: "modules/cs-ux-images/ios_keyboard.png"
			animationOptions: @animationOptions
		
		# events

		

		@keyboard.onTap @closeKeyboard

		@onTransitionStart @changeViews

		@onTransitionStart (prev, next) =>
			next.onLoad()

		delete @__constructor

		# kickoff

		_.assign @,
			collapse: options.collapse
			onChange: options.onChange
			type: options.type
			navigation: options.navigation

		if @navigation?
			_.assign @navigation,
				links: options.links
				menuLinks: options.menuLinks

		Utils.delay 1, => @bringToFront()


	changeViews: (prev, next, direction) =>
		return if next is @current
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

		@header.setHeader(next.title, next.left, next.right)
		@navigation?.title = next.title

		# open the header

		@_setListeners(next)

		# run own onChange function

		@onChange(next)

		# ensure that correct subnav button is active
		if @navigation?.subnav?
			navButton = _.find(@navigation.subnav.buttons, ['view', next])

			return if not navButton?
			
			@navigation.subnav.selected = navButton
			@navigation.subnav.selected.isOn = true


	_setListeners: (view) ->
		view.removeAllListeners()

		view.onScrollStart -> 
			view._startScroll = view.scrollPoint
			view._startTime = _.now()

		view.onMove view._emitDistance

		view.on "change:distance", (distance, direction, scrollY) =>
			return if not @collapse
			return if view isnt @current
			return if direction is 'down' and scrollY > @header._fullHeight

			@header.setFactorByDistance(distance, direction, scrollY)

		view.onScrollEnd (event) =>
			duration = _.now() - view._startTime

			if event.offsetDirection is 'down' and view.scrollY > @header._fullHeight and 50 < duration < 400
				@header.open()

		view.onScrollAnimationDidEnd (event) =>
			return if not @collapse
			return if view isnt @current

			@header.setStatus(view.scrollY)

	showNext: (next) ->
		return if not next
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
			return
				
		@transition(next, @showNextRight)


	_buildTransition: (template, layerA, layerB, overlay) ->

		# Buld a new transtition object with empty states
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

	overlayBottom: (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(350, 35, 0)"}

		transition =
			layerB:
				show: {options: options, x: Align.center, y: nav?.height - layerB?.height}
				hide: {options: options, x: Align.center, y: nav?.height}

	showOverlayBottom: (layer, options={}) ->
		@_showOverlay(layer, @overlayBottom, options)

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

	# return a view through app.View
	View: (options = {}) => 
		view = new View(options)
		return view

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

			@header?.shadowY = 2
			@header?.shadowBlur = 3

			# remove the navigation if fed undefined and there is a navigation
			if not string? and @_navigation?
				@_navigation.destroy()
				Utils.delay .15, => @changeViews(null, @current)
				@_navigation = undefined
				return

			# bail if fed undefined and no navigation
			if not string?
				return

			# if there is a string...

			# vertify that it's a valid navigation type
			validTypes = ['default', 'login', 'registration', 'page', 'toggle']
			
			if not _.includes(validTypes, string)
				throw "App's navigation can be either 'default', 'login', 'registration', 'page', or 'toggle'."
				return

			# if there is a navigation, set the nav's type with the string
			if @_navigation?
				@_navigation.type = string
				return

			# otherwise, create navigation class using type

			@_navigation = new Navigation
				type: string
			
			@_navigation.props = 
				parent: @
				y: @header?.maxY ? 0
				shadowY: @header?.shadowY
				shadowColor: @header?.shadowColor
				shadowBlur: @header?.shadowBlur

			@_navigation.bringToFront()

			unless @header?.constructor.name is "SafariBar"
				@header?.shadowY = 0
				@header?.shadowBlur = 0

			@_navigation.subnav.on "change:selection", (view) =>
				@showNext(view)

			Utils.delay .15, => 
				@showNext(@current)

