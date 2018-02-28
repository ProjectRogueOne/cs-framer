moreutils = require 'moreutils'
cs = require 'cs'


cs.Context.setMobile()
Framer.Extras.Hints.disable()

app = new cs.App
	type: 'safari'
	
app.header.collapse = false

navBar = new Layer
	parent: app.header
	height: 56
	y: app.header.height
	width: Screen.width
	backgroundColor: '#e5e5e5'

app.header.height = navBar.maxY
app.header.on "change:height", -> app.header.height = navBar.maxY

HAS_UPCOMING_CHANGES = true # Math.random() > .5

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

# Create Dummy Data

contents = [
	"A County Court Judgement  (CCJ) has been added since last check"
	"An account has been added to your Report since last check"
	"Key attribute(s) will be updated for a CIFAS"
	]
	
lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam quis mattis mauris, in lacinia nunc. Aenean enim urna, elementum nec turpis quis, congue cursus diam. Vestibulum at faucibus tortor. Nullam accumsan sodales placerat."

lastChecked = new Date('11/15/17')
today = new Date('12/25/17')
dayLength = 1000*60*60*24

lastDate = today

dates = [
	new Date('2/14/18'),
	new Date('1/14/18'),
	new Date('12/14/17'),
	new Date('12/12/17'),
	new Date('11/14/17'),
	new Date('10/14/17'),
	new Date('10/12/17'),
	new Date('10/1/17'),
	new Date('8/01/17'),
	new Date('8/14/16'),
	new Date('7/14/16'),
]

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

futureDate = new Date('2/19/18')
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

# TimeLineComponent

class TimeLineComponent extends ScrollComponent
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Timeline/ Alerts Component'
			alerts: null
			originX: 0
			scrollVertical: false
		
		super options
		
		_.assign @,
			alerts: options.alerts
			propagateEvents: false
			
		@contentInset =
			left: 8
			right: 8
			
		@content.draggable.momentumOptions 
		
		# ______________________________
		# Alert Tiles
		
		
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
		
		for year, months of years
			for alerts, month in months
				if year >= lastDate.getYear() and month > lastDate.getMonth()
					continue
				
				if year <= firstDate.getYear() and month < firstDate.getMonth()
					continue
				
				# month container
				monthPage = new MonthContainer
					parent: @content
					x: start ? 0
					backgroundColor: null
					alerts: alerts
					year: year
					month: month
				
				start = monthPage.maxX
		
		@updateContent()
		@scrollToLayer(monthPage, 
			0, 0,
			false
			)
		
		# ______________________________
		# events
		
		@onScrollAnimationDidEnd =>
			@scrollToClosestLayer()
		

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
		
		@makeTiles()
		
		@width = _.maxBy(@children, 'maxX').maxX + 8
	
	makeTiles: =>
		
		# show blank one if no alerts
		if @alerts.length is 0
			new AlertTile
				parent: @ 
				y: @dateLayer.maxY
				date: new Date('20' + @year.slice(1), @month)
				alert: null
			return
				
		# make alert tiles
		for alert in @alerts
			
			alert = new AlertTile
				parent: @
				y: @dateLayer.maxY
				x: start ? 0
				date: alert.date
				alert: alert
			
			start = alert.maxX + 8



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
		
		@makeTiles()
		
		@width = _.maxBy(@children, 'maxX').maxX + 8
	
	makeTiles: =>
		
		# show blank one if no alerts
		if @alerts.length is 0
			new AlertTile
				parent: @ 
				y: @dateLayer.maxY
				date: new Date('20' + @year.slice(1), @month)
				alert: null
			return
				
		# make alert tiles
		for alert in @alerts
			
			alert = new AlertTile
				parent: @
				y: @dateLayer.maxY
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
			type: 'link'
			parent: @tile
			x: 8
			y: Align.bottom(-16)
			color: 'primary'
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
			return 'rgba(237, 244, 230, 1.000)'
		
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
				top: 24
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
			y: 32
			x: Align.center()
			width: @width
			textAlign: 'center'
		
		@upcomingChangesCount = new cs.Text 
			name: 'Upcoming Changes'
			parent: @content 
			text: ' '
			color: 'primary'
			textAlign: 'center'
			y: welcome1.maxY + 8
		
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
			y: start + 64
			width: @width
			alerts: @alerts
		
		
		
		
		
		# ______________________________
		# Personal Information (dummy)
		
		title = new cs.H2
			parent: @content
			text: 'Factors on your Report'
			x: 16
			y: @timeLine.maxY + 64
			width: @width - 32
		
		sep = new cs.Divider
			parent: @content
			x: title.x
			y: title.maxY + 8
			width: @width - 32
	
	
	
	
	
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
		
		text = "You have #{fresh} new upcoming change"
		if fresh > 1 then text += 's'
		@upcomingChangesCount.text = text
		@upcomingChangesCount.visible = fresh > 0
		@upcomingChangesCount.x = Align.center()
		@upcomingChangesCountDot.x = Align.right(16)
		
		# stale count
		
		text = "You have #{stale} changes updated"
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