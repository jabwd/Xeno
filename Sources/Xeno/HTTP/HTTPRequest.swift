//
//  HTTPParser.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 19/03/2018.
//

struct HTTPRequest: CustomStringConvertible {
	
	let method: HTTPMethod
    let path: String
    let headers: [String: String]
	let body: String
    
    init?(request: String) {
        var requestParts = request.split(separator: "\r\n")
        guard requestParts.count > 2 else {
            return nil
        }
		guard let methodAndPath = HTTPRequest.scanHTTPMethodAndPath(requestParts.removeFirst()) else {
			return nil
		}
		let headersAndBody = HTTPRequest.scanHTTPHeadersAndBody(requestParts)
        self.init(method: methodAndPath.method, path: methodAndPath.path, headers: headersAndBody.headers, body: headersAndBody.body)
    }
    
    init(method: HTTPMethod, path: String, headers: [String: String], body: String) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
    
    private static func scanHTTPMethodAndPath(_ line: Substring) -> (method: HTTPMethod, path: String)? {
		let parts = line.split(separator: " ")
        guard parts.count >= 2 else {
            return nil
        }
		guard let method = HTTPMethod(rawValue: String(parts[0])) else {
			return nil
		}
		let path = parts[1]
        return (method, String(path))
    }
	
	private static func scanHTTPHeadersAndBody(_ parts: [Substring]) -> (body: String, headers: [String: String]) {
		var body = ""
		var headers: [String: String] = [:]
		for (index, line) in parts.enumerated() {
			if line.isEmpty == true {
				if (index+1) < parts.count {
					body = String(parts[index+1])
				} else {
					body = ""
				}
				break
			}
			let headerComponents = line.split(separator: ":")
			guard headerComponents.count > 1 else {
				continue
			}
			let value = String(headerComponents[1])
			headers[String(headerComponents[0])] = value.filter {
				if( $0 == " " ) {
					return false
				}
				return true
			}
		}
		return (body, headers)
	}
	
	var description: String {
		return """
				[HTTPRequest start]
					Method:  \(method)
					Path:    \(path)
					Headers: \(headers)
					Body:    '\(body)'
				[HTTPRequest end]
				"""
	}
}
