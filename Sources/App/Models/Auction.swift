import FluentMySQL
import Vapor

final class Auction: MySQLModel {
    //    Fluent automatically looks for a property called id that stores an optional integer.
    var id: Int? // optional because it will be initialized when adding it to the database
    
    var name: String
    var description: String
    // TODO Add photo support
    //var photo: Data
    var startingPrice: Int
    var nbOfWinners: Int
    var ownerID: User.ID

    
    init(name: String, description: String, startingPrice: Int, nbOfWinners: Int, ownerID:User.ID) {
        self.name = name
        self.description = description
        self.startingPrice = startingPrice
        self.nbOfWinners = nbOfWinners
        self.ownerID = ownerID
    }
}

/// Allows `Auction` to be encoded to and decoded from HTTP messages.
extension Auction: Content {}

/// Allows `Auction` to be used as a dynamic migration.
extension Auction: Migration {}

/// Allows `Auction` to be used as a dynamic parameter in route definitions.
extension Auction: Parameter {}


extension Auction {
    
    // Parent-child relationship with the owner of this auction
    var owner: Parent<Auction, User> {
        return parent(\.ownerID)
    }
    
    
    // Sibling realtionship with User:
    // A user can participate on multiple auctions and an auction can have multiple bidders (users)
    var bidders: Siblings<Auction, User, AuctionUserPivot> {
        return siblings()
    }
    
    // Siblings relationship with Category
    // An auction can be listed under multiple categories and a category can represent multiple auctions
    var categories: Siblings<Auction, Category, AuctionCategoryPivot> {
        return siblings()
    }

}



