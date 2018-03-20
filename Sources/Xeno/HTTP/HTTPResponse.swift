//
//  HTTPResponse.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 20/03/2018.
//

struct HTTPResponse {
	let status: HTTPStatusCode
	let headers: [String: String]
	let body: String
	
	var generated: String {
		let generatedHeaders = headers.reduce("") { (key, value) in
			return "\(key): \(value)\r\n"
		}
		return "HTTP/1.1 \(status.rawValue) \(status.reason)\r\n\(generatedHeaders)\r\n\(body)"
	}
}
