import Fluent

struct AddSomeColumn: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .field("email", .string)
            .field("city", .string)
            .field("mobile", .string)
            .field("point_reward", .string)
            .field("geo_loc", .sql(raw: "geometry"))
            .field("province", .string)
            .field("country", .string)
            .field("domicile", .string)
            .field("residence", .string)
            .field("shipping_address_default", .string)
            .field("shipping_address_id", .uuid)
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
