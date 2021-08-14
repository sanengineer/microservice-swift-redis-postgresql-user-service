//
//  File.swift
//  
//
//  Created by San Engineer on 15/08/21.
//
import Foundation
import Vapor
import Fluent

final class Role: Model {
    static let schema = "roles"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "code")
    var code: String
    
    @Field(key: "description")
    var description: String
    
    init() {}
    
    init(name: String, code: String, description: String) {
        self.name = name
        self.code = code
        self.description = description
    }
    
 
}

extension Role: Content{}


final class RoleUpdate: Codable, Content {
    var description:String
    
    init(description: String) {
        self.description = description
    }
}
