# helpers

# binds the function to the target, for sanity's sake
Utils.build = (target, func) ->
	do _.bind(func, target)
	
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
		
Utils.scaleToWidth = (layer, width = 400) ->
	h = layer.height * (width / layer.width)
	_.assign layer,
		width: width
		height: h

Utils.scaleToHeight = (layer, height = 400) ->
	w = layer.width * (height / layer.height)
	_.assign layer,
		width: w
		height: height

# background

lizzie_254525 = new Layer
	width: 3456
	height: 5184
	image: "images/lizzie-254525.jpg"
	brightness: 50

Utils.scaleToHeight lizzie_254525, Screen.height + 420

lizzie_254525.x = Align.center()

# slider

unlockTrack = new Layer
	height: 64
	width: Screen.width - 96
	borderRadius: 64
	backgroundColor: 'rgba(0,0,0,.5)'
	y: Align.bottom(-32)
	x: Align.center()
	knobSize: 60
	min: 0
	max: 1

unlock = new SliderComponent
	height: 64
	width: Screen.width - 160
	borderRadius: 64
	backgroundColor: null
	y: Align.bottom(-32)
	x: Align.center()
	knobSize: 60
	min: 0
	max: 1

unlock.fill.backgroundColor = null

unlock.knob.onDragEnd (event, layer) ->
	value = unlock.value
	unlock.animateToValue Math.round(value)

# title

title = new TextLayer
	x: Align.center()
	y: 160
	color: 'rgba(255, 255, 255, .9)'
	text: 'Welcome'
	fontFamily: 'Helvetica Neue'
	fontSize: 48
	brightness: 70

# modulate

unlock.on "change:value", ->
	
	lizzie_254525.brightness = Utils.modulate(unlock.value, [0, 1], [50, 90])
	lizzie_254525.y = Utils.modulate(unlock.value, [0, 1], [0, -64])
	
	title.y = Utils.modulate(unlock.value, [0, 1], [160, 72])
	title.brightness = Utils.modulate(unlock.value, [0, 1], [70, 100])