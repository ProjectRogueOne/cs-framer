# Mobile Typography
# Authors: Steve Ruiz
# Last Edited: 21 Sep 17

# Type
Mobile = require 'Mobile'
Standard = require 'Standard'

{ Page } = require 'Page'
{ Icon } = require 'Icon'
{ Checkbox } = require 'Checkbox'
{ Divider } = require 'Divider'
{ Switch } = require 'Switch'
{ Colors } = require 'Colors'
{ Button } = require 'Button'
{ Text } = require 'Text'
{ TextField } = require 'TextField'
{ StackView } = require 'StackView'

exports.Page = Page
exports.Icon = Icon
exports.Checkbox = Checkbox
exports.Divider = Divider
exports.Switch = Switch
exports.Colors = Colors
exports.Button = Button
exports.Text = Text
exports.TextField = TextField
exports.StackView = StackView

# Set context to mobile or standard
exports.Context = Context =
	value: 'standard'

	setMobile: ->
		exports.H1 = Mobile.H1
		exports.H2 = Mobile.H2
		exports.H3 = Mobile.H3
		exports.H4 = Mobile.H4
		exports.Small = Mobile.Small
		exports.SmallBold = Mobile.SmallBold
		exports.Medium = Mobile.Medium
		exports.MediumBold = Mobile.MediumBold
		exports.Large = Mobile.Large
		exports.LargeBold = Mobile.LargeBold
		exports.Link = Mobile.Link
		exports.DonutNumber = Mobile.DonutNumber
		exports.PageNumber = Mobile.PageNumber
		exports.DashboardScore = Mobile.DashboardScore
		exports.DashboardNumber = Mobile.DashboardNumber

	setStandard: ->
		exports.H1 = Standard.H1
		exports.H2 = Standard.H2
		exports.H3 = Standard.H3
		exports.H4 = Standard.H4
		exports.Small = Standard.Small
		exports.SmallBold = Standard.SmallBold
		exports.Medium = Standard.Medium
		exports.MediumBold = Standard.MediumBold
		exports.Large = Standard.Large
		exports.LargeBold = Standard.LargeBold
		exports.Link = Standard.Link
		exports.DonutNumber = Standard.DonutNumber
		exports.PageNumber = Standard.PageNumber
		exports.DashboardScore = Standard.DashboardScore
		exports.DashboardNumber = Standard.DashboardNumber

Context.setStandard()
