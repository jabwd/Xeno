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
    private let config: Config
    public let router: HTTPRouter
    
    init(host: String, port: Int, config: Config) {
        self.host   = host
        self.port   = port
        self.config = config
        self.router = HTTPRouter()
        
        self.group = MultiThreadedEventLoopGroup(numThreads: System.coreCount)
        let handler = HTTPHandler()
        handler.router = router
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
        let channel = try server.bind(host: host, port: config.defaultPort).wait()
        try channel.closeFuture.wait()
    }
}
