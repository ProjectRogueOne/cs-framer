require "gotcha/gotcha"
# Utils.define
# @steveruizok

# The goods:

# Define a property on a layer and (optionally) set it to an initial value
# When the value changes, emit a change event

Utils.define = (layer, property, value) ->
	Object.defineProperty layer,
		property,
		get: -> return layer["_#{property}"]
		set: (value) -> 
			return if value is layer["_#{property}"]
			
			layer["_#{property}"] = value
			layer.emit("change:#{property}", value, layer)
	
	if value?
		layer["_#{property}"] = value


# Implementation:

# create some layers
eye = new Layer
	x: Align.center()
	y: 32
	borderRadius: 100
	
grin = new Layer
	x: Align.center()
	y: eye.maxY + 150
	width: 400
	height: 16
	borderRadius: 32


# give the eye a property 'blinked', with a start value of false
Utils.define eye, "blinked", false


# set a listener for the change:blinked event
eye.on "change:blinked", (isBlinked) ->
	# if blinked...
	if isBlinked
		_.assign @, 
			height: 32
			y: 128
		return
	
	# if not blinked...
	_.assign @, 
		height: 200
		y: 32
		
	grin.animate
		width: 400
		height: 16
		x: (Screen.width - 400) / 2
		options:
			time: .25
		

# poking the eye will make it blink (duh)
eye.onTap ->
	@blinked = true

	grin.animate
		width: 64
		height: 64
		x: (Screen.width - 64) / 2
		options:
			time: .25
	
	Utils.delay _.random(2, 3), =>
		@blinked = false


# but it'll also blink on its own every now and then
Utils.interval .5, ->
	return if Math.random() > 0.15
	
	eye.blinked = true
	Utils.delay .15, =>
		eye.blinked = false