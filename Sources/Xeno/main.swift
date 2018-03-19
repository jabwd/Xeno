let server = Xeno(host: "0.0.0.0", port: 8080)
do {
    try server.run()
} catch {
    print("\(error)")
}
