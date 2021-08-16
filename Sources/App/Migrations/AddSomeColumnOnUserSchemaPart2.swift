//
//  File.swift
//  
//
//  Created by San Engineer on 15/08/21.
//

import Fluent

struct AddSomeColumnOnSchemaUserPart2: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .field("registrationToken", .sql(raw: "character varying(255)"))
            .field("isActive", .bool)
            .field("isBlocked", .bool)
            .field("role_id", .int)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("pin_app", .int)
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
