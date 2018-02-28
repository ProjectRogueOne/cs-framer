require 'cs-ux'
require 'gotcha'

# Setup

Canvas.backgroundColor = '#000'
Framer.Extras.Hints.disable()

SHOW_DATE_LABEL = true

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
dates = _.map([90, 180, 180, 240, 240, 240, 240, 240], (d) ->
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

futureDate = new Date(today.getTime() + 14 * dayLength)

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
		
			@alert = options.alert
			
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
		
		@button = new Layer
			name: 'Button'
			parent: @
			x: Align.center()
			y: Utils.modulate(
				@score, 
				[@minScore, @maxScore]
				[24,  @height +
				(if SHOW_DATE_LABEL then -60 else -36)]
				true
				)
			height: 32
			width: 32
			borderRadius: 16
			borderWidth: 1
			borderColor: '#000'
			backgroundColor: '#CCC'
		
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
		
		
			
		# Events
		
# 		@button.onTap (event) =>
# 			if Math.abs(event.offset.x) > 16
# 				return
			
			# do the thing
			
# 			@handler.focusCurrentMonth(@monthObject, true)

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
				monthObject.timelineButton = container
				monthObject.date = new Date("20"+year[1..2], i)
				latestMonthObject = monthObject
				
				do (monthObject, container) =>
							
					container.onTap (event) =>
						if Math.abs(event.offset.x) > 12
							return
						@handler.showAlerts(monthObject)
		
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
		
		Utils.delay 0, => @handler.showAlerts(latestMonthObject)
	
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

# Alert Link

class AlertLink extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			alert: alerts[0]
			backgroundColor: '#f2f2f2'
			empty: false
		
		super options
		
		_.assign @,
			alert: options.alert
		
		emptyText = "No changes this month"
		
		@content = new Body
			parent: @
			width: @width - 128
			y: 32
			x: 32
			text: if options.empty then emptyText else alert.content
		
		@height = @content.maxY + 32
		
		return if options.empty
			
		chevron = new Icon
			parent: @
			x: Align.right(-16)
			y: Align.center()
			size: 32
			icon: 'chevron-right'
			
		@onTap (event) ->
			return if Math.abs(event.offset.y) > 20 
			detailView = new DetailView
				alert: @alert
			
			app.showNext(detailView)

# ----------------
# implementation

app = new App
	title: 'www.clearscore.com'

# Home View

homeView = new View
	title: 'Framework Components'
	contentInset:
		top: 96


# functions
Utils.bind homeView, ->
	
	@showAlerts = (monthObject) =>
		
		@moreLink.text = 'See More'
		@headingRight.visible = true
		
		@timeline.scrollToPoint
			x: monthObject.timelineButton.x + @timeline.contentInset.left - (Screen.width / 2 - monthObject.timelineButton.width / 2)
		
		monthObject.timelineButton.animate
			brightness: 85
				
		for sib in monthObject.timelineButton.siblings
			sib.animate
				brightness: 115
	
		startHeight = 0
	
		# set heading
		
		month = monthObject.date.toLocaleString([], {month: 'long'})
		year = monthObject.date.toLocaleString([], {year: 'numeric'})
		
		@headingLeft.template =
			month: month
			year: year
		
		
		if monthObject.date > today
		
			@headingLeft.template =
				month: 'Your next report'
				year: ''
			
			@headingRight.template =
				count: monthObject.alerts.length
				upcoming: ''
				plural: if monthObject.alerts.length > 1 then 's' else ''
				month: month
		
		else
		
			@headingLeft.template =
				month: month
				year: year
			
			@headingRight.template =
				count: monthObject.alerts.length
				upcoming: ''
				plural: if monthObject.alerts.length > 1 then 's' else ''
				month: month
			
			
		for layer in @alertsContainer.children
			layer.destroy()
		
		
		if monthObject.alerts.length <= 0
			@alertsContainer.startHeight = 96
			
			@headingRight.visible = false
			
			
			new AlertLink
				parent: @alertsContainer
				width: @width
				y: 0
				empty: true
		
# 		else
# 		
# 			if monthObject.timelineButton.date > today
# 			else
# 				@heading.template =
# 					count: monthObject.alerts.length
# 					upcoming: ''
# 					plural: if monthObject.alerts.length > 1 then 's' else ''
# 					month: month
	
		# make alert links
	
		for alert, i in monthObject.alerts
			link = new AlertLink
				parent: @alertsContainer
				width: @width
				y: last ? 0
				alert: alert
				
			last = link.maxY + 8
			if i < STARTING_ALERTS_COUNT then @alertsContainer.startHeight = last
		
		@alertsContainer.maxHeight = last
		@alertsContainer.animate
			height: @alertsContainer.startHeight
		
		_.assign @moreLink,
			visible: i > STARTING_ALERTS_COUNT
			
	@toggleShowMore = (bool) =>
		if not bool 
			@alertsContainer.animate
				height: @alertsContainer.startHeight
				
			@scrollToPoint
				x: 0, y: 0
				true
				
			@moreLink.text = 'See More'
			return
			
		@alertsContainer.animate
			height: @alertsContainer.maxHeight
		
		@moreLink.text = 'See Less'


# layers
Utils.bind homeView, ->
	# just to be explicit...
	@alertsByYear = years

	@timeline = new Timeline
		parent: @content
		x: 0, y: 16
		height: 128
		width: @width
		alerts: @alertsByYear
		handler: @
		
	@headingLeft = new H4
		name: 'Heading'
		parent: @content 
		y: @timeline.maxY + 16
		x: 32
		width: @width - 64
		text: '{month} {year}'
	
	@headingRight = new H5
		name: 'Heading'
		parent: @content 
		y: @timeline.maxY + 16
		textAlign: 'right'
		x: 32
		width: @width - 64
		text: '{count}{upcoming} change{plural}'
	
	@alertsContainer = new Layer
		name: 'Alerts Container'
		parent: @content
		y: @headingLeft.maxY + 16
		x: 0
		width: @width
		height: 120
		backgroundColor: null
		clip: true
		animationOptions:
			time: .5
	
	@alertsContainer.handler = @
		
	@moreLink = new H5
		name: 'See More'
		parent: @content
		width: @width
		textAlign: 'center'
		x: 0
		y: @alertsContainer.maxY + 16
		height: 48
		text: 'See More'
	
	@statics = new Layer
		name: 'Static Content'
		parent: @content
		x: 0
		y: @moreLink.maxY + 16
		image: 'images/statics.png'
		width: @width
		height: @width * 3392/758
		
	Utils.define @, 'showingMore', false, @toggleShowMore
	
	Utils.pin @moreLink, @alertsContainer, 'bottom'
	
	Utils.pin  @statics, @moreLink, 'bottom'
	
	@moreLink.onTap => @showingMore = !@showingMore

# Nav Bar

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

	
navBar2 = new Layer
	parent: homeView
	height: 37
	y: navBar.maxY
	width: Screen.width
	backgroundColor: '#d8d8d8'
	
leftText = new Body2
	parent: navBar2
	x: 16
	y: Align.center()
	text: 'Report date: 5 January 2018'
	
rightText = new Body2
	parent: navBar2
	x: Align.right(-16)
	y: Align.center()
	text: '17 days until next report'

app.showNext homeView