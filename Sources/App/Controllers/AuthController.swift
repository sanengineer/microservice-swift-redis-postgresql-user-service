
import Vapor
import Redis
import Fluent

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let authMiddleware = User.authenticator()
        let globalUserAuthRoutesGroup = routes.grouped("superuser","auth")
        let globalUserAuthMiddlewareGroup = globalUserAuthRoutesGroup.grouped(authMiddleware)
    
        globalUserAuthMiddlewareGroup.post("login", use: loginHandler)
        globalUserAuthRoutesGroup.post("authenticate", use: authenticationGlobalUserHandler)

        
    }
    
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {
        
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        
        //debug
        print("\n","LOGIN_USER", user,"\n","\n", "LOGIN_TOKEN:", token.tokenString, token.userId,"\n")
        
        return req.redis.set(RedisKey(token.tokenString), toJSON: token).transform(to: token)
    
    }
    
    func authenticationGlobalUserHandler(_ req: Request) throws -> EventLoopFuture<User.GlobalAuth> {
        
        let role_id = req.parameters.get("role_id", as: Int.self)
        let data = try req.content.decode(AuthenticateData.self)
        
        //debug
        print("\n","DATA-AUTH_HANDLER:",data, "\n")
        
        return req.redis
            .get(RedisKey(data.token), asJSON: Token.self)
            .flatMap { token in
                guard let token = token else {
                    return req.eventLoop.future(error: Abort(.unauthorized))
                }
                
                //debug
                print("\n","AUTH_CONTROLLER-TOKEN_USERID:", token.userId,"\n",
                     "\n", "AUTH_CONTROLLER-TOKEN_TOKEN_STRING:", token.tokenString ,"\n",
                      "\n", "AUTH_CONTROLLER-TOKEN_USERNAME:", token.username ,"\n")
                
                return User.query(on: req.db)
                    .filter(\.$id == token.userId)
                    .filter(\.$username == token.username)
                    .filter(\.$role_id == role_id)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .convertToGlobalAuth()
          
            }
    }
    
}

struct AuthenticateData: Content {
    let token: String
}
