
struct Config: Codable {
    let sites: [ConfigWebsite]
    
    let defaultPort: Int
    let errorPageDirectory: String
}

struct ConfigWebsite: Codable {
    let hostName:      String?
    let directoryRoot: String
}
