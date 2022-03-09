import Vapor
import FluentPostgresDriver
import Fluent
import Redis


public func configure(_ app: Application) throws {
    
 let port: Int
    let redisHostname: String
    let redisPort: Int
    let redisUrl: String
    let dbUrl: String
    
    guard let serverHostname = Environment.get("SERVER_HOSTNAME") else {
        return print("No Env Server Hostname")
    }
    
    if let envPort = Environment.get("SERVER_PORT") {
        port = Int(envPort) ?? 8081
    } else {
        port = 8081
    }
    
    if let redisEnvHostname = Environment.get("HOSTNAME_REDIS") {
         redisHostname = redisEnvHostname
    } else {
        redisHostname = "localhost"
    }
    
    
    if let redisEnvPort = Environment.get("PORT_REDIS") {
         redisPort = Int(redisEnvPort) ?? 6379
    } else {
        redisPort = 6379
    }

    if let redisUrlEnv = Environment.get("REDIS_TLS_URL"){
        redisUrl = redisUrlEnv
        app.redis.configuration = try RedisConfiguration(url: redisUrl)
    } else {
        // redisUrl = "http://\(redisHostname):\(redisPort)"
        app.redis.configuration = try RedisConfiguration(hostname: redisHostname, port: redisPort)
    }
    
  
    // app.redis.configuration = try RedisConfiguration(hostname: redisHostname, port: redisPort)
    // app.redis.configuration = try RedisConfiguration(url: redisUrl)

    if let dbUrlEnv = Environment.get("DATABASE_URL"){
        dbUrl = dbUrlEnv
        try app.databases.use(.postgres(url: dbUrl), as: .psql)
        print("DB_URL: \(dbUrl)")
    } else {
        app.databases.use(.postgres(
            hostname: Environment.get("DB_HOSTNAME")!,
            port: Environment.get("DB_PORT").flatMap(Int.init(_:))!,
            username: Environment.get("DB_USERNAME")!,
            password: Environment.get("DB_PASSWORD")!,
            database: Environment.get("DB_NAME")!),
            as: .psql)
    }

    
    
    app.logger.logLevel = .debug
    app.http.server.configuration.port = port
    app.http.server.configuration.hostname = serverHostname
    
    app.migrations.add(CreateSchemaRoles())
    app.migrations.add(CreateSchemaUser())
    app.migrations.add(SeedDBRoles())
    
    //migration
    try app.autoMigrate().wait()

    //register routes
    try routes(app)
    
}
