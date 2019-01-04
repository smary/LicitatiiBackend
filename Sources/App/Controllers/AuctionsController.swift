import Vapor
import Fluent

struct AuctionsController: RouteCollection {
    func boot(router: Router) throws {
        let auctionsRoute = router.grouped("api", "auctions")
        // CRUD
        auctionsRoute.post(use: createHandler)
        auctionsRoute.get(use: getAllHandler)
        
        // Relations
        auctionsRoute.get(Auction.parameter, "owner", use: getOwnerHandler)
        auctionsRoute.get(Auction.parameter, "bidders", use: getBiddersHandler)
        auctionsRoute.get(Auction.parameter, "categories", use: getCategoriesHandler)
        auctionsRoute.post(Auction.parameter, "categories", Category.parameter, use: addToCategoryHandler)
        
        // Search
        // Route Example: http://localhost:8080/api/auctions/search?term=OMG
        auctionsRoute.get("search", use: searchHandler)
    }
    
    
    // MARK: - CRUD operations
    
    // create user
    func createHandler(_ req: Request) throws -> Future<Auction> {
        // parse the incoming data, because we conformed User to Content
        return try req.content.decode(Auction.self).flatMap { auction in
            return auction.save(on: req)
        }
    }
    
    // get list of all users
    func getAllHandler(_ req: Request) -> Future<[Auction]> {
        return Auction.query(on: req).all()
    }
    
    // MARK: - Relations - User
    
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
    
    
    // MARK: - Relations - Category
    
    // get all categories under which this auction is listed
    func getCategoriesHandler(_ req: Request) throws -> Future<[Category]> {
        // pull out the auction as a parameter and return its categoriess
        return try req.parameters.next(Auction.self).flatMap(to: [Category].self) { auction in
            return try auction.categories.query(on: req).all()
        }
    }
    
    //add auction to a category
    func addToCategoryHandler(_ req: Request) throws -> Future<HTTPStatus> {
        // pull out both the auction and the category parameters, and we can use flat map
        return try flatMap(to: HTTPStatus.self,
                           req.parameters.next(Auction.self),
                           req.parameters.next(Category.self))
        { auction, category in
            // create the pivot using the requireID function to make sure that the auction and category ids have been set
            let pivot = try AuctionCategoryPivot(auction.requireID(), category.requireID())
            return pivot.save(on: req).transform(to: .ok)
        }
    }
    
    
    
    // MARK: - Search function
    // Route Example: http://localhost:8080/api/auctions/search?term=OMG
    
    func searchHandler(_ req: Request) throws -> Future<[Auction]> {
        // get the search term from the request's query; returns an optional String, so use guard
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest, reason:"Missing search term in request")
        }
        return Auction.query(on: req).group(.or) { or in
            or.filter(\.name == searchTerm)
            or.filter(\.description == searchTerm)
            }.all()
        
        
//        Galaxy.query(on: conn).filter(\.mass >= 500).filter(\.type == .spiral)
//        return Auction.query(on: req).filter(\.name == searchTerm).all()
    }

}

