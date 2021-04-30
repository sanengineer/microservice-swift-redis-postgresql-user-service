import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let userRouteGroup = routes.grouped("user")
        
        userRouteGroup.post("auth", "register", use: createHandler)
        userRouteGroup.put(":id", use: updateBioHandler)
        userRouteGroup.get( use: getAllHandler)
        userRouteGroup.get("count", use: getUsersNumber)
        userRouteGroup.get(":user_id", use: getOneHanlder)
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db)
            .all()
            .convertToPublic()
    }
    
    func getUsersNumber(_ req: Request) -> EventLoopFuture<Int> {
        User.query(on: req.db)
            .count()
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
    
    func updateBioHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let id = req.parameters.get("id", as: UUID.self)
        let userUpdate = try req.content.decode(UserUpdateBio.self)
        
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
                
                return user.save(on: req.db).map{
                    user.convertToPublic()
                }
            }
    }
}
