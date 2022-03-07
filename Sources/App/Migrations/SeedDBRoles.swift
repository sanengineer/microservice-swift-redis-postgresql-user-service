import Fluent

struct SeedDBRoles: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let roles: [Role] = [
         .init(name: "Super User", code: "super_user", description: "User can do everything"),
         .init(name: "Mid User", code: "mid_user", description: "User can do something"),
         .init(name: "Regular User", code: "low_user", description: "User cad do little thing")  
        ]

        return roles.map {
            role in 
            role.save(on: database)
        }
        .flatten(on: database.eventLoop)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        Role.query(on: database).delete()
    }
}
