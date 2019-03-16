###*
 * Cookie parser for GridFW
 * @copyright khalid RAFIK 2018
###
'use strict'

cookie = require 'cookie'
CryptoJS = require('crypto-js')
AESCrypto = CryptoJS.AES


###*
 * Clear cookie
 * @example
 * ctx.clearCookie('name', options)
###
_clearCookie= (name, options)->
	options ?= Object.create null
	options.expires ?= new Date 1
	options.path	?= '/'
	@cookie name, '', options

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
		# properties
		@fxes=
			Request: Object.create null,
				cookies:
					get: parseCookie
					configurable: on
				signedCookies:
					get: parseCookie
					configurable: on
			Context: Object.create null,
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
					value: _clearCookie
					configurable: on
		# enable
		@enable()
		return
	###*
	 * destroy
	###
	destroy: ->
		@app.removeProperties 'Cookie', @fxes
		return
	###*
	 * Disable, enable
	###
	disable: -> @destroy
	enable: ->
		# Context plugins
		@app.addProperties 'Cookie', @fxes
		return

module.exports = Cookie