//
//  PetController.swift
//  SecureAPI
//
//  Created by Stephen Bodnar on 18/09/2017.
//
//

import Foundation
import Vapor

final class PetController {
    let droplet: Droplet
    
    init(drop: Droplet) {
        self.droplet = drop
    }
    
    func addRoutes() {
        droplet.get("viewall", handler: viewAll)
        let apiMiddleware = APIMiddleware()
        let apiProtected = droplet.grouped(apiMiddleware)
        apiProtected.post("create", handler: create)
        
        let adminMiddleware = AdminMiddleware()
        let adminProtected = apiProtected.grouped(adminMiddleware)
        adminProtected.delete("delete", Pet.parameter, handler: delete)
    }
    
    func delete(request: Request) throws -> ResponseRepresentable {
        let pet = try request.parameters.next(Pet.self)
        try pet.delete()
        return Response(status: .ok)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort(.badRequest, reason: "no json")}
        let pet = try Pet(json: json)
        try pet.save()
        return pet
    }
    
    func viewAll(request: Request) throws -> ResponseRepresentable {
        return try Pet.all().makeJSON()
    }
}
