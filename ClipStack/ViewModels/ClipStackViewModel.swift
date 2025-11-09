import Foundation
import SwiftUI
import Combine

@MainActor
class ClipStackViewModel: ObservableObject {
    @Published var history: [ClipItem] = []
    
    private var timer: Timer?
    private var lastClipboardContent: String = ""
    
    init() {
        startMonitoringClipboard()
    }
    
    func startMonitoringClipboard() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    private func checkClipboard() {
        guard let clipboardString = NSPasteboard.general.string(forType: .string) else { return }
        
        // 新しい内容なら追加
        if clipboardString != lastClipboardContent {
            lastClipboardContent = clipboardString
            
            // 既に同じ内容がある場合は重複登録しない
            if !history.contains(where: { $0.content == clipboardString }) {
                let newItem = ClipItem(content: clipboardString, date: Date())
                history.insert(newItem, at: 0)
            }
        }
    }
    
    func clearHistory() {
        history.removeAll()
    }
    
    func copyToClipboard(_ item: ClipItem) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.content, forType: .string)
        lastClipboardContent = item.content
    }
    
    func togglePin(for item: ClipItem) {
        if let index = history.firstIndex(where: { $0.id == item.id }) {
            history[index].isPinned.toggle()
            reorderHistory()
        }
    }
    
    private func reorderHistory() {
        // ピン留めされた項目を上に、日時順で並べ替え
        history.sort { lhs, rhs in
            if lhs.isPinned != rhs.isPinned {
                return lhs.isPinned && !rhs.isPinned
            } else {
                return lhs.date > rhs.date
            }
        }
    }
}
