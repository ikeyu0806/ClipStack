import Foundation

struct ClipItem: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let date: Date
    var isPinned: Bool = false
}
