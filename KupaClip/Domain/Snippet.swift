import SwiftData
import Foundation

@Model
class Snippet {
    @Attribute(.unique) var id: UUID
    var title: String
    var content: String
    var tags: [String]
    @Relationship var folder: Folder?
    var dateCreated: Date
    var dateModified: Date

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        tags: [String] = [],
        folder: Folder? = nil,
        dateCreated: Date = Date(),
        dateModified: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.tags = tags
        self.folder = folder
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}
