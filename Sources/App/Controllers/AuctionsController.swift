import Vapor

struct AuctionsController: RouteCollection {
    func boot(router: Router) throws {
        let auctionsRoute = router.grouped("api", "auctions")
        auctionsRoute.post(use: createAuctionHandler)
        auctionsRoute.get(use: getAllAuctionsHandler)
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
    
    
    
}
