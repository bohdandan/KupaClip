import SwiftData
import Foundation

@Model
class Folder {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship var snippets: [Snippet]
    var dateCreated: Date

    init(id: UUID = UUID(), name: String, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.dateCreated = dateCreated
        self.snippets = []
    }
}
