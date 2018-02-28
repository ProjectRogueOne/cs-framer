require "gotcha/gotcha"
moreutils = require 'moreutils'
cs = require 'cs'


cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'
	
app.header.collapse = false

navBar = new Layer
	parent: app.header
	height: 55
	y: app.header.height
	width: Screen.width
	backgroundColor: '#e5e5e5'
	
overview = new cs.Text
	parent: navBar
	x: 16
	y: Align.center()
	text: 'OVERVIEW'

	
navBar2 = new Layer
	parent: app.header
	height: 37
	y: navBar.maxY
	width: Screen.width
	backgroundColor: '#d8d8d8'
	
leftText = new cs.Text
	parent: navBar2
	x: 16
	y: Align.center()
	text: 'Report date: 5 January 2018'
	
rightText = new cs.Text
	parent: navBar2
	x: Align.right(-16)
	y: Align.center()
	text: '17 days until next report'

app.header.height = navBar2.maxY
app.header.on "change:height", -> app.header.height = navBar2.maxY

# ______________________________
# Global Variables

# how long ago did the user check their report?
LAST_CHECKED_DAY_AGO = 45

HAS_UPCOMING_CHANGES = true # Math.random() > .5

# Show a date label on the timeline?
SHOW_DATE_LABEL = true

# Colors
LIGHT = '#fafed9'
DARK = '#5a5ff9'
cs.Colors.primary = "#8ed0e7"
cs.Colors.secondary = "#ff9865"

minScore = 350
maxScore = 450

TILES_SCROLL_SPEED = 1
TIMELINE_SCROLL_SPEED = .2

# ______________________________
# Data 

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

# Create Dummy Data

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
dates = _.map([14, 32, 38, 44, 44, 63, 91, 95, 95, 105, 152, 161, 200, 240, 270, 301, 330, 360, 400], (d) ->
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

alerts.push new Alert
	seen: false
	date: futureDate
	month: futureDate.getMonth() % 12
	thisMonth: false
	content: "A HSBC credit card has been added to your account."
	meaning: lorem
	cta1: "This doesn't look right."
	cta2: "Why is this not part of my Report?"
	type: 'upcoming'

alerts = _.sortBy(alerts, 'date')

# ______________________________
# Components

# New Dot

class NewDot extends Layer
	constructor: (options = {}) ->
			
		_.assign options,
			name: 'New Dot'
			y: 7
			height: 8
			width: 8
			borderRadius: 4
			visible: false
		
		_.defaults options,
			x: -16
			backgroundColor: 'rgba(74, 144, 226, 1.000)'
			
		super
		
		Utils.delay 0, => @x = options.x

# Change Entry

ChangeEntry = (alert, options = {}) ->
	
	data =
		if alert.date <= new Date('11/1/17')
			@alert = undefined
			title: 'No changes'
			color: '#333'
			link: 'Expecting a change?'
		else if alert.date >= new Date()
			title: 'Upcoming change'
			color: '#23bdff'
			link: 'More details'
		else
			title: 'Change updated on your Report'
			color: 'secondary'
			link: 'See on Report'
	
	container = new Layer options
	
	getAlertAction = (alert) =>
		if not alert
			action = => app.showNext(new DetailView {alert: null})
		else if alert.thisMonth
			action = => app.showNext(new DetailView {alert: alert})
		else if alert.type is 'upcoming'
			action = => app.showNext(new DetailView {alert: alert})
		else 
			action = => null
		
		return action
	
	Utils.build container, ->
		title = new cs.Text
			parent: @
			text: data.title
			color: data.color
		
		dot = new NewDot
			parent: title
			visible: !alert.seen
			x: Align.right(16)
			backgroundColor: '#fd7d6a'
			
		description = new cs.Text 
			parent: @
			text: if alert.date.getMonth() is 9 then 'You have no changes to display this month.' else alert.content
			y: title.maxY + 8
		
		link = new cs.Text
			parent: @
			text: data.link 
			color: '#AAA'
			type: 'link'
			y: description.maxY + 8
			action: getAlertAction(alert)
		
		date = new cs.Text
			parent: @
			text: alert.date.toLocaleDateString([], {day: 'numeric', month: 'short', year: 'numeric'}).toUpperCase()
			y: link.y
			x: Align.right 
			color: '#AAA'
			
		Utils.contain(@, @children)
	
	return container

# Detail View

class DetailView extends cs.View
	constructor: (options = {}) ->
		
		@alert = options.alert
		
		super
		
		@backgroundColor = "#FFF"
		@content.backgroundColor = "#FFF"
		
		# header
		
		@header = new Layer
			parent: @
			width: @width
			height: 56
			backgroundColor: '#e5e5e5'
		
		@back = new cs.Icon
			parent: @header
			icon: 'chevron-left'
			x: 8
			y: Align.center()
			
		@backText = new cs.Text 
			parent: @header 
			text: 'Overview'
			x: @back.maxX
			y: Align.center()
			color: '#000'
			
		@header.onTap => 
			app.showPrevious()
			Utils.delay 2, => @destroy()
		
		# content 
		
		title = new cs.H3
			parent: @content
			x: 32
			y: 80
			text: @getTitle()
			
		date = new cs.Text 
			parent: @content 
			x: Align.right(-32)
			y: title.y + 4
			text: @alert?.date.toLocaleDateString() ? ''
			color: '#AAA'
		
		content = new cs.Text
			parent: @content
			x: 32
			y: title.maxY + 32
			text: @alert?.content ? 'Your membership in the Party has been revoked since last check.'
			width: @width - 64
			
		title2 = new cs.Text 
			parent: @content
			x: 32
			y: content.maxY + 64
			textDecoration: 'underline'
			text: 'What does this mean?'
		
		meaning = new cs.Text
			parent: @content
			x: 32
			y: title2.maxY + 32
			text: @alert?.meaning ? "Your credit score is based in part on your Party membership. It should go without saying that losing the faith of your comrades has consequences. We don't know what you did, or who you crossed, but brother, you're in for it now."
			width: @width - 64
			
	getTitle: =>
	
		if not @alert 
			return 'Expecting a Change?'
		
		if @alert.type is 'changed'
			return 'Upcoming Change'
			
		if @alert.type is 'upcoming'
			return 'Upcoming Change'

# Date Component

class DateComponent extends ScrollComponent
	constructor: (options = {}) ->
		
		_.defaults options,
			width: Screen.width
			height: 48
			scrollVertical: false
			
		super options
		
		_.assign @,
			scrollTarget: undefined
			handler: options.handler
		
		@monthDates = []
		
		@markerlayerLeft = new Layer
			parent: @content
			width: 1
			
		@markerlayerRight = new Layer
			parent: @content
			width: 1
		
		
	addMonth: (monthContainer, dateString) =>
		monthDate = new cs.Text
			type: 'body1'
			parent: @content
			x: monthContainer.x
			text: dateString
		
		monthDate.monthContainer = monthContainer
		monthDate.range = [monthContainer.x, monthContainer.maxX - monthDate.width]
		
		@monthDates.push(monthDate)
		@updateContent()
		
		throttledSetMonth = Utils.throttle(.15, @setMonth)
		
		do (monthDate, monthContainer) =>
			@scrollTarget.content.on "change:x", =>
				@setMonth(monthDate, monthContainer)
		
	getDateByMonthContainer: (monthContainer) ->
		return _.find(@monthDates, ['monthContainer', monthContainer])
		
	setMonth: (monthDate, monthContainer) =>
		thisIndex = @scrollTarget.content.children.indexOf(monthContainer)
		currentIndex = @scrollTarget.content.children.indexOf(@handler?.currentMonth?.tilePage)
		
		referenceX = monthContainer.x - @scrollTarget.scrollX + @scrollTarget.contentInset.left
		referenceMaxX = monthContainer.maxX - @scrollTarget.scrollX + @scrollTarget.contentInset.left
			
		if thisIndex > currentIndex
			monthDate.x = referenceX
		else if thisIndex < currentIndex
			monthDate.x = _.clamp(referenceMaxX - monthDate.width, -999, -10)
		else  # if current
			@markerlayerLeft.x = referenceX
			@markerlayerRight.x = _.clamp(referenceMaxX, 0, 108)
			
			
			tileMidX = 104 - (monthDate.width / 2)
			
			
			monthDate.x = _.clamp(Screen.width / 2 - monthDate/2, 108, Screen.width - 108)

# TimeLineComponent

class TimeLineComponent extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Timeline/ Alerts Component'
			alerts: null
			backgroundColor: null
		
		super options
		
		_.assign @,
			months: []
			alerts: options.alerts
			_transitioning: false
			width: Screen.width
			_lastTileScrollX: 0
			_lastTimeLineX: 0
			animateTiles: false
		
		
		# ______________________________
		# Process alerts into arrays by date
		
		years = {}
		
		for alert in @alerts
			y = alert.date.getYear()
			m = alert.date.getMonth()
			
			# if its a new year, create a year with 12 blank arrays
			years[y] ?= _.range(12).map (y) -> []
			
			# add this alert to the right year's array
			years[y][m].push(alert)
		
		lastDate = _.last(@alerts).date
		firstDate = @alerts[0].date
		
		# ______________________________
		# Scroll Components
		
		# timeline scroll
		
		@timeLineScroll = new ScrollComponent
			parent: @
			width: @width
			height: 108
			scrollVertical: false
			originX: 0
			originY: 0
		
		@timeLineScroll.contentInset =
			left: @width/3
			right: @width/3
		
		# date scroll
		
# 		@dateComponent = new DateComponent
# 			parent: @
# 			y: @timeLineScroll.maxY + 16
# 			handler: @
			
		# tile scroll
		
		@tileScroll = new ScrollComponent
			parent: @
			y: @timeLineScroll.maxY
			width: @width
			height: 228
			scrollVertical: false
			originX: .5
			originY: 0
			
# 		@dateComponent.scrollTarget = @tileScroll
		
		@tileScroll.contentInset =
			left: 104
			right: 104
			
		@tileScroll.content.clip = false
				
		@setCurrentMonthWhileScrollingThrottled = Utils.throttle(1, @setCurrentMonthWhileScrolling)
			
		# shared props
				
		for layer in [@timeLineScroll, @tileScroll]
			layer.content.draggable.momentumOptions =
				friction: 8
				tolerance: 50
			
			
			do (layer) =>
				layer.onPan (event) =>
					if event.offsetDirection is 'left' or
					event.offsetDirection is 'right'
						app.current.scrollVertical = false
						@_scrollY = app.current.scrollY
					else
						app.current.scrollVertical = true
						if @_scrollY?
							app.current.scrollToPoint(
								x: 0, y: @_scrollY
								false
								)
								
							@_scrollY = undefined
		
		
		# ______________________________
		# Month containers
		
		for year, months of years
			for alerts, month in months
				# skip blank months after the latest month with an alert
				if year >= lastDate.getYear() and
				month > lastDate.getMonth()
					continue
				
				# skip blank months before the earliest month with an alert
				if year <= firstDate.getYear() and
				month < firstDate.getMonth()
					continue
				
				# come up with a random score
				
				score = _.random(minScore, maxScore)
				
				# create a month container for the tile scroll
				
				monthPage = new MonthContainer
					name: 'Month Page'
					parent: @tileScroll.content
					x: start ? 0
					backgroundColor: null
					alerts: alerts
					year: year
					month: month
					score: score
					animationOptions:
						time: .25
				
				start = monthPage.maxX
				
				dateString = new Date('20' + year.slice(1), month).toLocaleDateString(
					[],
					{year: 'numeric', month: 'long'}
					)
				
				# create a timeline Button for the timeline scroll
				
				monthButton = new TimelineButtonContainer
					parent: @timeLineScroll.content
					height: @timeLineScroll.height
					x: buttonStart
					score: score
					minScore: minScore
					maxScore: maxScore
					buttonStart: buttonStart
					year: year
					month: month
					lastY: lastY
					lastX: lastX
					tileContainer: monthPage
					alertsCount: alerts.length
					handler: @
					
				# create a date for the date scroll
		
# 				@dateComponent.addMonth(monthPage, dateString)
				
				# iterate values
				
				buttonStart = monthButton.maxX
				lastY = monthButton.button.midY
				lastX = monthButton.button.midX
				
				# add an object storing all these things
				
				monthObject = {month: month, tilePage: monthPage, buttonPage: monthButton}
				monthButton.monthObject = monthObject
				Utils.delay 0, => monthButton.button.bringToFront()
				@months.push monthObject
		
		# set a dashed line and a stroke label for last predicted score
		
		if parseInt(year) is new Date().getYear() and
		parseInt(month) > new Date().getMonth()
			path = monthButton.shape._elementHTML?.children[0].children[0]
			path.setAttribute('stroke-dasharray', '3, 3')
			
			predictedScore = new Layer
				parent: monthButton
				x: monthButton.button.maxX + 8
				y: monthButton.button.y
				height: 32
				width: 96
				borderRadius: 4
				borderWidth: 1
				borderColor: new Color('#e7f6fb').darken(20)
				backgroundColor: '#e7f6fb'
				
			predictedScoreLabel = new TextLayer
				parent: predictedScore
				color: '#333'
				fontSize: 12
				y: Align.center
				x: 8
				text: 'Predicted Score'
				
			predictedScore.width = predictedScoreLabel.width + 16
		
			monthButton.width = predictedScore.maxX
			@timeLineScroll.updateContent()
			
		# set current month
		
		Utils.define @, 'currentMonth', undefined, @setCurrentMonth
		
		@height = @tileScroll.maxY
		
		@_timeLineMonth = monthObject
		
		# TODO: month / year textlayers
		
		# ....
		
		# ______________________________
		# events

		@timeLineScroll.content.onDragStart @startTimeLineScrollTimer
		
		@timer = undefined
		
		@time = 0
		
		@basicTimer = Utils.interval .25, =>
			return if @timeLineScroll.content.draggable.isDragging
			
			tilescrollMonth = @getCurrentMonthFromTileScroll()
			@currentMonth = @_timeLineMonth ? tilescrollMonth
			
			return if @currentMonth is @_lastCurrentMonth
			@_lastCurrentMonth = @currentMonth
			
			@focusCurrentMonth(@currentMonth, @_timeLineMonth?)
	
	
	# when the timeline is scrolled, check a timer to poll for the user's selection
	
	startTimeLineScrollTimer: =>
		@_timeLineIsScrolling = true
		@timer = Utils.interval .1, =>
			
			newX = @timeLineScroll.content.x
			
			if Math.abs(@_lastTimeLineX - newX) is 0
				if @timeLineScroll.content.draggable.isDragging
					return
				
				@_timeLineIsScrolling = false
				
				@_timeLineMonth = @getCurrentMonthFromTimeLineScroll()
				clearInterval @timer
			
			@_lastTimeLineX = newX
	
	
	# find a button that's overlapping the center of the screen
	
	getCurrentMonthFromTimeLineScroll: =>
		underMonthObject = _.find(@months, (m) =>
			m.buttonPage.screenFrame.x <
			Screen.width/2 <
			m.buttonPage.screenFrame.x + m.buttonPage.width
		)
				
		return underMonthObject
	
	
	# find a month container that's overlapping the center of the screen
	
	getCurrentMonthFromTileScroll: =>
		scrollMaxX = @scrollX + @width
		
		# look for a tile that's off both edges
		insideMonthObject = _.find(@months, (m) =>
			offLeft = m.tilePage.screenFrame.x < 0
			offRight = m.tilePage.screenFrame.x + m.tilePage.width > @width
			return offLeft and offRight
		)
		
		if insideMonthObject?
			return insideMonthObject
		
		underMonthObject = _.find(@months, (m) =>
			m.tilePage.screenFrame.x <
			Screen.width / 2 < # half of a tile's width
			m.tilePage.screenFrame.x + m.tilePage.width
		)
		
		return underMonthObject
	
	
	# focus on the current month
	
	focusCurrentMonth: (monthObject, tilesScroll = false) =>
		
		@_scrollingToTile = true
		
		@showCurrentMonthButtonPage(monthObject)
		
		# move tilescroll too?
		if tilesScroll then @showCurrentMonthTile(monthObject)
		
		Utils.delay 1, => @animateTiles = true
	
	
	# show the current month on the timeline
	
	showCurrentMonthButtonPage: (monthObject) =>
		return if not monthObject
		@_scrollingToTile = true
		
		centerX = monthObject.buttonPage.x + @timeLineScroll.contentInset.left - @width/2 + monthObject.buttonPage.width/2
		
		@timeLineScroll.scrollToPoint( 
			x: centerX, y: 0
			@animateTiles
			TIMELINE_SCROLL_SPEED
			)
		
		for layer in _.without(@timeLineScroll.content.children, monthObject.buttonPage)
# 			layer.button.image = 'images/button.png'
			layer.animate 
				opacity: .5
	
		for layer in _.without(@tileScroll.content.children, monthObject.tilePage)
			layer.dateLayer.animate 
				opacity: .5
				
		do (monthObject) =>
			Utils.delay 0, =>
# 				monthObject.buttonPage.button.image = 'images/active_button.png'
				monthObject.buttonPage.animate
					opacity: 1
				monthObject.tilePage.dateLayer.animate
					opacity: 1
	
	# show the current month tile on the tile scroll 
	
	showCurrentMonthTile: (monthObject) =>
		@tileScroll.scrollToPoint( 
			x: monthObject.tilePage.x - @width/2 + 128, y: 0
			@animateTiles,
			TILES_SCROLL_SPEED
			)
			
	
			
		@tileScroll.on Events.ScrollAnimationDidEnd, =>
			@_timeLineMonth = undefined

# TimeLine Button Container

class TimelineButtonContainer extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Month Button'
			backgroundColor: null
			x: (buttonStart ? 0)
			width: 112
			animationOptions:
				time: .25
				
		super options
		
		@alertsCount = options.alertsCount
		@tileContainer = options.tileContainer
		@monthObject = options.monthObject
		@handler = options.handler
		
		@button = new SVGLayer
			name: 'Button'
			parent: @
			x: Align.center()
			y: Utils.modulate(
				options.score, 
				[options.minScore, options.maxScore]
				[24,  @height +
				(if SHOW_DATE_LABEL then -60 else -36)]
				true
				)
			height: 32
			width: 32
			borderRadius: 16
			borderWidth: 1
			borderColor: '#000'
		
		# alerts count label
		
# 		alertsCountLabel = new cs.Text 
# 			name: 'Score'
# 			type: 'body1'
# 			parent: @button
# 			point: Align.center()
# 			textAlign: 'center'
# 			text: @alertsCount
# 			color: '#333'
		
		# score label
		
		scoreLabel = new cs.Text 
			name: 'Score'
			parent: @
			width: 200
			midX: @button.midX
			y: -32
			textAlign: 'center'
			text: options.score
		
		scoreLabel.maxY = @button.y - 4
		
		# date label
		
		if SHOW_DATE_LABEL
			@dateLabel = new cs.Text 
				name: 'Date'
				parent: @
				width: 200
				midX: @button.midX
				y: @button.height + 32
				textAlign: 'center'
				text: new Date('20' + options.year.slice(1),
				options.month).toLocaleDateString(
					[], {month: 'short'}
					).toUpperCase()
			
			@dateLabel.y = @button.maxY + 4
		
		# unless this is the first button...
		
		if options.buttonStart?
			@shape = new SVGLayer
				name: 'Line'
				parent: @
				y: _.min(@button.midY, options.lastY)
				x: -40
				height: @height
				width: 96
				svg: "<svg><path d='M#{-@button.width/2} #{options.lastY} " +
					"L #{80} #{@button.midY}'/></svg>"
				stroke: "000"
				clip: true
				strokeWidth: 1
				strokeDashoffset: -8
			
			@shape.sendToBack()
		
			
		# Events
		
		@button.onTap (event) =>
			if Math.abs(event.offset.x) > 16
				return
				
			@handler.focusCurrentMonth(@monthObject, true)

# Month Container

class MonthContainer extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			backgroundColor: null
		
		super options
		
		_.assign @,
			year: options.year
			month: options.month
			alerts: options.alerts
			label: options.month
			
		@dateLayer = new cs.Text 
			type: 'body1'
			parent: @
			text: new Date('20' + @year.slice(1), @month).toLocaleDateString(
				[],
				{year: 'numeric', month: 'long'}
				)
			animationOptions:
				time: .2
		
		@makeTiles()
		
		@width = _.maxBy(@children, 'maxX').maxX + 8
	
	makeTiles: =>
		
		# show blank one if no alerts
		if @alerts.length is 0
			new AlertTile
				parent: @ 
				y: @dateLayer.maxY + 4
				date: new Date('20' + @year.slice(1), @month)
				alert: null
			return
				
		# make alert tiles
		for alert in @alerts
			
			alert = new AlertTile
				parent: @
				y: @dateLayer.maxY + 4
				x: start ? 0
				date: alert.date
				alert: alert
			
			start = alert.maxX + 8

# Alert Tile

class AlertTile extends Layer
	constructor: (options = {}) ->
		
		_.assign options, 
			name: 'Alert Tile'
			backgroundColor: null
		
		
		@alert = options.alert
		@date = @alert?.date ? options.date
		
		if not HAS_UPCOMING_CHANGES
			if @alert?.date is futureDate
				@noUpcoming = true
				@alert = undefined
		
		super options
		
		@tile = new Layer
			parent: @
			y: 0
			width: 208
			height: 180
			backgroundColor: @getColor()
			borderWidth: 1
			borderColor: new Color(@getColor()).darken(20)
		
		if @alert?
			@type = new cs.Text 
				type: 'body1'
				parent: @tile
				x: 8
				y: 8
				color: '#AAA'
				text: _.startCase(@alert.type.toUpperCase())
			
			if not @alert.seen
				@newDot = new NewDot
					parent: @type
					x: Align.right(16)
				
				
				@tile.borderColor = '#333'
		
		@description = new cs.Text
			type: 'body1'
			parent: @tile 
			x: Align.center()
			y: Align.center(-4)
			width: @tile.width - 32
			text: @getDescription()
			textAlign: 'center'
		
		Utils.contain(@, @children)
		
		@seeMore = new cs.Text 
			type: 'body1'
			textDecoration: 'underline'
			parent: @tile
			x: 8
			y: Align.bottom(-16)
			color: '#4a90e2'
			text: @getAlert().text
			action: @getAlert().action
	
	getDescription: =>
		if @alert?.content
			return @alert.content 
		
		if @noUpcoming
			return 'No upcoming changes'
		else 
			return 'No changes this month'
	
	getAlert: =>
		if not @alert
			text = 'Expecting an update?'
			action = => app.showNext(new DetailView {alert: null})
		else if @alert.thisMonth
			text = 'See details'
			action = => app.showNext(new DetailView {alert: @alert})
		else if @alert.type is 'upcoming'
			text = 'See details'
			action = => app.showNext(new DetailView {alert: @alert})
		else 
			text = 'See on Report'
			action = => null
		
		return {
			text: text
			action: action
		}
		
	getColor: =>
		if not @alert?
			return 'rgba(216, 216, 216, 1.000)'
		
		if @alert.type is 'changed' 
			return '#f8ebe5'
		
		return 'rgba(231, 246, 251, 1.000)'


# ______________________________
# Views

# Report View

class Report extends cs.View
	constructor: (options = {}) ->
		
		_.defaults options,
			alerts: alerts
			showLayers: true
			contentInset:
				top: app.header.height
				bottom: 48
		
		_.assign @,
			alerts: options.alerts
		
		super
		
		@backgroundColor = "#FFF"
		@content.backgroundColor = "#FFF"
		
		# ______________________________
		# Header
		
		welcome1 = new cs.H3
			name: 'welcome'
			parent: @content 
			text: 'Welcome back Kimberly Wood'
			y: 12
			x: Align.center()
			width: @width
			textAlign: 'center'
			
		@intro = new cs.Text
			name: 'Upcoming changes intro'
			parent: @content 
			color: '#777'
			textAlign: 'center'
			y: welcome1.maxY + 16
			width: @width
			text: 'Since your last visit you have'
		
		@upcomingChangesCount = new cs.Text 
			name: 'Upcoming Changes'
			parent: @content 
			text: ' '
			color: 'primary'
			textAlign: 'center'
			y: @intro.maxY
		
		@upcomingChangesCountDot = new NewDot
			parent: @upcomingChangesCount
			x: Align.right(16)
			backgroundColor: '#fd7d6a'
			
		@updatesCount = new cs.Text 
			name: 'Upcoming Changes'
			parent: @content 
			text: ' '
			color: 'secondary'
			textAlign: 'center'
			y: @upcomingChangesCount.maxY
		
		@updatesCountDot = new NewDot
			parent: @updatesCount
			x: Align.right(16)
			backgroundColor: '#fd7d6a'
			
		@noUpdates = new cs.Text 
			name: 'Upcoming Changes'
			parent: @content 
			text: 'You have no new upcoming updates'
			color: '#AAA'
			y: welcome1.maxY + 8
			textAlign: 'center'
			visible: false
		
		
		@setChangesCounts()
		
		start = @updatesCount.maxY
		
		
		
		# ______________________________
		# Report Updates
		
		@timeLine = new TimeLineComponent
			parent: @content
			y: start + 20
			width: @width
			alerts: @alerts
		
		@theRestOfTheReport = new Layer
			parent: @content
			y: @timeLine.maxY
			width: @width
			height: @width * (3232/758)
			image: 'images/statics.png'
		
		
		
# 		
# 		# ______________________________
# 		# Personal Information (dummy)
# 		
# 		title = new cs.H2
# 			parent: @content
# 			text: 'Factors on your Report'
# 			x: 16
# 			y: @timeLine.maxY + 64
# 			width: @width - 32
# 		
# 		sep = new cs.Divider
# 			parent: @content
# 			x: title.x
# 			y: title.maxY + 8
# 			width: @width - 32
# 	
	
	
	
	
	setUpdateCount: (num) =>
		text = "#{num} new update"
		if num > 1 then text += 's'
		maxX = @updatesCount
		@updatesCount.template = text
		@updatesCount.visible = num > 0
		@updatesCount.x = Align.right(-16)
		
		
	setChangesCounts: () =>
		a = _.partition(@alerts, (a) -> a.date >= new Date())
		fresh = a[0].filter( (a) -> !a.seen).length
		stale = a[1].filter( (a) -> !a.seen).length
		
		if fresh + stale is 0
			@noUpdates.visible = true
		
		# fresh count
		
		plural = if fresh > 1 then 's' else ''
		text = "#{fresh} new upcoming change#{plural} that will appear next month"
		@upcomingChangesCount.text = text
		@upcomingChangesCount.visible = fresh > 0
		@upcomingChangesCount.x = Align.center()
		@upcomingChangesCountDot.x = Align.right(16)
		
		# stale count
		
		plural = if stale > 1 then 's' else ''
		plural2 = if stale > 1 then 'have' else 'has'
		text = "and #{stale} update#{plural} that #{plural2} appeared on this months Report"
		@updatesCount.text = text
		@updatesCount.visible = stale > 0
		@updatesCount.x = Align.center()
		@updatesCountDot.x = Align.right(16)
		
		
		Utils.delay 0, => 
			Utils.align(
				[@upcomingChangesCount, @updatesCount, @noUpdates], 
				'x', 
				Align.center
				)


reportView = new Report

# app.showNext(new DetailView {alert: new Alert})
app.showNext(reportView)