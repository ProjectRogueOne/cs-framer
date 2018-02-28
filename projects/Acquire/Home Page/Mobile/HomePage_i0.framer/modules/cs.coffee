require 'moreutils'

require 'cs-components/Colors'
require 'cs-components/Typography'

{ Header } = require 'cs-components/Header'
{ Footer } = require 'cs-components/Footer'
{ Link } = require 'cs-components/Link'
{ Card } = require 'cs-components/Card'
{ Icon } = require 'cs-components/Icon'
{ View } = require 'cs-components/View'
{ Button } = require 'cs-components/Button'
{ Carousel } = require 'cs-components/Carousel'
{ Separator } = require 'cs-components/Separator'
{ TransitionPage } = require 'cs-components/PageTransitionComponent'
{ PageTransitionComponent } = require 'cs-components/PageTransitionComponent'


class window.App extends FlowComponent
	constructor: (options = {}) ->

		_.defaults options,
			backgroundColor: '#FFF'
			title: 'www.clearscore.com'
			safari: true

		if not options.safari
			options.title = ''

		# Add general components to window
		for componentName in ['Header', 'Link', 'Icon', 'View', 'Button', 'Separator', 'Carousel', 'Card', 'TransitionPage', 'PageTransitionComponent']
			c = eval(componentName)
			do (componentName, c) =>
				window[componentName] = (options = {}) =>
					_.assign(options, {app: @})
					return new c(options)

		super options

		@fontSize = 16

		@header = new Header
			app: @
			safari: options.safari
			title: options.title
		
		if options.safari
			@footer = new Footer 
				app: @

		# when transition starts, change the header's title
		@onTransitionStart @updateNext
		
		# when transition ends, reset the previous view
		@onTransitionEnd @resetPrevious

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious
	

	# Update the next View while transitioning
	updateNext: (prev, next) =>
		if next?.onLoad?
			next.onLoad()
			
		hasPrevious = prev? and next isnt @_stack[0]?.layer

		if not @header.safari
			@header.backIcon.visible = hasPrevious
			@header.backText.visible = hasPrevious
			if next?.title 
				@header.updateTitle(next?.title)
			return

		@footer.hasPrevious = hasPrevious
	
	# Reset the previous View while transitioning
	resetPrevious: (prev, next) =>
		if prev?.reset?
			prev.reset()