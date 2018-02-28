# set a new property on Layer

Object.defineProperty(Layer.prototype, "direction", {
	get: -> return @_direction
	set: (value) -> 
		@_direction = value
		
		@emit "change:direction", value
})

Layer.prototype.addEventListener('mouseover', => print 'hi')


# create a new layer

anyLayer = new Layer


# set a listener on anyLayer

anyLayer.on "change:direction", (value) ->
	if value is 'up' then @animate { rotation: 0 }
	else if value is 'down' then @animate { rotation: 90 }


# set property on anyLayer

Utils.delay 2, -> anyLayer.direction = 'down'

Utils.delay 4, -> anyLayer.direction = 'up'