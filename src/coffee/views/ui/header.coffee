define (require) ->
	Templates =
		Header: require 'text!html/ui/header.html'

	class Header extends Backbone.View

		tagName: 'header'

		initialize: ->
			super

			@render()

		render: ->
			rtpl = _.template Templates.Header
			@$el.html rtpl

			@