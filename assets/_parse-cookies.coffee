###
Parse cookies
###
createCookieParser = (settings)->
	->
		cookieHeader = @req.headers.cookie
		cookies = cookieHeader and (cookie.parse cookieHeader, settings) or Object.create null
		# parse JSON
		for k,v of cookies
			try
				# decode cookie if it is
				if _secret and v.startsWith 's:'
					val = v.substr 2
					for s in _secret
						val2 = signature.unsign val, s
						unless val2 is false
							v = val2
							break
				# parse json value
				if v.startsWith 'j:'
					cookies[k] = JSON.parse v.substr 2
			catch e
				@warn 'Cookie-parser', e
		# return value
		Object.defineProperty this, 'cookies', value: cookies
		Object.defineProperty this, 'signedCookies', value: cookies
		return cookies




