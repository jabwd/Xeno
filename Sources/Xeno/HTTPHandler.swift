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
        let str = String(bytes: data!, encoding: .utf8)
        print("str \(str)")
        
        var byteBuffer = ctx.channel.allocator.buffer(capacity: 512)
        byteBuffer.write(string: "HTTP/1.1 200 OK\r\nServer: Exurion (unix)\r\nConnection: closed\r\n\r\nHello world")
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
