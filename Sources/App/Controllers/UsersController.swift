import Vapor

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.post(use: createUserHandler)
        usersRoute.get(use: getAllUsersHandler)
    }
    
    
    // MARK: - CRUD operations
    
    // create user
    func createUserHandler(_ req: Request) throws -> Future<User> {
        // parse the incoming data, because we conformed User to Content
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }
    
    // get list of all users
    func getAllUsersHandler(_ req: Request) -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    
    
}
