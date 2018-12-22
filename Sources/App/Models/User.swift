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

