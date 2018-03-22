import Foundation

let config = try Data(contentsOf: URL(string: "file:///usr/local/etc/xeno/xeno.json")!)
let decoder = JSONDecoder()
let cfg = try decoder.decode(Config.self, from: config)

let server = Xeno(host: "0.0.0.0", port: 8080, config: cfg)

class FileRouter: Route {
    func handle(request: HTTPRequest) -> HTTPResponse {
        let testPage = try! Data(contentsOf: URL(string: "file:///Users/jabwd/Desktop/Xeno.html")!)
        let str = String(data: testPage, encoding: .utf8)!
        return HTTPResponse(status: .ok, headers: [:], body: str)
    }
}
server.router.routes["localhost"] = FileRouter()

do {
    try server.run()
} catch {
    print("\(error)")
}
