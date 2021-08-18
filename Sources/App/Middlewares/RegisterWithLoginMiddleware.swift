//
//  File.swift
//  
//
//  Created by San Engineer on 17/08/21.
//

import Vapor

final class RegisterWithLoginMiddleware: Middleware {
    
    let authHostname: String = Environment.get("SERVER_HOSTNAME")!
    let authPort: Int = Int(Environment.get("SERVER_PORT")!)!

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        
        do{
            let user = try request.content.decode(User.self)
//            user.password = try Bcrypt.hash(user.password)
//            user.role_id = 3
//            
//            try user.save(on: request.db).wait()
            
            //debug
            print("\n","USER:",user,"\n")
            
            
          

        }
        catch {
            print(error)
        }

        return request.eventLoop.future().flatMap { user in
            //debug
            print("\n","USERRRRr:",user,"\n")
            
            
            
            return next.respond(to: request)
        }
    }

}
