//
//  Pet.swift
//  SecureAPI
//
//  Created by Stephen Bodnar on 18/09/2017.
//
//
import Vapor
import FluentProvider
import HTTP

final class Pet: Model {
    let storage = Storage()
    var name: String
    
    static let idKey = "id"
    static let nameKey = "name"
    
    init(name: String) {
        self.name = name
    }
    
    init(row: Row) throws {
        name = try row.get(Pet.nameKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Pet.nameKey, name)
        return row
    }
}

extension Pet: ResponseRepresentable { }


extension Pet: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Pet.nameKey)
        }
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Pet: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(Pet.nameKey)
        )
    }
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Pet.idKey, id)
        try json.set(Pet.nameKey, name)
        return json
    }
}
