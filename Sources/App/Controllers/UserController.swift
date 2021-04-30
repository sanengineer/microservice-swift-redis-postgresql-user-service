import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let userRouteGroup = routes.grouped("user")
        
        userRouteGroup.post("auth", "register", use: createHandler)
        userRouteGroup.get( use: getAllHandler)
        userRouteGroup.get(":user_id", use: getOneHanlder)
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db)
            .all()
            .convertToPublic()
    }
    
    func getOneHanlder(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("user_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }
}
