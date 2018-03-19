//
//  File.swift
//  Xeno
//
//  Created by Antwan van Houdt on 19/03/2018.
//

import NIO

public final class Xeno {
    
    public let host: String
    public let port: Int
    
    private let group: EventLoopGroup
    private let server: ServerBootstrap
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
        
        self.group = MultiThreadedEventLoopGroup(numThreads: System.coreCount)
        let handler = HTTPHandler()
        self.server = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.add(handler: handler)
            }
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    }
    
    deinit {
        try! group.syncShutdownGracefully()
    }
    
    // MARK: -
    
    public func run() throws {
        let channel = try server.bind(host: host, port: port).wait()
        try channel.closeFuture.wait()
    }
}
