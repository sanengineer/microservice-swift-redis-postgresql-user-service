import Foundation
import Vapor
import Fluent


struct UrlQueryAuthUser: Content {
    let token: String
    let username: String

    init(token: String, username: String){
        self.token = token
        self.username = username
    }
    
}
