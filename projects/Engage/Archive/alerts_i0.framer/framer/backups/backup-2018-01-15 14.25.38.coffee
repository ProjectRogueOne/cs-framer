cs = require 'cs'
require "MoreUtils"
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

alertsIcon = new Layer
	parent: navBar
	y: Align.center()
	x: 8
	height: 40
	width: 48
	borderRadius: 4
	backgroundColor: '#AAA'

alertsIconSmall = new Layer
	parent: alertsIcon
	y: Align.center()
	x: Align.center
	height: 20
	width: 20
	borderRadius: 4
	backgroundColor: '#CCC'
	
overview = new cs.Text
	parent: navBar
	x: alertsIcon.maxX + 24
	y: Align.center()
	text: 'OVERVIEW'
	
overview.onTap -> app.showNext(reportView)

app.header.height = navBar.maxY
app.header.on "change:height", -> app.header.height = navBar.maxY

alertsIcon.onTap -> app.showNext(changesView)

# Anchor back links back to link in scroll
# Show overview link in nav
# Fix fonts
# fix too many unseen alerts in changes vbiew

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

alerts = _.map _.range(12), (c) ->
	
	alert = new Alert
		seen: lastDate < lastChecked
		date: lastDate
		month: lastDate.getMonth() % 12
		thisMonth: lastDate.getMonth() is today.getMonth()
		content: _.sample(contents)
		meaning: lorem
		cta1: "This doesn't look right."
		cta2: "Why is this not part of my Report?"
		type: 'changed'
	
	lastDate = new Date(lastDate.getTime() - _.random(14,30) * dayLength)
	
	return alert

futureDate = new Date(today.getTime() + 30 * dayLength)
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

# Alert Tile

octSeen = false

class AlertTile extends Layer
	constructor: (options = {}) ->
		
		_.assign options, 
			name: 'Alert Tile'
			backgroundColor: null
		
		
		@alert = options.alert
		@date = @alert?.date ? options.date
		
		if @date <= new Date('11/1/17')
			@alert = undefined
				
		if not HAS_UPCOMING_CHANGES
			if @alert?.date is futureDate
				@noUpcoming = true
				@alert = undefined
		
		super options
		
		@date = new cs.Text 
			type: 'body1'
			parent: @
			text: @date.toLocaleDateString([], {month: 'long', year: 'numeric'})
		
		@tile = new Layer
			parent: @
			y: @date.maxY + 8
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
		# Nav Bar
		
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
		
		welcome2 = new cs.Text 
			name: 'subwelcome'
			parent: @content 
			type: 'body1'
			text: 'We can predict your Feb score too'
			y: welcome1.maxY
			x: Align.center()
			width: @width
			textAlign: 'center'
		
		#donuts 
		
		currentScore = new cs.Text 
			name: 'currentScore'
			parent: @content 
			type: 'body'
			text: 'Your current score'
			y: welcome2.maxY + 32
		
		monthdesc = new cs.Text
			type: 'body1'
			name: 'month1'
			parent: @content 
			text: 'January 2017'
			y: currentScore.maxY + 8
			
		month = new cs.Donut
			size: 'small'
			parent: @content 
			y: monthdesc.maxY + 16
			x: 40
			value: 354
			color: 'secondary'
			stroke: 'secondary'
		
		Utils.align([currentScore, monthdesc], 'midX', month.midX)
		
		predicatedStore = new cs.Text 
			name: 'currentScore'
			parent: @content 
			type: 'body'
			text: 'Your predicted score'
			y: welcome2.maxY + 32
		
		monthdesc = new cs.Text 
			type: 'body1'
			name: 'month1'
			parent: @content 
			text: 'February 2018'
			y: predicatedStore.maxY + 8
			
		month = new cs.Donut
			size: 'small'
			parent: @content 
			y: monthdesc.maxY + 16
			x: Align.right(-40)
			value: 370
			color: 'primary'
			stroke: 'primary'
		
		Utils.align([predicatedStore, monthdesc], 'midX', month.midX)
		
		dot = new NewDot
			parent: monthdesc
			x: Align.right(16)
			backgroundColor: '#4a90e2'
		
		# ______________________________
		# Report Updates
		
		# title info 
		
		title = new cs.H2
			parent: @content
			text: 'Report Updates'
			width: @width - 32
			x: 16
			y: month.maxY + 64
		
		sep = new cs.Divider
			parent: @content
			x: title.x
			y: title.maxY + 8
			width: @width - 32
			
		@updatesCount = new cs.Text
			parent: @content
			type: 'body1'
			x: Align.right(-16)
			y: title.y + 8
			text: '{result}'
			textAlign: 'right'
			
		@updatesCountDot = new NewDot
			parent: @updatesCount
		
		# new alerts
		
		newAlerts = _.filter(@alerts, ['seen', false]).length
		Utils.define @, "updates", newAlerts, @setUpdateCount
		
		# scroll 
		
		@alertsScroll = new ScrollComponent
			parent: @content 
			propagateEvents: false
			y: sep.maxY + 32
			width: @width
			scrollHorizontal: true
			scrollVertical: false
			contentInset:
				left: 16
				right: 16
		
		@alertTiles = @alerts.map (alert) =>
			if not alert
				return new AlertTile
					parent: @alertsScroll.content 
					date: new Date("9/1/17")
					alert: null
				return
			
			return new AlertTile
				parent: @alertsScroll.content
				date: alert.date
				alert: alert
		
		# spread tiles
		
		for tile, i in _.sortBy(@alertTiles, 'month')
			tile.x = (last ? 0) + 8
			last = tile.maxX
			
		@alertsScroll.updateContent()
		
		firstUnseen = _.find(@alertTiles, (t) -> t.alert?.seen is false)
		
		@alertsScroll.scrollToLayer(
			firstUnseen,
			0, 0
			false
			)
		
		
		# ______________________________
		# Personal Information (dummy)
		
		title = new cs.H2
			parent: @content
			text: 'Personal Information'
			x: 16
			y: @alertsScroll.maxY + 32
			width: @width - 32
		
		sep = new cs.Divider
			parent: @content
			x: title.x
			y: title.maxY + 8
			width: @width - 32
		
		etc = new cs.Text 
			parent: @content 
			text: "..."
			y: sep.maxY + 16
			x: 16
			
		pair = (title, content, y) =>
			titleLayer = new cs.H4
				parent: @content
				x: 16
				y: y
				text: title
				
			contentLayer = new cs.Text
				parent: @content
				x: 16
				y: titleLayer.maxY + 4
				text: content
			
			return contentLayer
				
		name = pair('Name', 'Kimberly Wood', sep.maxY + 16)
		dob = pair('Date of birth', '25 January 1981', name.maxY + 16)
		address = pair('Current address', '50 Regents Street, London SL1 6AH', dob.maxY + 16)
			
	
	setUpdateCount: (num) =>
		text = "#{num} new update"
		if num > 1 then text += 's'
		maxX = @updatesCount
		@updatesCount.template = text
		@updatesCount.visible = num > 0
		@updatesCount.x = Align.right(-16)

# Changes View

class ChangesView extends cs.View
	constructor: (options = {}) ->
		
		_.defaults options,
			alerts: alerts
# 			showLayers: true
			contentInset:
				top: 24
				bottom: 48
		
		_.assign @,
			alerts: _.sortBy(options.alerts, 'date').slice().reverse()
		
		super
		
		@backgroundColor = "#FFF"
		@content.backgroundColor = "#FFF"
		
		# ______________________________
		# Nav Bar
		
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
			y: welcome1.maxY + 8
			x: Align.center()
			textAlign: 'center'
		
		@upcomingChangesCountDot = new NewDot
			parent: @upcomingChangesCount
			x: Align.right(16)
			backgroundColor: '#fd7d6a'
			
		@updatesCount = new cs.Text 
			name: 'Upcoming Changes'
			parent: @content 
			text: ' '
			color: 'secondary'
			y: @upcomingChangesCount.maxY
			x: Align.center()
			textAlign: 'center'
		
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
			x: Align.center()
			width: @width
			textAlign: 'center'
			visible: false
		
		@setChangesCounts()
		
		start = @updatesCount.maxY
		
		# ______________________________
		# Donuts 
		
		if options.donuts
			monthdesc = new cs.Text 
				type: 'body1'
				name: 'month1'
				parent: @content 
				text: 'January 2018'
				y: @updatesCount.maxY + 32
				
			month = new cs.Donut
				size: 'small'
				parent: @content 
				y: monthdesc.maxY + 16
				x: 40
				value: 354
				color: 'secondary'
				stroke: 'secondary'
				
			monthdesc.midX = month.midX
			
			monthdesc = new cs.Text 
				type: 'body1'
				name: 'month1'
				parent: @content 
				text: 'February 2018'
				y: @updatesCount.maxY + 32
				
			month = new cs.Donut
				size: 'small'
				parent: @content 
				y: monthdesc.maxY + 16
				x: Align.right(-40)
				value: 370
				color: 'primary'
				stroke: 'primary'
				
			monthdesc.midX = month.midX
		
			dot = new NewDot
				parent: monthdesc
				x: Align.right(16)
				backgroundColor: '#fd7d6a'
		
			start = month.maxY
		
		# ______________________________
		# Changes
		
		month = @alerts[0].date.getMonth()
		
		for alert, i in @alerts
			a = new ChangeEntry alert,
				parent: @content
				y: start + 48
				x: 16
				width: @width - 32
				backgroundColor: null
				
			start = a.maxY
			
			if alert.date.getMonth() isnt month
				div = new cs.Divider 
					parent: @content
					y: start + 48
					x: 16
					width: @width - 32
					height: 1
				
				c = new Layer
					parent: @content 
					backgroundColor: '#FFF'
					height: 32
					width: 72
					x: Align.right()
					midY: div.y
					
				score = new cs.Text 
					parent: c 
					color: '#AAA'
					text: _.random(300, 400)
					type: 'body'
					x: Align.right(-16)
					y: Align.center()
				
				start = div.maxY
		
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
		
		text = "You have #{stale} new upcoming change"
		if stale > 1 then text += 's'
		@updatesCount.text = text
		@updatesCount.visible = stale > 0
		@updatesCount.x = Align.center()
		@updatesCountDot.x = Align.right(16)


reportView = new Report
changesView = new ChangesView {donuts: true}

# app.showNext(new DetailView {alert: new Alert})
app.showNext(reportView)


	
newDot = new NewDot
	parent: alertsIcon
	x: 30
	y: 16