//
//  HTTPParser.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 19/03/2018.
//

class HTTPRequest {
	
	let method: HTTPMethod
    var headers: [String: String] = [:]
	let body: String
    
    init(_ request: String) {
		let lines = request.split(separator: "\r\n")
		for line in lines {
			
		}
    }
}
