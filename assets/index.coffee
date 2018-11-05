###*
 * Cookie parser for GridFW
 * @copyright khalid RAFIK 2018
###
'use strict'

cookie = require 'cookie'
signature = require 'cookie-signature'
sign = signature.sign

# get cookie


# reload
module.exports=
	name: 'cookie-parser'
	GridFWVersion: '0.x.x'
	# init plugin
	reload: (app, settings)->
		#=include _parse-cookies.coffee
		#=include _set-cookie.coffee
		# ignore if already has methods
		if app.Context.cookies
			app.info 'Cookie-parser', 'App has already cookie parser set'
			return
		# check options
		settings ?= Object.create null
		# secret
		_secret = settings.secret
		if _secret
			_secret = [_secret] unless Array.isArray _secret
			for s in _secret
				throw new Error '"settings.secret" must be either string or list or strings' unless typeof s is 'string'
		# Context plugins
		Object.defineProperties app.Context.prototype,
			# get cookies
			cookies: get: parseCookies
			signedCookies: get: parseCookies
			# set cookie
			cookie: value: setCookie
			clearCookie: value: clearCookie
		# Request
		Object.defineProperties app.Request.prototype,
			cookies: get: parseCookies
			signedCookies: get: parseCookies
		# end
		return