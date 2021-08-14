//
//  File.swift
//  
//
//  Created by San Engineer on 15/08/21.
//

import Fluent

struct DeleteSchemaRoles: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("roles").delete()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("roles").delete()
    }
}
