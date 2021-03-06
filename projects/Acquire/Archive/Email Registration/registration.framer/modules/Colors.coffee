# Colors
# Authors: Steve Ruiz
# Last Edited: 27 Sep 17

exports.Colors =
	main: '#404F5D'
	page: '#EFEFEF'
	lightText: '#FFFFFF'
	pale: '#CCCCCC'
	divider: '#D9D9D9'
	navigation: 'rgba(216, 216, 216, 1)'

	accent: 'rgba(255, 0, 72, 1.000)'
	black: 'rgba(72, 72, 72, 1.000)'
	disabled: 'rgba(229, 229, 229, 1.000)'
	grey: 'rgba(155, 155, 155, 1.000)'
	primary: 'rgba(75, 144, 226, 1.000)'
	secondary: 'rgba(126, 211, 34, 1.000)'
	tertiary: 'rgba(245, 166, 36, 1.000)'
	white: 'rgba(255, 255, 255, 1.000)'
	transparent: 'rgba(255, 255, 255, 0.000)'
	none: 'rgba(255, 255, 255, 0.000)'

	todo: 'rgba(222, 243, 198, 1.000)'
	done: 'rgba(190, 232, 144, 1.000)'
	navigation: 'rgba(229, 229, 229, 1.000)'
	field: 'rgba(153, 153, 153, 1.000)'
	field1: 'rgba(230, 230, 232, 1.000)'
	light: 'rgba(206, 204, 214, 1.000)'
	dark: 'rgba(72, 72, 72, 1.000)'


	validate: (color) ->
		if !_.includes(_.keys(@), color) 
			color = undefined
		else
			color = @[color]

		return color