###*
 * Cookie parser for GridFW
 * @copyright khalid RAFIK 2018
###
'use strict'

cookie = require 'cookie'
CryptoJS = require('crypto-js')
AESCrypto = CryptoJS.AES

class Cookie
	constructor: (@app)->
		@enabled = on # the plugin is enabled
	###*
	 * Reload parser
	###
	reload: (settings)->
		settings ?= Object.create null
		#=include _set-cookie.coffee
		#=include _parse-cookies.coffee
		# secret
		_secret = settings.secret
		throw new Error "settings.secret expected string or null" if _secret and typeof _secret isnt 'string'
		# cookie parser
		@_parseCookie = parseCookie
		@_setCookie = setCookie
		# enable
		@enable()
		return
	###*
	 * destroy
	###
	destroy: ->
		emptyObj=
			value: null
			configurable: on
		Object.defineProperties @app.Context.prototype,
			# get cookies
			cookies: emptyObj
			signedCookies: emptyObj
			# set cookie
			cookie: emptyObj
			clearCookie: emptyObj
		# Request
		emptyCookie =
			get: -> {}
			configurable: on
		Object.defineProperties @app.Request.prototype,
			cookies: emptyCookie
			signedCookies: emptyCookie
		return
	###*
	 * Disable, enable
	###
	disable: -> @destroy
	enable: ->
		# methods
		parseCookie = @_parseCookie
		setCookie = @_setCookie
		clearCookie = @_clearCookie
		# Context plugins
		Object.defineProperties @app.Context.prototype,
			# get cookies
			cookies:
				get: parseCookie
				configurable: on
			signedCookies:
				get: parseCookie
				configurable: on
			# set cookie
			cookie:
				value: setCookie
				configurable: on
			clearCookie:
				value: clearCookie
				configurable: on
		# Request
		Object.defineProperties @app.Request.prototype,
			cookies:
				get: parseCookie
				configurable: on
			signedCookies:
				get: parseCookie
				configurable: on
		return

	###*
	 * Clear cookie
	 * @example
	 * ctx.clearCookie('name', options)
	###
	_clearCookie: (name, options)->
		options ?= Object.create null
		options.expires ?= new Date 1
		options.path	?= '/'
		@cookie name, '', options
module.exports = Cookie