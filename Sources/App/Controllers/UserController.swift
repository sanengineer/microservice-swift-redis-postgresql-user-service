import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let adminMiddleware = AdminAuthMiddleware()
        let routeGroup = routes.grouped("user")
        let routeGroupMiddleware = routeGroup.grouped(adminMiddleware)


        // let testGroup = routes.grouped("user")

        routeGroupMiddleware.get( use: getAllHandler)
        // testGroup.get("count", use: getUsersNumber)
        routeGroupMiddleware.get("count", use: getUsersNumber)
        routeGroupMiddleware.get(":id", use: getOneHanlder)
        routeGroup.post(use: createHandler)
        routeGroupMiddleware.put(":id", use: updateBioHandler)
    
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db)
            .all()
            .convertToPublic()
    }
    
    func getUsersNumber(_ req: Request) throws -> EventLoopFuture<Int> {
        // let token = try req.

        // print("\n","PARAM_QUERY_TOKEN", token )
        
       return User.query(on: req.db)
            .count()
    }
    
    func getOneHanlder(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User.GlobalAuth> {
        
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        
        //debug
        print("\n","USER_PAYLOADL:", user, "\n")
        
        return user.save(on: req.db).map {
            user.convertToGlobalAuth()
        }
    }
    
    
    
    func updateBioHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let id = req.parameters.get("id", as: UUID.self)
        let userUpdate = try req.content.decode(UserUpdateBio.self)
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
