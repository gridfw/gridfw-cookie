###
Parse cookies
###
parseCookies = ->
	cookieHeader = @headers.cookie
	cookies = cookieHeader and (cookie.parse cookieHeader, settings) or Object.create null
	# parse JSON
	for k,v of cookies
		try
			cookies[k] = JSON.parse v if v.startsWith 'j:'
		catch e
			@warn 'Cookie-parser', e
	# return value
	Object.defineProperty this, 'cookies', value: cookies
	return cookies

###*
 * Parse signed cookies
 * @return {[type]} [description]
###
parseSignedCookies = ->
	signedCookies = Object.create null
	if _secret
		cookies = @cookies
		for k,v of cookies
			try
				if v.startsWith 's:'
					v = v.substr 2
					for s in _secret
						val = signature.unsign v, s
						unless val is false
							signedCookies[k] = val
							break

			catch e
				@warn 'Cookie-parser', e
	# return
	Object.defineProperty this, 'signedCookies', value: signedCookies
	return signedCookies




