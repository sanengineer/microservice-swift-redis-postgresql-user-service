//
//  File.swift
//  
//
//  Created by San Engineer on 14/08/21.
//

import Vapor
import Fluent

final class AdminAuthMiddleware: Middleware {
    
    let authHostname: String = Environment.get("SERVER_HOSTNAME")!
    let authPort: Int = Int(Environment.get("SERVER_PORT")!)!
    let authUrl: String = Environment.get("SERVER_URL")!

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        return request
            .client
            .post("\(authUrl)/user/auth/authenticate", beforeSend: {
                authRequest in
                try authRequest.content.encode(AuthenticateData(token:token.token), as: .json)
            })
        
            .flatMapThrowing { response in
                guard let role_id = try response.content.decode(Auth.self).role_id else {
                    throw Abort(.unauthorized)
                }

              
               if role_id == 1 {
                guard response.status == .ok  else {
                    if response.status == .unauthorized {
                        throw Abort(.unauthorized, reason: "UNAUTHORIZED")
                    } else {
                        throw Abort(.internalServerError)
                    }
                }
                } else {
                    throw Abort(.unauthorized)
                }

            
            }
        
            .flatMap {
                return next.respond(to: request)
            }
    }
    
}
