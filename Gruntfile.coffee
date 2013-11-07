fs = require 'fs'

connect_middleware = require './middleware-connect.coffee'

module.exports = (grunt) ->

	##############
	### CONFIG ###
	##############

	grunt.initConfig

		### SHELL ###

		shell:
			options:
				stdout: true
				stderr: true
			emptycompiled:
				command:
					'rm -rf compiled/*'
			bowerinstall:
				command: 'bower install'

		### SERVER ###	

		connect:
			keepalive:
				options:
					port: 9000
					base: 'compiled'
					middleware: connect_middleware
					keepalive: true
			compiled:
				options:
					port: 9000
					base: 'compiled'
					middleware: connect_middleware

		### HTML ###
		
		jade:
			compile:
				files: [
					expand: true
					cwd: 'src/jade'
					src: '**/*.jade'
					dest: 'compiled/html'
					rename: (dest, src) -> 
						dest + '/' + src.replace(/.jade/, '.html')
				,
					'compiled/index.html': 'src/index.jade'
				]

		### CSS ###

		stylus:
			compile:
				options:
					paths: ['src/stylus/import']
					import: ['variables', 'functions']
				files:
					'compiled/css/project.css': [
						'src/stylus/**/*.styl'
						'!src/stylus/import/*.styl'
					]

		concat:
			css:
				src: [
					'compiled/lib/normalize-css/normalize.css'
					'compiled/css/project.css'
				]
				dest:
					'compiled/css/main.css'

		### JS ###

		coffee:
			compile:
				files: [
					expand: true
					cwd: 'src/coffee'
					src: '**/*.coffee'
					dest: 'compiled/js'
					rename: (dest, src) -> 
						dest + '/' + src.replace(/.coffee/, '.js')
				]

		### WATCH ###

		watch:
			options:
				livereload: true
				nospawn: true
			coffee:
				files: 'src/coffee/**/*.coffee'
				tasks: 'coffee:compile'
			jade:
				files: ['src/index.jade', 'src/jade/**/*.jade']
				tasks: 'jade:compile'
			stylus:
				files: ['src/stylus/**/*.styl']
				tasks: ['stylus:compile', 'concat:css']

	#############
	### TASKS ###
	#############

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-stylus'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-shell'

	grunt.registerTask('default', ['sw']);

	# Server
	grunt.registerTask 's', ['connect:keepalive']

	# Watch
	grunt.registerTask 'w', ['watch']

	# Server and watch
	grunt.registerTask 'sw', [
		'connect:compiled'
		'watch'
	]

	# Compile
	grunt.registerTask 'compile', [
		'shell:emptycompiled'
		'shell:bowerinstall'
		'coffee:compile'
		'jade:compile'
		'stylus:compile'
		'concat:css'
	]