//
//  File.swift
//  
//
//  Created by San Engineer on 14/08/21.
//

import Vapor
import Fluent

final class UserAuthMiddleware: Middleware {
    
    let authUrl: String = Environment.get("SERVER_URL")!

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
         guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
       
         //debug
        print("\nTOKEN_HEADERS: \(token)")
        print("\nAUTH_URL: \(authUrl)")
        


        return request
            .client
            .post("\(authUrl)/user/auth/authenticate", beforeSend: {
                authRequest in
                
                //debug
                // print("\nAUTH_REQUEST: ", try authRequest.content.encode(AuthenticateData(token:token.token), as: .json))
                // print("\nAUTH_DATA: ", try authRequest.content.encode(AuthenticateData(token:token.token)), "\n")
                
                try authRequest.content.encode(AuthenticateData(token:token.token), as: .json)
            })
        
            .flatMapThrowing { response in
                guard let role_id = try response.content.decode(Auth.self).role_id else {
                    throw Abort(.unauthorized)
                }
                
                if role_id == 3 || role_id == 1 {
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

                       
               //debug
               print("\n","RESPONSE:\n", response,"\n")
            //    print("\n", "TRYYY\n", try response.content.decode(Auth.self), "\n")
               print("\n","ROLE_ID:", role_id,"\n")
            
            }
        
            .flatMap {
                return next.respond(to: request)
            }
    }
    
}
