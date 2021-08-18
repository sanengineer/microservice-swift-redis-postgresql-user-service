////
////  File.swift
////
////
////  Created by San Engineer on 18/08/21.
////
//import Foundation
//import Vapor
//import Fluent
//
//final class RegisterLogin: Content, Encodable, Codable, Authenticatable {
//    var id: UUID
//    var username: String
//    var email: String
//    var password: String
//    var name: String
//    var mobile: String?
//    var point_reward: String?
//    var geo_location: String?
//    var city: String?
//    var province: String?
//    var country: String?
//    var domicile: String?
//    var residence: String?
//    var shipping_address_default: String?
//    var shipping_address_id: UUID?
//    var date_of_birth: String?
//    var gender: String?
//    var role_id: Int?
//    var registrationToken: String?
//    var isActive: Bool?
//    var isBlocked: Bool?
//    var created_at: String?
//    var updated_at: String?
//
//
//    init(id: UUID, name: String, username: String, password: String, email: String, mobile: String?, point_reward: String?, geo_location: String?, city: String?, province: String?, country: String?, domicile: String?, residence: String?, shipping_address_default: String?, shipping_address_id: UUID?, date_of_birth: String?, gender: String?, role_id: Int? = nil, registrationToken: String?, isActive: Bool?, isBlocked: Bool?, created_at: String?,updated_at: String?
//    ){
//        self.id = id
//        self.name = name
//        self.username = username
//        self.password = password
//        self.email = email
//        self.mobile = mobile
//        self.city = city
//        self.point_reward = point_reward
//        self.geo_location = geo_location
//        self.province = province
//        self.country = country
//        self.domicile = domicile
//        self.residence = residence
//        self.shipping_address_default = shipping_address_default
//        self.shipping_address_id = shipping_address_id
//        self.date_of_birth = date_of_birth
//        self.gender = gender
//        self.role_id = role_id
//        self.isActive = isActive
//        self.isBlocked = isBlocked
//        self.registrationToken = registrationToken
//        self.created_at = created_at
//        self.updated_at = updated_at
//    }
//
//}
//
//
//
