//
//  Pipe.swift
//  XenoPackageDescription
//
//  Created by Antwan van Houdt on 21/03/2018.
//

import Dispatch
#if os(Linux)
import Glibc
#else
import Darwin
#endif

class Pipe {
    
    private var raw: [Int32]
    private var readingSource: DispatchSourceRead? = nil
    private let queue: DispatchQueue = DispatchQueue(label: "Test")
    
    var readingFD: Int32 {
        get {
            return raw[0]
        }
    }
    var writingFD: Int32 {
        get {
            return raw[1]
        }
    }
    
    init?() {
        raw = [Int32](repeating: 0, count: 2)
        
        guard pipe(&raw) == 0 else {
            return nil
        }
        close(raw[1]) // We only want to get output back rn
        
        readingSource = DispatchSource.makeReadSource(fileDescriptor: raw[0], queue: queue)
        readingSource?.setEventHandler {
            self.readAvailableData()
        }
        readingSource?.setCancelHandler {
            self.readingSource = nil
        }
        readingSource?.resume()
    }
    
    deinit {
        close(raw[0])
        close(raw[1])
        
        print("Deallocated")
    }
    
    func closeWriting() {
        close(raw[1])
    }
    
    func closeReading() {
        close(raw[0])
    }
    
    private func readAvailableData() {
        print("Trying to read available data.")
        let buffSize = 2084
        
        // Using UnsafeMutablePointer here crashes for some reason.
        var buffer: [UInt8] = [UInt8](repeating: 0, count: 0)
        var len = 0
        repeat {
            let part = UnsafeMutablePointer<UInt8>.allocate(capacity: buffSize)
            len = read(raw[0], part, buffSize)
            if len > 0 {
                buffer += Array(UnsafeMutableBufferPointer(start: part, count: len))
            }
            part.deallocate(capacity: buffSize)
        } while( len == buffSize );
        if len <= 0 {
            return
        }
        print("Read: \(buffer)")
    }
}
