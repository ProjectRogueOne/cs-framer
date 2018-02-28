# Mobile Typography
# Authors: Steve Ruiz
# Last Edited: 21 Sep 17

# App

# class
App = require 'App'
exports.App = App.App
exports.app = App.app

Utils.insertCSS("""
	
	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 200;
		src: url('fonts/AktivGrotesk_Hair.ttf'); 
	}

	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 300;
		src: url('fonts/AktivGrotesk_Lt.ttf'); 
	}

	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 400;
		src: url('fonts/AktivGrotesk_Rg.ttf'); 
	}

	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 500;
		src: url('fonts/AktivGrotesk_Md.ttf'); 
	}

	@font-face {
		font-family: 'Aktiv Grotesk';
		font-weight: 600;
		src: url('fonts/AktivGrotesk_Bd.ttf'); 
	}
	""")

# UX Kit Components

# -

# Colors
{ Colors } = require 'Colors'
exports.Colors = Colors

# Text
{ Text } = require 'Text'
exports.Text = Text

# Icon
{ Icon } = require 'Icon'
exports.Icon = Icon

# Logo
{ Logo } = require 'Logo'
exports.Logo = Logo

# Container
{ Container } = require 'Container'
exports.Container = Container

# Divider
{ Divider } = require 'Divider'
exports.Divider = Divider

# -

# Stackview
{ StackView } = require 'StackView'
exports.StackView = StackView

# View
{ View } = require 'View'
exports.View = View

# -

# Checkbox
{ Checkbox } = require 'Checkbox'
exports.Checkbox = Checkbox

# Radiobox
{ Radiobox } = require 'Radiobox'
exports.Radiobox = Radiobox

# Button
{ Button } = require 'Button'
exports.Button = Button

# Switch
{ Switch } = require 'Switch'
exports.Switch = Switch

# Toggle
{ Toggle } = require 'Toggle'
exports.Toggle = Toggle

# Field
{ Field } = require 'Field'
exports.Field = Field


# - Page Elements

# Overlay
{ Overlay } = require 'Overlay'
exports.Overlay = Overlay

# Puller
{ Puller } = require 'Puller'
exports.Puller = Puller

# Progress 
{ Progress } = require 'Progress'
exports.Progress = Progress


# - App Headers

# generic bar
{ MobileHeader } = require 'MobileHeader'
exports.MobileHeader = MobileHeader

# ios safari bar
{ SafariBar } = require 'SafariBar'
exports.SafariBar = SafariBar

# ios navigation bar
{ IOSBar } = require 'IOSBar'
exports.IOSBar = IOSBar

# android header bar
{ AndroidBar } = require 'AndroidBar'
exports.AndroidBar = AndroidBar


# - Navigation

# Navigation 
{ Navigation } = require 'Navigation'
exports.Navigation = Navigation

# Subnav 
{ Subnav } = require 'Subnav'
exports.Subnav = Subnav

# - Type

Mobile = require 'Mobile'
Standard = require 'Standard'

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
