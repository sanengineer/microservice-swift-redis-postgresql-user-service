//
//  File.swift
//  
//
//  Created by San Engineer on 15/08/21.
//

import Foundation
import Vapor
import Fluent

final class RegularUser: Model {
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "registrationToken")
    var registrationToken: String?
    
    @Field(key: "role_id")
    var role_id: Int
    
    init(
        name: String,
        username: String,
        email: String,
        password: String
    ){
        self.name = name
        self.username = username
        self.email = email
        self.password = password
    }
    
    init() {}
    
    final class Auth: Content, Codable {
        var id: UUID?
        var name: String
        var username: String
        var email: String
        var registrationToken: String?
       
        
        init(id: UUID? = nil, name:String, username:String, email: String, registrationToken: String? = nil) {
            self.id = id
            self.name = name
            self.username = username
            self.email = email
            self.registrationToken = registrationToken
        }
    }
}

extension RegularUser: Content {}


final class RegularUserAuth: Content, Codable {
    var id: UUID?
    var name: String
    var username: String
    var email: String
    var token: String
   
    
    init(id: UUID? = nil, name:String, username:String, email: String, token: String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.token = token
    }
}


extension RegularUser {
    func convertToAuthRegularUser() -> RegularUser.Auth {
        return RegularUser.Auth(id: id, name: name, username: username, email: email, registrationToken: registrationToken)
    }
}


//extension EventLoopFuture where Value: RegularUser {
//    func convertToAuthRegularUser() -> EventLoopFuture<RegularUser.Auth> {
//        return self.map { user in
//            return user.convertToAuthRegularUser()
//        }
//    }
//}

//extension Collection where Element: RegularUser {
//
//    func convertToAuthOrdinaryUser() -> [RegularUser.Auth] {
//        return self.map{ $0.convertToAuthRegularUser() }
//    }
//}
