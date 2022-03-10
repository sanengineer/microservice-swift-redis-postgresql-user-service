//
//  File.swift
//  
//
//  Created by San Engineer on 15/08/21.
//

import Vapor

struct RolesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {

        let adminMiddleware = AdminAuthMiddleware()
        let routeGroup = routes.grouped("role")
        let routeGroupMiddleware = routeGroup.grouped(adminMiddleware)
       
        routeGroupMiddleware.get(use: getAllHandler)
        routeGroupMiddleware.post(use: createHandler)
        routeGroupMiddleware.put(":id", use: updateHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Role]> {
        Role.query(on: req.db)
            .all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Role> {
        let role = try req.content.decode(Role.self)
        return role.save(on: req.db).map { role }
    }
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Role> {
        let id = req.parameters.get("id", as: Int.self)
        let roleUpdate = try req.content.decode(RoleUpdate.self)
        
        return Role
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ role in
                //debug
                print("\n","ROLE:", role.description,"=", roleUpdate.description, "\n")
                
                role.description = roleUpdate.description
                
                return role.save(on: req.db).map {role}
            }
    }
}
