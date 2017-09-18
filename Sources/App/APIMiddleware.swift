//
//  APIMiddleware.swift
//  SecureAPI
//
//  Created by Stephen Bodnar on 17/09/2017.
//
//

import Vapor
import HTTP

final class AdminMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let adminUsername = "admin"
        guard let username = request.data["username"]?.string else {
            throw Abort.unauthorized
        }
        if username != adminUsername {
            throw Abort.unauthorized
        } else { return try next.respond(to: request) }
    }
}

final class APIMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let validToken = "w2$ly2$ByEITKwlyByEITK5BE20DIcvma5BE20DIcvma"
        
        guard let authHeader = request.headers["Authorization"]?.string else {
            throw Abort.unauthorized
        }
        if authHeader != validToken {
            throw Abort.unauthorized
        } else { return try next.respond(to: request) }
    } 
}
