//
//  HTTPParser.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 19/03/2018.
//

struct HTTPRequest {
	
	let method: HTTPMethod
    let path: String
    let headers: [String: String]
	let body: String
    
    init?(request: String) {
        let requestParts = request.split(separator: ":")
        guard requestParts.count > 2 else {
            return nil
        }
        
        self.init(method: .get, path: "" , headers: [:], body: "")
    }
    
    init(method: HTTPMethod, path: String, headers: [String: String], body: String) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
    
    private static func scanHTTPMethodAndPath(_ line: Substring) -> (method: HTTPMethod, path: String)? {
        let parts = line.split(separator: " ")
        guard parts.count > 2 else {
            return nil
        }
        return nil
    }
    
   /* init(_ request: String) {
        let requestParts = request.split(separator: "\r\n")
        
        
        
        
        body = ""
		let lines = request.split(separator: "\r\n")
		for (index, line) in lines.enumerated() {
            if line.isEmpty == true {
                if (index+1) < lines.count {
                    body = String(lines[index+1])
                } else {
                    body = ""
                }
                break
            }
            let parts = line.split(separator: ":")
            guard parts.count > 1 else {
                continue
            }
            headers[String(parts[0])] = String(parts[1])
		}
        method = .get
    }*/
}
