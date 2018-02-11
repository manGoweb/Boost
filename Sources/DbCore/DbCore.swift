//
//  DbCore.swift
//  DbCore
//
//  Created by Ondrej Rafaj on 12/01/2018.
//

import Foundation
import Vapor
import FluentPostgreSQL


public typealias DbCoreDatabase = PostgreSQLDatabase
public typealias DbCoreIdentifier = Int
public typealias DbCoreColumnType = PostgreSQLColumn


public class DbCore {
    
    public static var migrationConfig = MigrationConfig()
    
    public static func config(hostname: String, user: String, password: String?, database: String, port: UInt16 = 3306) -> DatabaseConfig {
        var databaseConfig = DatabaseConfig()
        let config = PostgreSQLDatabaseConfig(hostname: hostname, port: port, username: user, database: database, password: password)
        let database = DbCoreDatabase(config: config)
        databaseConfig.add(database: database, as: .db)
        return databaseConfig
    }
    
    public static func envConfig(defaultHostname: String = "localhost", defaultUser: String = "root", defaultPassword: String? = nil, defaultDatabase: String, defaultPort: UInt16 = 3306) -> DatabaseConfig {
        let env = ProcessInfo.processInfo.environment as [String: String]
        let host = env["DB_HOST"] ?? defaultHostname
        let port = UInt16(env["DB_PORT"] ?? "n/a") ?? defaultPort
        let user = env["DB_USER"] ?? defaultUser
        let pass = env["DB_PASSWORD"] ?? defaultPassword
        let dtbs = env["DB_NAME"] ?? defaultDatabase
        return config(hostname: host, user: user, password: pass, database: dtbs, port: port)
    }
    
    public static func configure(databaseConfig: DatabaseConfig,_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
        try services.register(FluentPostgreSQLProvider())
        
        services.register(databaseConfig)
        services.register(migrationConfig)
    }
    
}
