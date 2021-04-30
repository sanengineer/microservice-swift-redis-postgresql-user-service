import Foundation
import Vapor
import Fluent


final class User: Model {
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "mobile")
    var mobile: String
    
    @Field(key: "point_reward")
    var point_reward: String
    
    @Field(key: "geo_loc")
    var geo_loc: String
    
    @Field(key: "city")
    var city: String
    
    @Field(key: "province")
    var province: String
    
    @Field(key: "country")
    var country: String
    
    @Field(key: "domicile")
    var domicile: String
    
    @Field(key: "residence")
    var residence: String
    
    @Field(key: "shipping_address_default")
    var shipping_address_default: String
    
    @Field(key: "shipping_address_id")
    var shipping_address_id: UUID
    
    
    init(
        name: String,
        username: String,
        password: String,
        email: String,
        mobile: String,
        point_reward: String,
        geo_loc: String,
        city: String,
        province: String,
        country: String,
        domicile: String,
        residence: String,
        shipping_address_default: String,
        shipping_address_id: UUID
        ){
        self.name = name
        self.username = username
        self.password = password
        self.email = email
        self.mobile = mobile
        self.city = city
        self.point_reward = point_reward
        self.geo_loc = geo_loc
        self.province = province
        self.country = country
        self.domicile = domicile
        self.residence = residence
        self.shipping_address_default = shipping_address_default
        self.shipping_address_id = shipping_address_id
    }
    
    init() {}
    
    final class Auth: Content {
        var id: UUID?
        var name: String
        var username: String
        
        init(id: UUID?, name: String, username: String) {
            self.id = id
            self.name = name
            self.username = username
        }
    }
    
//    init(){}
    
    final class Public: Content {
        var id: UUID?
        var name: String
        var username: String
        var email: String
        var mobile: String
        var point_reward: String
        var geo_loc: String
        var city: String
        var province: String
        var country: String
        var domicile: String
        var residence: String
        var shipping_address_default: String
        var shipping_address_id: UUID
        
        init(
            id: UUID?,
            name: String,
            username: String,
            email: String,
            mobile: String,
            point_reward: String,
            geo_loc: String,
            city: String,
            province: String,
            country: String,
            domicile: String,
            residence: String,
            shipping_address_default: String,
            shipping_address_id: UUID
        ){
            self.id = id
            self.name = name
            self.username = username
            self.email = email
            self.mobile = mobile
            self.city = city
            self.point_reward = point_reward
            self.geo_loc = geo_loc
            self.province = province
            self.country = country
            self.domicile = domicile
            self.residence = residence
            self.shipping_address_default = shipping_address_default
            self.shipping_address_id = shipping_address_id
        }
    }
}

extension User: Content {}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(
            id: id,
            name: name,
            username: username,
            email: email,
            mobile: mobile,
            point_reward: point_reward,
            geo_loc: geo_loc,
            city: city,
            province: province,
            country: country,
            domicile: domicile,
            residence: residence,
            shipping_address_default: shipping_address_default,
            shipping_address_id: shipping_address_id
        )
    }
    
    func convertToAuth() -> User.Auth {
        return User.Auth(id: id, name: name, username: username)
    }
}


extension EventLoopFuture where Value: User {
    func convertToPublic() -> EventLoopFuture<User.Public> {
        return self.map { user in
            return user.convertToPublic()
        }
    }
    
    func convertToAuth() -> EventLoopFuture<User.Auth> {
        return self.map { user in
            return user.convertToAuth()
        }
    }
}

extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        return self.map { $0.convertToPublic() }
    }
    
    func convertToAuth() -> [User.Auth] {
        return self.map{ $0.convertToAuth() }
    }
}

extension EventLoopFuture where Value == Array<User> {
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        return self.map { $0.convertToPublic() }
    }
    
    func convertToAuth() -> EventLoopFuture<[User.Auth]> {
        return self.map { $0.convertToAuth() }
    }
}

extension User: ModelAuthenticatable {
    
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool  {
        try Bcrypt.verify(password, created: self.password)
    }
    
}
