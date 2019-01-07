import Vapor

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.delete(User.parameter, use: deleteHandler)
        usersRoute.get(User.parameter, "initiatedAuctions", use:getInitiatedAuctionsHandler)
        usersRoute.get(User.parameter, "activeAuctions", use:getActiveAuctionsHandler)
        usersRoute.post(User.parameter, "activeAuctions", Auction.parameter, use:addAuctionHandler)
    }
    
    
    // MARK: - CRUD operations
    
    // Saves a decoded User to the database
    func createHandler(_ req: Request) throws -> Future<User> {
        // parse the incoming data, because we conformed User to Content
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }
    
    /// Deletes a parameterized `User`.
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
        }.transform(to: .ok)
    }

    
    // get list of all users
    func getAllHandler(_ req: Request) -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    
    // MARK:- Relations
    
    // get all auctions initiated by a certain user
    func getInitiatedAuctionsHandler(_ req: Request) throws -> Future<[Auction]> {
        return try req.parameters.next(User.self).flatMap(to: [Auction].self) { user in
            return try user.initiatedAuctions.query(on: req).all()
        }
    }
    
    //get all the actions this user participates in
    func getActiveAuctionsHandler(_ req: Request) throws -> Future<[Auction]> {
        return try req.parameters.next(User.self).flatMap(to: [Auction].self) {user in
            return try user.activeAuctions.query(on: req).all()
        }
    }
    
    //register this user for a specific auction, adding a new POST route
    // returns a simple HTTPStatus
    func addAuctionHandler (_ req: Request) throws -> Future<HTTPStatus> {
        // pull out both the User and the Auction parameters using the direct call flatMap
        return try flatMap(to: HTTPStatus.self, req.parameters.next(User.self), req.parameters.next(Auction.self)) {
            user, auction in
            // create the pivot, using the requireID function to be sure the user's and the auction's ids have been set
            let pivot = try AuctionUserPivot(auction.requireID(), user.requireID())
            //save the pivot and return the result as an HTTPStatus
            return pivot.save(on: req).transform(to: .ok)
                            
        }
    }
}
