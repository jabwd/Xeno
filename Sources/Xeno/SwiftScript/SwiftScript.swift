
#if os(Linux)
import Glibc
#else
import Darwin
import Foundation

class SwiftScript {
    
    let outputPipe: Pipe
    let errorPipe:  Pipe
    
    init?(path: String) {
        let fileActions = UnsafeMutablePointer<posix_spawn_file_actions_t?>.allocate(capacity: 1)
        posix_spawn_file_actions_init(fileActions)
        
        guard let p = Pipe() else {
            return nil
        }
        guard let e = Pipe() else {
            return nil
        }
        outputPipe = p
        errorPipe  = e
        
        posix_spawn_file_actions_addclose(fileActions, outputPipe.readingFD)
        posix_spawn_file_actions_addclose(fileActions, errorPipe.readingFD)
        posix_spawn_file_actions_adddup2(fileActions, outputPipe.writingFD, 1)
        posix_spawn_file_actions_adddup2(fileActions, errorPipe.writingFD, 2)
        
        posix_spawn_file_actions_addclose(fileActions, outputPipe.writingFD)
        posix_spawn_file_actions_addclose(fileActions, errorPipe.writingFD)
        
        
        var processID: pid_t = 0
        let params: [String] = [
            "/",
            "-la"
        ]
        let values = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: params.count)
        defer {
            values.deinitialize(count: params.count)
            values.deallocate(capacity: params.count)
        }
        var temps = [Array<UInt8>]()
        for (i, value) in params.enumerated() {
            temps.append(Array<UInt8>(value.utf8) + [0])
            let rawValue = UnsafeMutablePointer<UInt8>(mutating: temps.last!)
            rawValue.withMemoryRebound(to: Int8.self, capacity: temps.last!.count) { bufferPointer in
                values[i] = UnsafeMutablePointer<Int8>(bufferPointer)
            }
        }
        posix_spawn(&processID, "/bin/ls", fileActions, nil, values, nil)
        
        outputPipe.closeWriting()
        errorPipe.closeWriting()
        
        /*var buffer = [UInt8](repeating: 0, count: 1024)
        let bytesRead = read(cout[0], &buffer, buffer.count)
        
        print("Bytes read: \(bytesRead)")
        if bytesRead > 0 {
            let slice = Array(buffer[0..<bytesRead])
            let str = String(bytes: slice, encoding: .utf8)
            print("str: \(str)")
        }
        
        let errorBytesRead = read(cerr[0], &buffer, buffer.count)
        
        if errorBytesRead > 0 {
            let slice = Array(buffer[0..<errorBytesRead])
            let str = String(bytes: slice, encoding: .utf8)
            print("Error: \(str)")
        }
        
        print("Error bytes read: \(errorBytesRead)")*/
        
        posix_spawn_file_actions_destroy(fileActions)
        fileActions.deallocate()
    }
}
#endif
