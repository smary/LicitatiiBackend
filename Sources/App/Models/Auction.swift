import FluentSQLite
import Vapor

final class Auction: SQLiteModel {
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

