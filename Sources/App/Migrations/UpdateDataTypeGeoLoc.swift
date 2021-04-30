import Fluent

struct UpdateDataTypeGeoLoc: Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .field("geo_location", .sql(raw: "geometry"))
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
