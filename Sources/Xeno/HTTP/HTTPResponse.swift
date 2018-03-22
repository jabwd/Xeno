//
//  HTTPResponse.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 20/03/2018.
//

/**
 cache-control: max-age=0, private
 content-encoding: gzip
 content-security-policy: default-src https: data: blob: 'unsafe-inline' 'unsafe-eval'; form-action https:; frame-ancestors tweakers.net *.tweakers.net tweakimg.net *.tweakimg.net
 content-type: text/html; charset=ISO-8859-15
 date: Wed, 21 Mar 2018 13:08:28 GMT
 expires: -1
 p3p: CP="ALL DSP COR CURa ADMa DEVa HISa OUR STP UNI STA"
 server: Apache
 set-cookie: tc=1521637708%2C1521637692; expires=Fri, 20-Apr-2018 13:08:28 GMT; Max-Age=2592000; path=/; domain=.tweakers.net; secure
 status: 200
 strict-transport-security: max-age=31536000; includeSubDomains; preload
 vary: Accept-Encoding
 x-clacks-overhead: GNU Terry Pratchett
 x-content-type-options: nosniff
 x-tweakers-server: twk-tc3-web4
 x-xss-protection: 1; mode=block
 **/

public struct HTTPResponse {
    
    private static var defaultHeaders: [String: String] = [
        "cache-control": "max-age=0",
        "content-type": "text/html;charset=utf-8",
        "server": "Xeno",
        "expires": "-1",
        "vary": "Accept-Encoding",
        "x-xeno-version": Constants.versionLong
    ]
    
	let status: HTTPStatusCode
	let headers: [String: String]
	let body: String
	
	var generated: String {
		let generatedHeaders = headers.reduce("") { (str, value) in
			return "\(str)\(value.key): \(value.value)\r\n"
		}
        let standardHeaders = HTTPResponse.defaultHeaders.reduce("") { (str, value) in
            return "\(str)\(value.key): \(value.value)\r\n"
        }
        print("Standard: \(standardHeaders)")
		return "HTTP/1.1 \(status.rawValue) \(status.reason)\r\n\(standardHeaders)\(generatedHeaders)\r\n\(body)"
	}
}
