import FluentSQLite
import Vapor


final class User: SQLiteUUIDModel {
    var id: UUID?
    
    var username: String
    var email: String
    var fbName: String = ""
    var password: String = ""
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
}

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content {} // brings Codable protocol with it

/// Allows `User` to be used as a dynamic migration.
extension User: Migration {}

/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter {}


// get auctions initiated by a certain user
extension User {
    var initiatedAuctions: Children<User, Auction> {
        // return all the children with that ownerID
        return children(\.ownerID)
    }
    
    
    // Sibling realtionship with User:
    // A user can participate on multiple auctions and an auction can have multiple bidders (users)
    var activeAuctions: Siblings<User, Auction, AuctionUserPivot> {
        return siblings()
    }
}
