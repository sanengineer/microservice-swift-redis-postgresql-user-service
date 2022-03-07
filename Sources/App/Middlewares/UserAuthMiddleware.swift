//
//  File.swift
//  
//
//  Created by San Engineer on 14/08/21.
//

import Vapor
import Fluent

final class UserAuthMiddleware: Middleware {
    
    let authHostname: String = Environment.get("SERVER_HOSTNAME")!
    let authPort: Int = Int(Environment.get("SERVER_PORT")!)!

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        // guard let id_params = request.parameters.get("id") else {
        //     return request.eventLoop.future(error: Abort(.badRequest))
        // }
        
        //debug
        print("\n","HEADER_TOKEN: ", token)
        // print("\n", "TEST", test)
        
        // print("\n","PARAMS_ID: ",id_params, "\n")
        
        return request
            .client
            .post("http://\(authHostname):\(authPort)/user/auth/authenticate", beforeSend: {
                authRequest in
                
                //debug
                // print("\nAUTH_REQUEST: ", try authRequest.content.encode(AuthenticateData(token:token.token), as: .json))
                // print("\nAUTH_DATA: ", try authRequest.content.encode(AuthenticateData(token:token.token)), "\n")
                
                try authRequest.content.encode(AuthenticateData(token:token.token), as: .json)
            })
        
            .flatMapThrowing { response in
                guard let auth = try response.content.decode(Auth.self).role_id, auth == 1 else {
                    throw Abort(.unauthorized)
                }

                // guard let  = try response.content.decode(Auth.self).role_id.self else {
                //     throw Abort(.badRequest, reason: "ROLE_ID")
                // }


                // guard let params_uuid = UUID(uuidString: id_params) else {
                //     throw Abort(.unauthorized, reason: "PARAMS_UUID")
                // }
                

            //    if user_id == params_uuid {
            //     guard response.status == .ok  else {
            //         if response.status == .unauthorized {
            //             throw Abort(.unauthorized, reason: "UNAUTHORIZED")
            //         } else {
            //             throw Abort(.internalServerError)
            //         }
            //     }
            //     } else {
            //         throw Abort(.unauthorized)
            //     }

            //   let data = User.query(on: request.db)
            //    .filter(\.$id == user_id)
            //    .all()
                       
                
               //debug
               print("\n","RESPONSE:\n", response,"\n")
            //    print("\n", "TRYYY\n", try response.content.decode(Auth.self), "\n")
               print("\n","USER:", auth,"\n")
            //    print("\n","QUERY_DB:", data.self,"\n")
            
            }
        
            .flatMap {
                return next.respond(to: request)
            }
    }
    
}
