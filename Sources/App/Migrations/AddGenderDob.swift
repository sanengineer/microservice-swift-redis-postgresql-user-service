import Fluent

struct AddGenderDobColumn: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
        .field("date_of_birth", .string)
        .field("gender", .string)
        .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    } 
}