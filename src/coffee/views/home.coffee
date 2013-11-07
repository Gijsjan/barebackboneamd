define (require) ->

	Templates =
		Home: require 'text!html/home.html'

	class Home extends Backbone.View

		initialize: ->
			super

			@render()

		render: ->
			rtpl = _.template Templates.Home
			@$el.html rtpl

			@