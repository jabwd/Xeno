//
//  HTTPHandler.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 19/03/2018.
//

import NIO
import Foundation

internal class HTTPHandler: ChannelInboundHandler {
    typealias InboundIn  = ByteBuffer
    typealias OutboundIn = ByteBuffer
    
    func channelActive(ctx: ChannelHandlerContext) {
        //print("Channel active! \(ObjectIdentifier(ctx.channel))")
    }
    
    func errorCaught(ctx: ChannelHandlerContext, error: Error) {
        print("Error: \(error)")
    }
    
    func channelInactive(ctx: ChannelHandlerContext) {
    }
    
    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        var dataBuffer = unwrapInboundIn(data)
        let data = dataBuffer.readBytes(length: dataBuffer.readableBytes)
        let str = String(bytes: data!, encoding: .utf8) ?? ""
		guard let req = HTTPRequest(request: str) else {
			let response = HTTPResponse(status: .internalServerError, headers: [:], body: "")
			send(response: response, ctx: ctx)
			return
		}
		
		let response = HTTPResponse(status: .ok, headers: [:], body: "<html><body><h1>Xeno</h1></body></html>")
		send(response: response, ctx: ctx)
    }
	
	func send(response: HTTPResponse, ctx: ChannelHandlerContext) {
		let raw = response.generated
		var byteBuffer = ctx.channel.allocator.buffer(capacity: raw.count)
		byteBuffer.write(string: raw)
		ctx.writeAndFlush(NIOAny(byteBuffer)).whenComplete {
			ctx.close(promise: nil)
		}
	}
    
    func channelWritabilityChanged(ctx: ChannelHandlerContext) {
        print("Writability changed!")
    }
}

extension HTTPHandler: ChannelOutboundHandler {
}
