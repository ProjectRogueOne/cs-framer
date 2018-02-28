cs = require 'cs'
cs.Context.setMobile()

CHANGES = false


# ---------------------------------
# app

app = new cs.App
	type: 'safari'

app.navigation = undefined

savingsView = new cs.View 
	padding: {}
	
savingsView.build ->
	
	@addToStack puller = new Layer
		width: @width
		height: 100
		backgroundColor: '#FFF'
	
	title = new cs.Text
		parent: puller
		x: 16, y: 16
		type: 'body'
		text: "Savings Calculator"
		
	description = new cs.Text
		parent: puller
		x: 16, y: title.maxY + 8
		type: 'body1'
		text: "Lenders reserve their best rates..."
		
	@addToStack savings = new Layer
		width: @width
		height: 80
		y: puller.maxY
		backgroundColor: '#CCC'
		
	youCouldSave = new cs.Text
		parent: savings
		x: Align.center, y: Align.center
		width: @width
		textAlign: 'center'
		type: 'body'
		text: "You could save £{value} per year"
	
	# slider
	
	@addToStack yourScore = new Layer
		width: @width
		height: 144
		backgroundColor: '#efefef'
	
	yourCurrentLabel = new cs.Text
		parent: yourScore
		type: 'body1'
		text: "Current"
		x: Align.center(-64), y: 24
		
	yourGoalLabel = new cs.Text
		parent: yourScore
		type: 'subheader'
		text: "Goal"
		x: Align.center(64), y: 24
		
	yourCurrentScore = new cs.Text
		parent: yourScore
		type: 'button'
		text: "{value}"
		width: 80
		textAlign: "center"
		x: Align.center(-64), y: 48
	yourCurrentScore.fontSize = 24
		
	yourGoalScore = new cs.Text
		parent: yourScore
		text: "{value}"
		type: 'button'
		width: 80
		textAlign: "center"
		x: Align.center(64), y: 48
	yourGoalScore.fontSize = 24
	
	yourScoreSlider = new RangeSliderComponent
		parent: yourScore
		x: 32, y: 96
		width: @width - 64
		min: 0
		max: 700
		minValue: 300
		maxValue: 700
	
	yourScoreSlider.maxKnob.borderRadius = 999
	yourScoreSlider.minKnob.draggable.propagateEvents = false
	yourScoreSlider.maxKnob.draggable.propagateEvents = false

	yourCurrentSliderMin = new cs.Text
		parent: yourScore
		x: 32, y: yourScoreSlider.maxY + 16
		text: yourScoreSlider.min
	
	yourCurrentSliderMax = new cs.Text
		parent: yourScore
		x: Align.right(-24), y: yourScoreSlider.maxY + 16
		text: yourScoreSlider.max	
	
	# - table
	
	@addToStack table = new Layer
		width: @width
		height: 160
		backgroundColor: '#efefef'
		
	current = new cs.Text
		parent: table
		y: 16
		x: Align.right(-80)
		text: 'Current'
		textAlign: 'center'
		width: 64
	
	goal = new cs.Text
		parent: table
		y: 16
		x: Align.right(-16)
		text: 'Goal'
		textAlign: 'center'
		width: 64
	
	# avg interest rate
	
	avgInterestRate = new cs.Text 
		parent: table
		x: 32
		y: 48
		text: "Average interest rate"
		
	avgCurrent = new cs.Text
		parent: table
		x: Align.right(-80)
		y: 48
		text: '{value}%'
		textAlign: 'center'
		width: 64
	
	avgGoal = new cs.Text
		parent: table
		x: Align.right(-16)
		y: 48
		text: '{value}%'
		textAlign: 'center'
		width: 64			
		
	new cs.Divider
		parent: table
		x: 32
		y: avgInterestRate.maxY + 8
		width: @width - 64
		
	# annual cost
	
	annualCost = new cs.Text 
		parent: table
		x: 32, y: avgInterestRate.maxY + 16
		text: "Annual cost"
		
	costCurrent = new cs.Text
		parent: table
		x: Align.right(-80)
		y: avgInterestRate.maxY + 16
		text: '£{value}'
		textAlign: 'center'
		width: 64
	
	costGoal = new cs.Text
		parent: table
		x: Align.right(-16)
		y: avgInterestRate.maxY + 16
		text: '£{value}'
		textAlign: 'center'
		width: 64
		
	# cards
	
	new cs.Divider
		parent: table
		x: 32
		y: annualCost.maxY + 8
		width: @width - 64
	
	avgInterestRate = new cs.Text 
		parent: table
		x: 32, y: annualCost.maxY + 16
		text: "Credit cards available"
		
	cardsCurrent = new cs.Text
		parent: table
		x: Align.right(-80)
		y: annualCost.maxY + 16
		text: '{value}'
		textAlign: 'center'
		width: 64
	
	cardsGoal = new cs.Text
		parent: table
		x: Align.right(-16)
		y: annualCost.maxY + 16
		text: '{value}'
		textAlign: 'center'
		width: 64
	
	@addToStack assumptions = new cs.Accordian
		width: @width
		title: "*Assumptions"
	
	assumptionDetails = new cs.Text 
		type: 'body1'
		parent: assumptions
		x: 16, y: 66
		text: "*The savings calculator assumes..."
		
	
	
	setValues = ->
		
		
# 		yourCurrentLabel.midX = yourScoreSlider.minKnob.midX + 38
# 		yourCurrentScore.midX = yourScoreSlider.minKnob.midX + 38
		yourCurrentScore.template = yourScoreSlider.minValue.toFixed()
		
# 		yourGoalLabel.midX = yourScoreSlider.maxKnob.midX + 38
# 		yourGoalScore.midX = yourScoreSlider.maxKnob.midX + 38
		yourGoalScore.template = yourScoreSlider.maxValue.toFixed()
		
		avgCurrent.template = (60 -
			(yourScoreSlider.minValue / 13)).toFixed(1)
			
		avgGoal.template = (60 -
			(yourScoreSlider.maxValue / 13)).toFixed(1)
		
		cCost = (2000 - (yourScoreSlider.minValue * 1.42))
		gCost = (2000 - (yourScoreSlider.maxValue * 1.42))
		
		costCurrent.template = cCost.toFixed()
		costGoal.template = gCost.toFixed()
		
		youCouldSave.template = (cCost - gCost).toFixed()
		
		cardsCurrent.template = (yourScoreSlider.minValue / 10).toFixed()
		cardsGoal.template = (yourScoreSlider.maxValue / 10).toFixed()
	
	setGoal = ->
			
		yourGoalSlider.min = yourCurrentSlider.value
		yourGoalSlider.animateToValue(yourGoalSlider.value)
		yourGoalSliderMin.text = yourCurrentSlider.value.toFixed()
	
	# Events
	
	yourScoreSlider.onMinValueChange setValues
	yourScoreSlider.onMaxValueChange setValues
	
	setValues()