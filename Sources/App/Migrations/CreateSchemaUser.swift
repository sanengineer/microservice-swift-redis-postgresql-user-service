import Fluent

struct CreateSchemaUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("role_id", .int, .required)
            .field("name", .string, .required)
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("email", .string)
            .field("city", .string)
            .field("mobile", .string)
            .field("point_reward", .string)
            .field("geo_location", .sql(raw: "geometry"))
            .field("province", .string)
            .field("country", .string)
            .field("domicile", .string)
            .field("residence", .string)
            .field("shipping_address_default", .string)
            .field("shipping_address_id", .uuid)
            .field("registrationToken", .sql(raw: "character varying(255)"))
            .field("isActive", .bool)
            .field("isBlocked", .bool)
            .field("date_of_birth", .string)
            .field("gender", .string)
            .field("pin_app", .int)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "username")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
