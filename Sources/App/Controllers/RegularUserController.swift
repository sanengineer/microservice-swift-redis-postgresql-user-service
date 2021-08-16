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
        let regularUserRouteGroup = routes.grouped("user")
        
        regularUserRouteGroup.post("auth","register", use: createRegularUserHandler)
    }
    
    func createRegularUserHandler(_ req: Request) throws -> EventLoopFuture<RegularUser> {
        let user = try req.content.decode(RegularUser.self)
        user.password = try Bcrypt.hash(user.password)
        user.role_id = 3
       
        //debug
        print("\n","USER_PAYLOAD_INPUT:", user, "\n")
        
        return user.save(on: req.db).map{user}.flatMap { userLogin in
            
            RegularUser
                .find(userLogin.id, on: req.db)
                .flatMapThrowing {_ in
                    
                    let token = try Token.generateRegister(for: user)
                    
                    
                    //debug
                    print("\n","REGISTER_USER", user,"\n","\n", "REGISTER_TOKEN:", token.tokenString, token.userId,"\n")
                 
                    req.redis.set(RedisKey(token.tokenString), toJSON: token)
                    
                    user.registrationToken = token.tokenString
                    
                    user.save(on: req.db).map{user}
                    
                        .map { userAfterLogin in
                            
                            RegularUser
                                .find(userAfterLogin.id, on: req.db)
                                .unwrap(or: Abort(.notFound))
                            
                        print("\nTESTTTT",userAfterLogin)
                            


                        }
                    
                    
                }
            
            //debug
            print("\n","USER_LOGIN:", userLogin, "\n")
        }
    }
}
