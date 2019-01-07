import FluentMySQL
import Vapor

final class AuctionUserPivot: MySQLUUIDPivot {
    var id: UUID?
    
    var auctionID: Auction.ID
    var userID: User.ID
    
    // we need the 2 typealiases so that Fluent knows what the left and right types of the pivot are
    typealias Left = Auction
    typealias Right = User
    
    // setup the 2 id keys for the left and right
    static let leftIDKey: LeftIDKey = \.auctionID
    static let rightIDKey: RightIDKey = \.userID
    
    init(_ auctionID: Auction.ID, _ userID: User.ID) {
        self.auctionID = auctionID
        self.userID = userID
    }
}

extension AuctionUserPivot: Migration {}
