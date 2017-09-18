import Vapor

extension Droplet {
    func setupRoutes() throws {
        
        let apiMiddleware = APIMiddleware()
        let apiProtected = grouped(apiMiddleware)
        
        apiProtected.get("hello") { request in
            return "You have accessed a protected route"
        }
        
        let petControler = PetController(drop: self)
        petControler.addRoutes()
    }
}


