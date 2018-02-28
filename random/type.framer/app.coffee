class Container extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		@_type
		
		_.defaults options,
			type: 'light'
			borderWidth: 1
			
		super options
		
		delete @__constructor
		
		_.assign @,
			type: options.type
	
	setType: ->
		switch @type
			when 'light'
				_.assign @,
					backgroundColor: '#FFF'
					borderColor: '#333'
			
			when 'dark'
				_.assign @,
					backgroundColor: '#333'
					borderColor: '#777'

	@define "type",
		get: -> return @_type
		set: (string) ->
			return if @__constructor
			@_type = string
			
			@setType()

new Container
	type: 'dark'