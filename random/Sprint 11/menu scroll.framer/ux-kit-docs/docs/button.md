# Button

A button is a clickable container with a label.

## Type

Buttons have four types: small, medium, large and auto.

```coffeescript
smallButton = new cs.Button
	size: 'small'

medButton = new cs.Button
	size: 'medium'

largeButton = new cs.Button
	size: 'large'

largeButton = new cs.Button
	size: 'auto'
```

By default, a button's size is `'medium'`. An `auto` sized Button will adjust its size based on the width of its text label.

## Text

Buttons may have text labels.

```coffeescript
button = new cs.Button
	text: 'Hello World!'
	color: 'white'
```

To make a blank button, set `text` to `''`.

```coffeescript
button = new cs.Button
	text: ''
	color: 'white'
```

By default, a button's text is `'Button'`. 

## Color

The color property sets the [color](colors.md) of a button's text label.

```coffeescript
button = new cs.Button
	text: 'Hello World!'
	color: 'white'
```

By default, a button's color is `'black`. See the [text](text.md) page for more about text colors.

## Type

The type property sets the [type](text.md) of a button's text label. 

```coffeescript
button = new cs.Button
	x: Align.center
	y: Align.center
	size: 'auto'
	fill: 'todo'
	border: 'secondary'
```

By default, a button's text type is `'button'`.

## Fill

Buttons may have any [valid color](colors.md) as its fill.

```coffeescript
primaryButton = new cs.Button
	fill: 'primary'

warnButton = new cs.Button
	fill: 'primary'
```

By default, a button's fill is `'primary'`.

## Border

Buttons may have any [valid color](colors.md) as its border.

```coffeescript
primaryButton = new cs.Button
	fill: 'primary'

warnButton = new cs.Button
	fill: 'primary'
```

By default, a button has no border.

## Disabled

A button may be disabled. A disabled button won't run its action when tapped.

```coffeescript
myButton1 = new cs.Button
	fill: 'primary'
	disabled: true

myButton2 = new cs.Button
	fill: 'primary'

myButton2.disabled = true
```

By default, a button is not disabled.