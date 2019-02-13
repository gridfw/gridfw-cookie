gulp			= require 'gulp'
gutil			= require 'gulp-util'
# minify		= require 'gulp-minify'
include			= require "gulp-include"
uglify			= require('gulp-uglify-es').default
rename			= require "gulp-rename"
coffeescript	= require 'gulp-coffeescript'

GfwCompiler		= require 'gridfw-compiler'

# compile final values (consts to be remplaced at compile time)
# settings
settings=
	mode: gutil.env.mode || 'dev'
	isProd: gutil.env.mode is 'prod'
# handlers
compileCoffee = ->
	glp = gulp.src 'assets/**/[!_]*.coffee', nodir: true
		# include related files
		.pipe include hardFail: true
		# convert to js
		.pipe coffeescript(bare: true).on 'error', GfwCompiler.logError
	# uglify when prod mode
	if gutil.env.mode is 'prod'
		glp = glp.pipe uglify()
	# save 
	glp.pipe gulp.dest 'build'
		.on 'error', GfwCompiler.logError
# watch files
watch = (cb)->
	unless settings.isProd
		gulp.watch ['assets/**/*.coffee'], compileCoffee
	do cb
	return

# default task
gulp.task 'default', gulp.series compileCoffee, watch