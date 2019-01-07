import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a MySQL database
    let mysql = MySQLDatabase(config: MySQLDatabaseConfig(hostname: "localhost",
                                                          port: 3306,
                                                          username: "auctions",
                                                          password: "password",
                                                          database: "vapor",
                                                          capabilities: .default,
                                                          characterSet: .utf8_general_ci,
                                                          transport: .cleartext))

    /// Register the configured MySQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Auction.self, database: .mysql)
    migrations.add(model: Category.self, database: .mysql)
    migrations.add(model: AuctionUserPivot.self, database: .mysql)
    migrations.add(model: AuctionCategoryPivot.self, database: .mysql)
    services.register(migrations)

}
