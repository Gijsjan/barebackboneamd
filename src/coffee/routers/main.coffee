define (require) ->
	Backbone = require 'backbone'
	currentUser = require 'models/currentUser'

	Views =
		Home: require 'views/home'

	class MainRouter extends Backbone.Router

		'routes':
			'': 'home'

		home: ->
			main = document.getElementById('main')
			main.innerHTML = ''
			main.appendChild new Views.Home().el