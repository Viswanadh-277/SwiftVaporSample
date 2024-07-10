import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "ios_db",
        password: Environment.get("DATABASE_PASSWORD") ?? "Krify@123",
        database: Environment.get("DATABASE_NAME") ?? "ios_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

//    app.migrations.add(CreateTodo())
//    app.logger.logLevel = .debug
    app.migrations.add(CreateSongs())
    try await app.autoMigrate()
    
    // register routes
    try routes(app)
}

//public func configure(_ app: Application) throws {
//    // Configure HTTP server hostname and port
//    app.http.server.configuration.hostname = "0.0.0.0" // Listen on all available interfaces
//    app.http.server.configuration.port = 8080 // Default HTTP port
//
//    // Fetch database configuration from environment variables
//    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
//    let port = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? PostgresConfiguration.ianaPortNumber
//    let username = Environment.get("DATABASE_USERNAME") ?? "ios_db"
//    let password = Environment.get("DATABASE_PASSWORD") ?? "Krify@123"
//    let databaseName = Environment.get("DATABASE_NAME") ?? "ios_database"
//    
//    // Create TLS configuration
//    let tlsConfiguration = TLSConfiguration.forClient()
//
//    // Configure PostgreSQL database
//    let postgresConfiguration = PostgresConfiguration(
//        hostname: hostname,
//        port: port,
//        username: username,
//        password: password,
//        database: databaseName,
//        tlsConfiguration: tlsConfiguration
//    )
//    
//    // Register PostgreSQL database with Fluent
//    app.databases.use(.postgres(configuration: postgresConfiguration), as: .psql)
//
//    // Add migrations
//    app.migrations.add(CreateSongs()) // Replace CreateUser with your actual migration
//
//    // Register routes
//    try routes(app)
//}
