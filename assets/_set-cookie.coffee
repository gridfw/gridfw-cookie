###*
 * Set cookie
 * @example
 * ctx.cookie('name', 'value', options)
###
setCookie= (name, value, options)->
	throw new Error 'Cookie name required' unless name
	# stringify value
	unless typeof value is 'string'
		value = value and ('j:' + JSON.stringify value) or ''
	# signe cookie
	if options.signed
		throw new Error 'No secret set to signe this cookie!' unless _secret
		value = 's:' + sign value, _secret
	# max age
	if 'maxAge' of options
		options.expires = new Date Date.now() + options.maxAge
	# path
	options.path ?= '/'
	# set as header
	@res.header 'Set-Cookie', cookie.serialize name, value, options
	# chain
	this


###*
 * Clear cookie
 * @example
 * ctx.clearCookie('name', options)
###
clearCookie = (name, options)->
	options ?= Object.create null
	options.expires ?= new Date 1
	options.path	?= '/'
	@cookie name, '', options
