//
//  File.swift
//  
//
//  Created by San Engineer on 15/08/21.
//

import Vapor
import Redis
import Fluent

struct RegularUserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let authMiddleware = User.authenticator()
        let userRouteGroup = routes.grouped("user")
        let userRouteMiddlewareGroup = userRouteGroup.grouped(UserAuthMiddleware())
        
        //debug
        print("\nTESTTTT",authMiddleware, "\n")
        
        routes.post("auth","register", use: createUser)
        userRouteMiddlewareGroup.get(":id", use: getOneUser)
        userRouteMiddlewareGroup.put(":id", use: updateUserBio)
    }
    
    func createUser(_ req: Request) throws -> EventLoopFuture<User.GlobalAuth> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        user.role_id = 3
       
        //debug
        print("\n","USER_PAYLOAD_INPUT:", user, "\n")

        return user.save(on: req.db).map{
            user.convertToGlobalAuth()
        }
    }
    
    func getOneUser(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func updateUserBio(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let id = req.parameters.get("id", as: UUID.self)
        let userUpdate = try req.content.decode(RegularUserUpdateBio.self)
//        let userUpdate = try req.content.decode(User.self)
        
        return User
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ user in
                
               print("\n\nUSER:\n",user, "\n\n")
                
                user.mobile = userUpdate.mobile
                user.point_reward = userUpdate.point_reward
                user.geo_location = userUpdate.geo_location
                user.city = userUpdate.city
                user.province = userUpdate.province
                user.country = userUpdate.country
                user.domicile = userUpdate.domicile
                user.residence = userUpdate.residence
                user.shipping_address_default = userUpdate.shipping_address_default
                user.shipping_address_id = userUpdate.shipping_address_id
                user.date_of_birth = userUpdate.date_of_birth
                user.gender = userUpdate.gender
                
                return user.save(on: req.db).map{
                    user.convertToPublic()
                }
            }
    }
    
    
    
}
