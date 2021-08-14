//
//  File.swift
//  
//
//  Created by San Engineer on 15/08/21.
//

import Fluent

struct CreateSchemaRoles: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("roles")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .field("code", .string, .required)
            .field("description", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "name")
            .unique(on: "code")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("roles").delete()
    }
}
