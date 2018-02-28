# Structuring Classes in Framer

Introduction to how classes are used in framer - boiling down to the abstract things that the project involves, then creating classes for the things that will appear as instances.

Most classes will extend Layer.

A good class is legible, easily changed, and loosely coupled. In a perfect world, our classes wouldn't rely on other classes to work; in the real world, things tend to work together.

Here's the absolute minimum for extending a Layer. It will look, act, and behave exactly like Layer. At this stage, the only difference is the name used to create the instance.

```coffeescript

class Card extends Layer
	constructor: (options = {}) ->
		super options


myCard = new Card
```

## The Master Template

Here's our actual starting point.

```coffeescript

class Card extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		# Private Properties:

		# Assigned options:

		# Default options:

		super options 

		# Layers:

		# Events:

		# Kickoff:

		delete @__constructor
		
	# Class methods:

	# Definitions:
```

## Making a Card Class

For our example project, let's make some cards.

For us, a card is a rectangular layer with a specific shape, border radius, and shadow. While these values must be the same for every card, other values, like the card's background color, might differ between instances. By default, we want a card's background color to be white.

Each card will have a "star", a layer that changes its color to show whether the card is "starred" or "not starred". Users can tap the star to toggle the card between the two conditions. We also need to be able to set this property through the options when we're creating a card. We also want to use this property elsewhere in the project, so we need a way to know whether the card is starred or not.

## The Class

With those ideas in mind, here is our class:

```coffeescript

class Card extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		#-  Private properties:

		@_starred
		options.starred ?= false

		#-  Assigned options:

		_.assign options,
			width: 240
			height: 320
			borderRadius: 16
			shadowY: 1
			shadowBlur: 3

		#-  Default options:

		_.defaults options,
			name: 'Card'
			backgroundColor: '#FFF'
		
		super options

		#- Layers:

		@starLayer = new Layer
			parent: @
			x: Align.right(-16)
			y: 16
			width: 24
			height: 24
			borderRadius: 12

		#- Events:

		@on "change:starred", @toggleStar

		@starLayer.onTap => @starred = !@starred

		#-  Kickoff:

		delete @__constructor

		@starred = options.starred

	#-  Class methods:

	toggleStar: =>
		if @starred
			@starLayer.backgroundColor = "orange"
			return

		@starLayer.backgroundColor = "grey"

	#-  Definitions:

	@define "starred",
		get: -> return @_starred
		set: (value) ->
			return if @__constructor

			@_starred = value

			@emit "change:starred", value, @


myCard = new Card

```

## Walkthrough

When we create an instance of Card, a few things happen in order:

First, a new object gets created, myCard. Because it is made using the Card class, we call this object an "instance" of Card. At this point, however, the object is empty: it has no properties or methods yet.

Next, the myCard instance is given copies of all of the methods from our class, Card. In our example, our myCard object now its own copy of `constructor`, `toggleStar`, and that weird `@define "starred"` method.

Finally, the myCard instance runs its `constructor` method. This can happen only once, and it happens automatically, once all the other methods are added to the instance.

Inside of the `constructor` method, a few more things happen. 

Just like Layer, our constructor takes an argument called `options`. When we make a new instance, the properties we define (like `backgroundColor: #FFF`) get passed into the constructor as `options`.

Since our class extends a different class (Layer), we want to run the special `super` method, using our `options` object as an argument. When we do, we pass our `options` object into Layer's constructor method, and our instance will inherit all of the methods and properties from the resulting layer instance.

Before we run `super options`, however, we have a chance to modify our `options` object. We can change it in two ways: by assigning options, whether they already have a value or not, or by setting defaults for options that have no value.

Let's say we create a Card instance with these options:

```coffeescript
myCard = new Card
	name: "My Card"
	height: 600
```

In the constructor, `options` is brought in as `{name: "My Card", height: 600}`. 

 before it gets passed up to Layer.


 the class we're extending. Once we do, we can use methods like `animate` or set event listeners using `on`.




Since our class extends Layer, 





