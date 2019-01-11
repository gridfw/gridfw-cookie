###*
 * Cookie parser for GridFW
 * @copyright khalid RAFIK 2018
###
'use strict'

cookie = require 'cookie'
signature = require 'cookie-signature'
sign = signature.sign

#=include _set-cookie.coffee
#=include _parse-cookies.coffee

# reload
_parseCookies = null
module.exports=
	name: 'cookie-parser'
	# init/reload the plugin
	reload: (app, settings)->
		settings ?= Object.create null
		# secret
		_secret = settings.secret
		if _secret
			_secret = [_secret] unless Array.isArray _secret
			for s in _secret
				throw new Error '"settings.secret" must be either string or list or strings' unless typeof s is 'string'
		# cookie parser
		_parseCookies = createCookieParser settings
		# enable
		@enable app
		return
	# disable the plugin
	# disable: (app)->
	# 	app.info 'cookie-parser', 'This plugin could not be disabled'
	# enable the plugin
	enable: (app)->
		# Context plugins
		Object.defineProperties app.Context.prototype,
			# get cookies
			cookies:
				get: _parseCookies
				configurable: on
			signedCookies:
				get: _parseCookies
				configurable: on
			# set cookie
			cookie:
				value: setCookie
				configurable: on
			clearCookie:
				value: clearCookie
				configurable: on
		# Request
		Object.defineProperties app.Request.prototype,
			cookies:
				get: _parseCookies
				configurable: on
			signedCookies:
				get: _parseCookies
				configurable: on
		return