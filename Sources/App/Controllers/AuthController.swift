
import Vapor
import Redis
import Fluent

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let authRoutesGroup = routes.grouped("user","auth")
        let authMiddleware = User.authenticator()
        
        let authMiddlewareGroup = authRoutesGroup.grouped(authMiddleware)
        
        authMiddlewareGroup.post("login", use: loginHandler)
        authRoutesGroup.post("authenticate", use: authenticationHandler)
        
    }
    
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {
        
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        
        return req.redis.set(RedisKey(token.tokenString), toJSON: token).transform(to: token)
    
    }
    
    func authenticationHandler(_ req: Request) throws -> EventLoopFuture<User.Auth> {
        
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
                print("\n","AUTH_CONTROLLER-TOKEN_USERID:", token.userId,"\n", "AUTH_CONTROLLER-TOKEN_TOKEN_STRING:", token.tokenString ,"\n")
                
                return User.query(on: req.db)
                    .filter(\.$id == token.userId)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .convertToAuth()
          
            }
    }
}

struct AuthenticateData: Content {
    let token: String
}
