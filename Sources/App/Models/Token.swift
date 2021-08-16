import Vapor
import Fluent

final class Token: Content {
    var id: UUID?
    var tokenString: String
    var userId: UUID
    
    init(tokenString: String, userId: UUID) {
        self.tokenString = tokenString
        self.userId = userId
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = [UInt8].random(count: 32)
        return try Token(tokenString: random.base64, userId: user.requireID())
    }

}


