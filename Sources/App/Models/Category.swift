import FluentMySQL
import Vapor

final class Category : MySQLModel {
    var id: Int?
    var name: String
    init(name: String) {
        self.name = name
    }
}
/// Allows `Category` to be encoded to and decoded from HTTP messages.
extension Category: Content {}

/// Allows `Category` to be used as a dynamic migration.
extension Category: Migration {}

/// Allows `Category` to be used as a dynamic parameter in route definitions.
extension Category: Parameter {}

// Sibling realtionship with User:
// A user can participate on multiple auctions and an auction can have multiple bidders (users)
extension Category {
    var auctions: Siblings<Category, Auction, AuctionCategoryPivot> {
        return siblings()
    }
}
