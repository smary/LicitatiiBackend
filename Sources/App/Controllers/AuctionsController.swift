import Vapor

struct AuctionsController: RouteCollection {
    func boot(router: Router) throws {
        let auctionsRoute = router.grouped("api", "auctions")
        auctionsRoute.post(use: createAuctionHandler)
        auctionsRoute.get(use: getAllAuctionsHandler)
        auctionsRoute.get(Auction.parameter, "owner", use: getOwnerHandler)
        auctionsRoute.get(Auction.parameter, "bidders", use: getBiddersHandler)
    }
    
    
    // MARK: - CRUD operations
    
    // create user
    func createAuctionHandler(_ req: Request) throws -> Future<Auction> {
        // parse the incoming data, because we conformed User to Content
        return try req.content.decode(Auction.self).flatMap { auction in
            return auction.save(on: req)
        }
    }
    
    // get list of all users
    func getAllAuctionsHandler(_ req: Request) -> Future<[Auction]> {
        return Auction.query(on: req).all()
    }
    
    // MARK: - Relations
    
    //get the owner for a particular auction
    func getOwnerHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(Auction.self).flatMap(to: User.self) { auction in
            return auction.owner.get(on: req)
        }
    }
    
    //get all the bidders of this auction
    func getBiddersHandler(_ req: Request) throws -> Future<[User]> {
        return try req.parameters.next(Auction.self).flatMap(to: [User].self) { auction in
            return try auction.bidders.query(on: req).all()
        }
    }
    
}

