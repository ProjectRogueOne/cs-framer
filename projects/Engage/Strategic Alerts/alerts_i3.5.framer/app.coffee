require 'cs-ux'
require 'gotcha'

# Setup

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

SHOW_DATE_LABEL = true
SHOW_SEPARATOR = false
SHOW_COUNT_ON_DOTS = false
STARTING_ALERTS_COUNT = 2

# -----
# data

# Alert
class Alert
	constructor: (options = {}) ->
	
		_.assign @,
			seen: options.seen ? false
			date: options.date ? new Date()
			type: options.type ? 'changed'
			month: options.month ? 0
			content: options.content ? 'Your membership in the Party has been revoked since last check.'
			meaning: options.meaning ? "Your credit score is based in part on your Party membership. It should go without saying that losing the faith of your comrades has consequences. We don't know what you did, or who you crossed, but brother, you're in for it now."
			cta1: options.cta1 ? "This doesn't look right."
			cta2: options.cta2 ? "Why is this not part of my Report?"
			thisMonth: options.thisMonth ? false
			score: _.random(350, 400)

# Alerts Data

contents = [
	"A County Court Judgement  (CCJ) has been added since last check"
	"An account has been added to your Report since last check"
	"Key attribute(s) will be updated for a CIFAS"
	]
	
lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam quis mattis mauris, in lacinia nunc. Aenean enim urna, elementum nec turpis quis, congue cursus diam. Vestibulum at faucibus tortor. Nullam accumsan sodales placerat."

today = new Date()
dayLength = 1000*60*60*24

lastDate = today

# when was this last checked?
lastChecked = new Date(today.getTime() - 45 * dayLength)

# the numbers in this array are how many days ago this change occurred
dates = _.map([0, 90, 180, 180, 240, 240, 240, 240, 240], (d) ->
	return new Date(today.getTime() - d * dayLength)
	)
	
alerts = _.map dates, (date) ->
	
	alert = new Alert
		seen: date < lastChecked
		date: date
		month: date.getMonth() % 12
		thisMonth: date.getMonth() is today.getMonth()
		content: _.sample(contents)
		meaning: lorem
		cta1: "This doesn't look right."
		cta2: "Why is this not part of my Report?"
		type: 'changed'
	
	return alert

nextMonth = today.getMonth() + 1
futureDate = new Date(today.getTime() + 31 * dayLength)

for i in _.range(2)
	alerts.push new Alert
		seen: false
		date: futureDate
		month: futureDate.getMonth() % 12
		thisMonth: false
		content: "A HSBC credit card will be added to your account."
		meaning: lorem
		cta1: "This doesn't look right."
		cta2: "Why is this not part of my Report?"
		type: 'upcoming'

alerts = _.sortBy(alerts, 'date')

years = {}

for alert in alerts
	y = alert.date.getYear()
	m = alert.date.getMonth()
	
	# if its a new year, create a year with 12 blank arrays
	years[y] ?= _.range(12).map (y) -> {
		alerts: []
		timelineButton: undefined
		future: y > alert.date.getMonth() <= new Date().getMonth()
	}
	
	# add this alert to the right year's array
	years[y][m].alerts.push(alert)

lastDate = _.last(alerts).date
firstDate = alerts[0].date


# ----------------
# components

# Detail View

class DetailView
	constructor: (options = {}) ->
		
		_.defaults options,
			alert: alerts[_.random(10)]
		
		@view = new View
			backgroundColor: bg1
			contentInset:
				top: 32
		
		# header
		Utils.bind @view, ->
		
			@alert = options.alert ? {
				
			}
			
			@getTitle = =>
			
				if not @alert 
					return 'Expecting a Change?'
				
				if @alert.type is 'changed'
					return 'Upcoming Change'
					
				if @alert.type is 'upcoming'
					return 'Upcoming Change'
		
			@alert = options.alert
			
			@header = new Layer
				parent: @
				width: @width
				y: app.header.maxY
				height: 56
				backgroundColor: '#e5e5e5'
			
			@back = new Icon
				parent: @header
				icon: 'chevron-left'
				x: 8
				y: Align.center()
				
			@backText = new Body 
				parent: @header 
				text: 'Overview'
				x: @back.maxX
				y: Align.center()
				color: '#000'
				
			@header.onTap => 
				app.showPrevious()
				Utils.delay 1, => @destroy()
			
			# content 
			
			title = new H4
				parent: @content
				x: 32
				y: 80
				text: @getTitle()
				
			date = new Body 
				parent: @content 
				x: Align.right(-32)
				y: title.y + 4
				text: @alert?.date.toLocaleDateString() ? ''
				color: '#AAA'
			
			content = new Body
				parent: @content
				x: 32
				y: title.maxY + 32
				text: @alert?.content ? 'Your membership in the Party has been revoked since last check.'
				width: @width - 64
				
			title2 = new H4 
				parent: @content
				x: 32
				y: content.maxY + 64
				textDecoration: 'underline'
				text: 'What does this mean?'
			
			meaning = new Body
				parent: @content
				x: 32
				y: title2.maxY + 32
				text: @alert?.meaning ? "Your credit score is based in part on your Party membership. It should go without saying that losing the faith of your comrades has consequences. We don't know what you did, or who you crossed, but brother, you're in for it now."
				width: @width - 64
			
		return @view
			

# Upcoming Detail View

class UpcomingDetailView
	constructor: (options = {}) ->
		
		_.defaults options,
			alert: alerts[_.random(10)]
		
		@view = new View
			backgroundColor: bg1
			contentInset:
				top: 32
		
		# header
		Utils.bind @view, ->
		
			@alert = options.alert ? {
				
			}
			
			@getTitle = => return "Upcoming Score"
		
			@alert = options.alert
			
			@header = new Layer
				parent: @
				width: @width
				y: app.header.maxY
				height: 56
				backgroundColor: '#e5e5e5'
			
			@back = new Icon
				parent: @header
				icon: 'chevron-left'
				x: 8
				y: Align.center()
				
			@backText = new Body 
				parent: @header 
				text: 'Overview'
				x: @back.maxX
				y: Align.center()
				color: '#000'
				
			@header.onTap => 
				app.showPrevious()
				Utils.delay 1, => @destroy()
			
			# content 
			
			title = new Body
				parent: @content
				x: 32
				y: 80
				text: @getTitle()
				color: grey
			
			content = new Body
				parent: @content
				x: 32
				y: title.maxY + 32
				text: "What is your upcoming score?"
				width: @width - 64
				
			title2 = new H4 
				parent: @content
				x: 32
				y: content.maxY + 48
				textDecoration: 'underline'
				text: 'What does this mean?'
			
			meaning = new Body
				parent: @content
				x: 32
				y: title2.maxY + 16
				text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam quis mattis mauris, in lacinia nunc."
				width: @width - 64
				
			title = new H4 
				parent: @content
				x: 32
				y: meaning.maxY + 48
				textDecoration: 'underline'
				text: 'How this is worked out?'
			
			meaning = new Body
				parent: @content
				x: 32
				y: title.maxY + 16
				text: "Things such as a credit card may show as as new on your report even if it isn’t as the lender may have decided to reveal this information to us now."
				width: @width - 64
				
			title = new H4 
				parent: @content
				x: 32
				y: meaning.maxY + 48
				textDecoration: 'underline'
				text: 'Will it change?'
			
			meaning = new Body
				parent: @content
				x: 32
				y: title.maxY + 16
				text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam quis mattis mauris, in lacinia nunc."
				width: @width - 64
				
		return @view
			

# Timeline Button Container

class TimelineButtonContainer extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Timeline Button Container'
			backgroundColor: null
			x: 0
			width: 112
			animationOptions:
				time: .25
				
			minScore: 100
			maxScore: 600
			score: 400
# 			alertsCount: 2
			monthObject: {}
			dateString: 'OCT'
			lastY: 0
			lastX: 0
			date: new Date()
		
		super options
		
		
		_.assign @,
			future: options.future
			score: options.score
			minScore: options.minScore
			maxScore: options.maxScore
			lastX: options.lastX
			lastY: options.lastY
			alertsCount: options.alertsCount
			monthObject: options.monthObject
			dateString: options.dateString
			date: options.date
		
		if @date > today
			@score = 420
			
		@button = new Layer
			name: 'Button'
			parent: @
			x: Align.center()
			y: Utils.modulate(
				@score, 
				[@maxScore, @minScore]
				[24,  @height +
				(if SHOW_DATE_LABEL then -60 else -36)]
				true
				)
			height: 32
			width: 32
			borderRadius: 16
			borderWidth: 1
			borderColor: '#000'
			backgroundColor: grey40
			
		@buttonCircle = new Layer
			parent: @button
			size: 24
			x: Align.center(1)
			y: Align.center(1)
			borderRadius: 16
			borderWidth: 1
			borderColor: '#000'
			backgroundColor: grey40
			animationOptions:
				time: .25
		
		# alerts count label
		
		if @alertsCount? and SHOW_COUNT_ON_DOTS
			alertsCountLabel = new Body 
				name: 'Score'
				type: 'body1'
				parent: @button
				point: Align.center()
				width: @button.width
				textAlign: 'center'
				text: @alertsCount
				color: '#333'
		
		# score label
		
		scoreLabel = new Label 
			name: 'Score'
			parent: @
			width: 200
			midX: @button.midX
			y: -32
			textAlign: 'center'
			text: @score
		
		scoreLabel.maxY = @button.y - 4
		
		
		# upcoming label
		
		if @date > today
			upcomingLabel = new Layer
				parent: @
				width: @width
				y: @button.maxY + 16
				height: 32
				borderRadius: 4
				backgroundColor: grey40
				
			shape = new Layer
				parent: upcomingLabel
				size: 12
				x: Align.center()
				y: -4
				rotation: 45
				backgroundColor: grey40
				rotationY: 45
				
			new Body3
				parent: upcomingLabel
				point: Align.center()
				text: 'Upcoming Score'
				color: black
				
			upcomingLabel.onTap =>
				app.showNext(new UpcomingDetailView)
		
			return
		
		# date label
		
		if SHOW_DATE_LABEL
			@dateLabel = new Label 
				name: 'Date'
				parent: @
				width: 200
				midX: @button.midX
				y: @button.height + 32
				textAlign: 'center'
				text: @dateString
			
			@dateLabel.y = @button.maxY + 4
		

# Timeline

class Timeline extends ScrollComponent
	constructor: (options = {}) ->
		
		_.defaults options, 
			name: 'Timeline'
			scrollVertical: false
			propagateEvents: false
			
			alerts: []
			handler: undefined
		
		super options
		
		_.assign @,
			alerts: options.alerts
			handler: options.handler
				
		# set content insets
		
		@shape = new SVGLayer
			name: 'Line'
			parent: @content
			height: @height
			width: @content.width
			svg: "<svg><path id='line' name='line' d=''/></svg>"
			stroke: "000"
			clip: true
			strokeWidth: 1
			strokeDashoffset: -8
		
		# make buttons 
		
		latestMonthObject = undefined
		
		for year, monthsArray of years
			for monthObject, i in monthsArray
				if (year >= lastDate.getYear() and
				i > lastDate.getMonth()) or (year <= firstDate.getYear() and
				i < firstDate.getMonth())
					continue
				
				score = _.random(200,500)
				
				container = new TimelineButtonContainer
					name: '.'
					parent: @content 
					x: last?.maxX
					height: @height
					
					lastX: last?.maxX
					lastY: last?.y
					minScore: 100
					maxScore: 600
					score: score
					future: monthObject.future
					alertsCount: monthObject.alerts.length
					date: new Date("20"+year[1..2], i)
					dateString: new Date("20"+year[1..2], i).toLocaleString(
						[],
						{month: 'short'}
					).toUpperCase()
				
				last = container
				
				monthObjects.push(monthObject)
				monthObject.timelineButton = container
				monthObject.date = new Date("20"+year[1..2], i)
				monthObject.score = score
				latestMonthObject = monthObject
				
				do (monthObject, container) =>
							
					container.onTap (event) =>
						if Math.abs(event.offset.x) > 12
							return
						@handler.loadMonthObject(monthObject)
		
		# set content insets
		
		insetValue = (@width - (container.width)) / 2
		
		@contentInset =
			left: insetValue / 5
			right: insetValue / 5
		
		@updateContent()
		
		# set line for buttons
		
		@setShape()
		@content.on "change:size", @setShape
		
		# show alerts for the current (most recent) month
		
	
	setShape: =>
		future_string = ''
		past_string = ''
		firstRun = true
		
		@shape?.destroy()
		@shapeDashed?.destroy()
				
		for container, i in @content.children
			if i is 0
				past_string += "M #{container.midX},#{container.button.midY} L"
				continue
			
			if @content.children[i + 1]?.date > today and firstRun
				future_string += "M #{container.midX},#{container.button.midY} L"
				firstRun = false
			
			if container.date > today
				future_string += " #{container.midX},#{container.button.midY}"
				continue
					
			past_string += " #{container.midX},#{container.button.midY}"
			
		
		@shapeDashed = new SVGLayer
			name: 'Line'
			parent: @content
			svg: "<svg><path id='line' d='#{future_string}'/></svg>"
			width: @content.width
			height: @content.height
			stroke: "#000"
			clip: true
			fill: 'transparent'
			strokeWidth: 1
			strokeDashoffset: -8
			strokeDasharray: '15, 15'
			
		@shape = new SVGLayer
			name: 'Line'
			parent: @content
			svg: "<svg><path id='line' d='#{past_string}'/></svg>"
			width: @content.width
			height: @content.height
			fill: 'transparent'
			stroke: "#000"
			clip: true
			strokeWidth: 1
			strokeDasharray: '15, 15'
			
			
		@shapeDashed._elementHTML?.children[0].children[0].setAttribute('stroke-dasharray', '3, 3')
			
		@shape.sendToBack()
		
		@shapeDashed.sendToBack()
		
	focusMonth: (monthObject, animate = true) =>
		@scrollToPoint
			x: monthObject.timelineButton.x +
			@contentInset.left -
			(Screen.width / 2 - monthObject.timelineButton.width / 2), y: 0,
			animate
			
			
		monthObject.timelineButton.buttonCircle.animate
			backgroundColor: grey80
				
		for sib in monthObject.timelineButton.siblings
			continue if sib.constructor.name isnt 'TimelineButtonContainer'
			
			sib.buttonCircle.animateStop()
			sib.buttonCircle.animate
				backgroundColor: grey40

# Alert Link

class AlertLink extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			alert: alerts[0]
			backgroundColor: null
			empty: false
			shadowY: -1
			shadowColor: '#333'
		
		super options
		
		_.assign @,
			alert: options.alert
		
		emptyText = "No changes this month"
		
		@content = new Body
			parent: @
			width: @width - 32
			y: Align.center()
			x: 16
			text: if options.empty then emptyText else alert.content
		
		if options.empty then @height = 80; @content.y = Align.center()
		
		return if options.empty
		
		@content.y = 15
		
		@linklink = new Body
			parent: @
			x: Align.right(-16)
			y: @content.maxY + 4
			color: black
			textDecoration: 'underline'
			icon: 'chevron-right'
			text: 'See details'
			
		@height = @linklink.maxY + 15
			
		@onTap (event) ->
			return if Math.abs(event.offset.y) > 20 
			detailView = new DetailView
				alert: @alert
			
			app.showNext(detailView)

# Alerts Container

class AlertsContainer extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Alerts Container'
			parent: @content
			height: 120
			backgroundColor: null
			clip: true
			shadowColor: black
			animationOptions:
				time: .5
		
		super options
		
		_.assign @,
			alertLinks: []
			
		@header = new Layer
			parent: @
			width: @width
			backgroundColor: bg1
			height: 16
		
		@container = new Layer
			name: 'Container'
			parent: @
			y: @header.maxY + 4
			x: 16
			width: @width - 32
			shadowY: 1
			shadowColor: black
			backgroundColor: null
			clip: true
			animationOptions:
				time: .5
		
		@footer = new Layer
			name: 'Footer'
			parent: @
			y: @container.maxY
			width: @width
			height: 1
			backgroundColor: bg1
			shadowY: -1
			shadowColor: black
			animationOptions:
				time: .25
		
		# header layer
			
		@headingLeft = new H4
			name: 'Header'
			parent: @header
			y: 16
			x: 16
			width: @width - 64
			text: '{month} {year}'
		
		@header.height = @headingLeft.maxY + 16
			
		@alertsCount = new AlertsCount
			name: 'Changes Count'
			parent: @header 
			x: Align.right(-18)
			y: 12
		
		# footer layers 
		
		@moreLink = new H5
			name: 'See More'
			parent: @footer
			width: @width
			textAlign: 'center'
			x: 0
			y: Align.bottom()
			text: 'See More'
			padding: {top: 16, bottom: 16, left: 32, right: 32}
		
		# definitions
		
		Utils.define @, 'showingMore', false, @_toggleShowMore
		
		# events
		
		@container.on "change:height", @_setPositions
	
		@moreLink.onTap (event) =>
			
			return if Math.abs(event.offset.x) > 10 or Math.abs(event.offset.y) > 10
			@showingMore = !@showingMore
	
	_setPositions: =>
		@header.y = 0
		@container.y = @header.maxY + 4
		@footer.y = @container.maxY
		@height = @footer.maxY
	
	_toggleShowMore: (bool) =>
		if not bool 
			@container.animate
				height: @startHeight
				
			@moreLink.text = 'See More'
			return
			
		@container.animate
			height: @maxHeight
		
		@moreLink.text = 'See Less'
		
	
	showMonthObjectAlerts: (monthObject, animate = true) =>
		
		@moreLink.text = 'See More'
			
	
		# set headings
		
		month = monthObject.date.toLocaleString([], {month: 'long'})
		year = monthObject.date.toLocaleString([], {year: 'numeric'})
		
		@headingLeft.template =
			month: month
			year: year
		
		if monthObject.date > today
			@headingLeft.template =
				month: 'Your next report'
				year: ''
		else
			@headingLeft.template =
				month: month
				year: year
		
		
		# setting up links
		
		startHeight = 0
		
		
		# clear existing links
		
		for layer in @container.children
			layer.destroy()
		
		
		# if there aren't any alerts...
		
		if monthObject.alerts.length <= 0
			@alertsCount.visible = false
			
			link = new AlertLink
				parent: @container
				y: 1
				width: @container.width
				empty: true
				
			@alertLinks.push(link)
		
		
		# if we have alerts, let's make alert links
		
		else 
			_.assign @alertsCount,
				visible: true
				value: monthObject.alerts.length
			
			for alert, i in monthObject.alerts
				link = new AlertLink
					parent: @container
					y: last ? 1
					width: @container.width
					alert: alert
				
				last = link.maxY + 1
		
		# set heights
		
		if @container.children.length <= STARTING_ALERTS_COUNT
			@startHeight = _.sumBy(@container.children, 'height')
			@maxHeight = @startHeight
			@footer.visible = false
			@footer.animate {height: 1}
		else
			@startHeight = _.sumBy(@container.children[0...STARTING_ALERTS_COUNT], 'height')
			@maxHeight = _.sumBy(@container.children, 'height')
			@footer.visible = true
			@footer.animate {height: 56}
			@moreLink.maxY = 56
		
		if animate
			@container.animate 
				height: @startHeight
			return
			
		@container.props = 
			height: @startHeight
				

# Alerts Count

class AlertsCount extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Alerts Count'
			height: 28
			width: 28
			borderRadius: 999
			backgroundColor: grey40
			borderColor: grey70
			borderWidth: 1
		
		super options
		
		@number = new Label
			name: 'Alerts Label'
			parent: @
			x: Align.center()
			y: -2
			width: @width
			textAlign: 'center'
			padding: {left: 2}
			text: "{count}"
			
		Utils.defineValid @, 'value', 0, _.isNumber, 'Value must be a number', @_setValue
		
		
	_setValue: (num) ->
		@number.template = num

# Separator

class Separator extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			backgroundColor: grey
			shadowY: -1
			shadowColor: grey80
			height: 16
			
		super options


# ----------------
# implementation

app = new App
	title: 'www.clearscore.com'

# Home View

homeView = new View
	title: 'Framework Components'
	contentInset:
		top: 55

navBar = undefined
initial = true
monthObjects = []

Utils.bind homeView, ->
	
	@alertsByYear = years
	
	@loadMonthObject = (monthObject, animate = true) =>
		@timeline.focusMonth(monthObject, animate)
		@alertsContainer.showMonthObjectAlerts(monthObject, animate)
		
		if initial
			@header.title.template = 
				score: monthObject.score
			initial = false
		
	@scrollBack = => 
		@scrollToPoint
			x: 0, y: 0
			true
	
	# nav bar
	
	navBar = new Layer
		parent: homeView
		height: 55
		y: app.header.height
		width: Screen.width
		backgroundColor: '#e5e5e5'
		
	overview = new Body2
		parent: navBar
		x: 16
		y: Align.center()
		text: 'OVERVIEW'	

	# header
	
	@header = new Layer
		parent: @content
		height: 37
		y: 0
		x: 0
		width: Screen.width
		backgroundColor: null
	
	Utils.bind @header, ->
		@title = new H3
			parent: @
			y: 25
			text: "#{today.toLocaleDateString([], {month: 'long'})} Score: {score}"
			width: @width
# 			fontWeight: 300
			fontSize: 24
			textAlign: 'center'
	
		@leftText = new Body2
			parent: @
			x: 16
			y: @title.maxY + 15
			text: 'Report date: 5 January 2018'
			
		@rightText = new Body2
			parent: @
			x: Align.right(-16)
			y: @title.maxY + 15
			text: '17 days until next report'
		
		@div = new Divider
			parent: @
			y: @leftText.maxY + 15
			x: 16
			width: @width - 32
		
		@height = @div.maxY
	
	# timeline
	
	@timeline = new Timeline
		parent: @content
		x: 0, y: @header.maxY + 32
		height: 128
		width: @width
		alerts: @alertsByYear
		handler: @
		
	# alerts container
	
	@alertsContainer = new AlertsContainer
		parent: @content
		y: @timeline.maxY + 32
		x: -1
		width: @width + 1
			
	@alertsContainer.handler = @
	
	@separator = new Separator
		parent: @content
		x: 0
		y: @alertsContainer.maxY + 32
		width: @width
		height: if not SHOW_SEPARATOR then 1
		visible: if not SHOW_SEPARATOR then false
	
	# static content
	
	@statics = new Layer
		name: 'Static Content'
		parent: @content
		x: 0
		y: @separator.maxY + 16
# 		y: @alertsContainer.maxY + 16
		image: 'images/statics.png'
		width: @width
		height: @width * 3392/758
	
	@alertsContainer.on "change:height", => 
		@separator.y = @alertsContainer.maxY + 32
		@statics.y = @separator.maxY + 48
# 		@statics.y = @alertsContainer.maxY + 48
	
 

# start 
homeView.loadMonthObject(
	_.find(monthObjects, (m) ->
		m.date.getMonth() is today.getMonth()
		), false
	)

app.showNext homeView