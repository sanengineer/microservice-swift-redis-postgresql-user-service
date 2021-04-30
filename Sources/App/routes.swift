import Vapor
import FluentPostgresDriver
import Fluent
import Redis

func routes(_ app: Application) throws {
    let port: Int
    let redisHostname: String
    let redisPort: Int
    
    if let envPort = Environment.get("PORT_USER_SERVICE") {
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
    
    app.http.server.configuration.port = port
    app.redis.configuration = try RedisConfiguration(hostname: redisHostname, port: redisPort)

    app.databases.use(.postgres(
            hostname: Environment.get("HOSTNAME")!,
            username: Environment.get("USERNAME")!,
            password: Environment.get("PASSWORD")!,
            database: Environment.get("DATABASE")!),
            as: .psql)
    
    app.logger.logLevel = .debug
    
    app.migrations.add(CreateSchemaUser(), AddSomeColumn(), UpdateDataTypeGeoLoc(), DeleteGeoLocOldDataType())
    
    try app.autoMigrate().wait()
    try app.register(collection: UsersController())
    try app.register(collection: AuthController())
    
}
