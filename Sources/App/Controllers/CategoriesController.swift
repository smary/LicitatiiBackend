import Vapor

struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "categories")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(Category.parameter, "auctions", use: getAuctionsHandler)
    }
    
    //MARK: - CRUD operations
    
    //handler to create a category that will return a future Category
    func createHandler (_ req: Request) throws -> Future<Category> {
        return try req.content.decode(Category.self).flatMap { category in
            return category.save(on: req)
        }
    }
    
    // handler to retrieve the array of all Categories
    func getAllHandler (_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    
    // MARK: - Relations
    
    // handler that gets all auctions listed under this category
    func getAuctionsHandler(_ req: Request) throws -> Future<[Auction]> {
        return try req.parameters.next(Category.self).flatMap(to: [Auction].self) { category in
            return try category.auctions.query(on: req).all()
        }
    }
}


