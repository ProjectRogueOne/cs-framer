cs = require 'cs'
cs.Context.setMobile()

CHANGES = true


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
		height: 112
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
		height: 64
		y: puller.maxY
		backgroundColor: '#CCC'
		
	youCouldSave = new cs.Text
		parent: savings
		x: Align.center, y: Align.center
		width: @width
		textAlign: 'center'
		type: 'body'
		text: "You could save £{value} per year"
	
	# slider 1
	
	@addToStack currentScore = new Layer
		width: @width
		height: 114
		backgroundColor: '#efefef'
	
	yourCurrentScore = new cs.Text
		parent: currentScore
		text: "Your Current Score"
		type: 'subheader'
		x: 16, y: 24
	
	yourCurrentScoreResult = new cs.Text
		parent: currentScore
		text: "0"
		type: 'button'
		textAlign: 'right'
		width: 100
		x: Align.right(-16), y: 24
	yourCurrentScoreResult.fontSize = 24
	
	yourCurrentSlider = new SliderComponent
		parent: currentScore
		x: 16, y: yourCurrentScore.maxY + 16
		height: 4
		width: @width - 32
		min: 0
		max: 700
		value: 300
	
	yourCurrentSlider.knob.draggable.propagateEvents = false
	
	yourCurrentSliderMin = new cs.Text
		parent: currentScore
		x: 16, y: yourCurrentSlider.maxY + 8
		text: yourCurrentSlider.min
		type: 'body'
	
	yourCurrentSliderMin = new cs.Text
		parent: currentScore
		x: Align.right(-16), y: yourCurrentSlider.maxY + 8
		text: yourCurrentSlider.max
		type: 'body'

	# slider 2
	
	@addToStack goalScore = new Layer
		width: @width
		height: 118
		backgroundColor: '#efefef'
	
	yourGoalScore = new cs.Text
		parent: goalScore
		text: "Your Score Goal"
		type: 'subheader'
		x: 16, y: 16
	
	yourGoalScoreResult = new cs.Text
		parent: goalScore
		type: 'button'
		text: "0"
		textAlign: 'right'
		width: 100
		x: Align.right(-16), y: 16
	yourGoalScoreResult.fontSize = 24
	
	yourGoalSlider = new SliderComponent
		parent: goalScore
		x: 16, y: yourGoalScore.maxY + 16
		height: 4
		width: @width - 32
		min: 0
		max: 700
		value: 300
	
	yourGoalSlider.knob.draggable.propagateEvents = false
	
	yourGoalSliderMin = new cs.Text
		parent: goalScore
		x: 16, y: yourGoalSlider.maxY + 8
		text: yourGoalSlider.min
		type: 'body'
	
	yourGoalSliderMin = new cs.Text
		parent: goalScore
		x: Align.right(-16), y: yourGoalSlider.maxY + 8
		text: yourGoalSlider.max
		type: 'body'
	
	
	# - table
	
	@addToStack table = new Layer
		width: @width
		height: 150
		backgroundColor: '#efefef'
		
	current = new cs.Text
		parent: table
		x: Align.right(-80)
		text: 'Current'
		textAlign: 'center'
		width: 64
	
	goal = new cs.Text
		parent: table
		x: Align.right(-16)
		text: 'Goal'
		textAlign: 'center'
		width: 64
	
	# avg interest rate
	
	avgInterestRate = new cs.Text 
		parent: table
		x: 32, y: 32
		text: "Average interest rate"
		
	avgCurrent = new cs.Text
		parent: table
		x: Align.right(-80)
		y: 32
		text: '{value}%'
		textAlign: 'center'
		width: 64
	
	avgGoal = new cs.Text
		parent: table
		x: Align.right(-16)
		y: 32
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
		
		yourCurrentScoreResult.text = yourCurrentSlider.value.toFixed()
		yourGoalScoreResult.text = yourGoalSlider.value.toFixed()
		
		avgCurrent.template = (60 - (yourCurrentSlider.value / 13)).toFixed(1)
		avgGoal.template = (60 - (yourGoalSlider.value / 13)).toFixed(1)
		
		cCost = (2000 - (yourCurrentSlider.value * 1.42))
		gCost = (2000 - (yourGoalSlider.value * 1.42))
		
		costCurrent.template = cCost.toFixed()
		costGoal.template = gCost.toFixed()
		
		youCouldSave.template = if CHANGES
				_.clamp((cCost - gCost).toFixed(), 0, Infinity)
			else
				(cCost - gCost).toFixed()
			
		cardsCurrent.template = (yourCurrentSlider.value / 10).toFixed()
		cardsGoal.template = (yourGoalSlider.value / 10).toFixed()
	
	setGoal = ->
		yourGoalSlider.value = _.clamp(
			yourGoalSlider.value, 
			yourCurrentSlider.value, 
			yourGoalSlider.max)
			
		yourGoalSlider.min = yourCurrentSlider.value
		
	
	# Events
	
# 	if CHANGES
# 		yourCurrentSlider.on "change:value", setGoal
# 		
	yourCurrentSlider.on "change:value", setValues
	yourGoalSlider.on "change:value", setValues
	
	setValues()