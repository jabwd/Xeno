//
//  HTTPRouter.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 21/03/2018.
//

public class HTTPRouter {
    
    public var routes: [String: Route] = [:]
    
    init() {
        
    }
    
    deinit {
        
    }
    
    internal func route(request: HTTPRequest) -> HTTPResponse {
        if let route = routes[request.host] {
            return route.handle(request: request)
        }
        return HTTPResponse(status: .internalServerError, headers: [:], body: "Error, no routes available")
    }
}
