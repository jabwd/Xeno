//
//  Route.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 21/03/2018.
//

import Foundation

public protocol Route {
    func handle(request: HTTPRequest) -> HTTPResponse
}
