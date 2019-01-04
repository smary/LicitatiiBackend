import FluentSQLite
import Vapor

final class AuctionCategoryPivot: SQLiteUUIDPivot {
    var id: UUID?
    
    var auctionID: Auction.ID
    var categoryID: Category.ID
    
    // we need the 2 typealiases so that Fluent knows what the left and right types of the pivot are
    typealias Left = Auction
    typealias Right = Category
    
    // setup the 2 id keys for the left and right
    static let leftIDKey: LeftIDKey = \.auctionID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init(_ auctionID: Auction.ID, _ categoryID: Category.ID) {
        self.auctionID = auctionID
        self.categoryID = categoryID
    }
}

extension AuctionCategoryPivot: Migration {}
