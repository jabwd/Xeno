import Foundation

let config = try Data(contentsOf: URL(string: "file:///usr/local/etc/xeno/xeno.json")!)
let decoder = JSONDecoder()
let cfg = try decoder.decode(Config.self, from: config)

let server = Xeno(host: "0.0.0.0", port: 8080, config: cfg)

class FileRouter: Route {
    func handle(request: HTTPRequest) -> HTTPResponse {
		let dir = cfg.sites[0].directoryRoot
		var path = request.path
		if path == "/" {
			path = "/index.html"
		}
		// This path thing is unsafe, should not ever work like this :'D
		guard let fileURL = URL(string: "file://\(dir)\(path)") else {
			return HTTPResponse(status: .notFound, headers: [:], body: "Not found")
		}
		print("Request URL: \(fileURL)")
		guard let data = try? Data(contentsOf: fileURL) else {
			return HTTPResponse(status: .notFound, headers: [:], body: "File not found")
		}
        let str = String(data: data, encoding: .utf8) ?? ""
        return HTTPResponse(status: .ok, headers: [:], body: str)
    }
}
server.router.routes["localhost"] = FileRouter()

do {
    try server.run()
} catch {
    print("\(error)")
}
