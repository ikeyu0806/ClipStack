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
        
        if clipboardString != lastClipboardContent {
            lastClipboardContent = clipboardString
            let newItem = ClipItem(content: clipboardString, date: Date())
            history.insert(newItem, at: 0) // 最新を先頭に
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
}
