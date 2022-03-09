import Vapor

func routes(_ app: Application) throws {

    try app.register(collection: UsersController())
    try app.register(collection: RolesController())
    // try app.register(collection: RegularUserController())
    try app.register(collection: AuthController())
    
}
