import Vapor
import FluentPostgresDriver
import Redis

public func configure(_ app: Application) throws {
    let port: Int
    
    if let envPort = Environment.get("PORT_USER_SERVICE") {
        port = Int(envPort) ?? 8081
    } else {
        port = 8081
    }
    
    app.http.server.configuration.port = port
    
    app.databases.use(.postgres(
            hostname: Environment.get("HOSTNAME")!,
            username: Environment.get("USERNAME")!,
            password: Environment.get("PASSWORD")!,
            database: Environment.get("DATABASE")!),
            as: .psql)
    
    app.logger.logLevel = .debug
    
    app.migrations.add(CreateSchemaUser())
    
    try app.autoMigrate().wait()
    
    try routes(app)
    
}
